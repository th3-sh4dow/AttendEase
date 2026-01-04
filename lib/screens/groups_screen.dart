import 'package:flutter/material.dart';
import '../models/student_group.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../services/file_service.dart';
import 'attendance_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<StudentGroup> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
    });
    
    final groups = await StorageService.getGroups();
    setState(() {
      _groups = groups;
      _isLoading = false;
    });
  }

  Future<void> _createNewGroup() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _CreateGroupDialog(),
    );

    if (result != null) {
      final groupId = StorageService.generateGroupId();
      final now = DateTime.now();
      
      final group = StudentGroup(
        id: groupId,
        name: result['name'],
        description: result['description'],
        students: result['students'] ?? <Student>[],
        createdAt: now,
        updatedAt: now,
      );

      await StorageService.saveGroup(group);
      await _loadGroups();
      _showSnackBar('Group "${group.name}" created successfully');
    }
  }

  Future<void> _editGroup(StudentGroup group) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _CreateGroupDialog(group: group),
    );

    if (result != null) {
      final updatedGroup = group.copyWith(
        name: result['name'],
        description: result['description'],
        students: result['students'],
        updatedAt: DateTime.now(),
      );

      await StorageService.saveGroup(updatedGroup);
      await _loadGroups();
      _showSnackBar('Group "${updatedGroup.name}" updated successfully');
    }
  }

  Future<void> _deleteGroup(StudentGroup group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${group.name}"?\n\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.deleteGroup(group.id);
      await _loadGroups();
      _showSnackBar('Group "${group.name}" deleted');
    }
  }

  void _useGroup(StudentGroup group) async {
    await StorageService.setLastUsedGroup(group.id);
    
    // Reset attendance for all students
    final studentsForAttendance = group.students.map((s) => Student(
      rollNumber: s.rollNumber,
      name: s.name,
      isPresent: false,
    )).toList();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceScreen(students: studentsForAttendance),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Groups'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? _buildEmptyState()
              : _buildGroupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewGroup,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Groups Created Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first group to get started',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createNewGroup,
            icon: const Icon(Icons.add),
            label: const Text('Create Group'),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                group.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              group.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (group.description.isNotEmpty) Text(group.description),
                const SizedBox(height: 4),
                Text(
                  '${group.students.length} students • Created ${_formatDate(group.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'use':
                    _useGroup(group);
                    break;
                  case 'edit':
                    _editGroup(group);
                    break;
                  case 'delete':
                    _deleteGroup(group);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'use',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Use Group'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _useGroup(group),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CreateGroupDialog extends StatefulWidget {
  final StudentGroup? group;

  const _CreateGroupDialog({this.group});

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _studentNameController = TextEditingController();
  List<Student> _students = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameController.text = widget.group!.name;
      _descriptionController.text = widget.group!.description;
      _students = List.from(widget.group!.students);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rollNumberController.dispose();
    _studentNameController.dispose();
    super.dispose();
  }

  void _addStudent() {
    if (_rollNumberController.text.trim().isEmpty || 
        _studentNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter both roll number and name');
      return;
    }

    final rollNumber = _rollNumberController.text.trim();
    
    if (_students.any((s) => s.rollNumber == rollNumber)) {
      _showSnackBar('Student with this roll number already exists');
      return;
    }

    setState(() {
      _students.add(Student(
        rollNumber: rollNumber,
        name: _studentNameController.text.trim(),
      ));
    });

    _rollNumberController.clear();
    _studentNameController.clear();
    _showSnackBar('Student added');
  }

  void _removeStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  Future<void> _uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final students = await FileService.pickAndParseFile();
      if (students != null) {
        setState(() {
          _students.addAll(students);
        });
        _showSnackBar('${students.length} students loaded from file');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter group name');
      return;
    }

    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'students': _students,
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group == null ? 'Create New Group' : 'Edit Group',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'Add Students',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rollNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Roll Number',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _studentNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addStudent,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _uploadFile,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: const Text('Upload File'),
            ),
            const SizedBox(height: 12),
            Text(
              'Students (${_students.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _students.isEmpty
                  ? const Center(
                      child: Text(
                        'No students added yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                            child: Text(
                              student.rollNumber.substring(
                                  student.rollNumber.length - 2),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          title: Text(student.name),
                          subtitle: Text(student.rollNumber),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeStudent(index),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(widget.group == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
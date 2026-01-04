import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/student_group.dart';
import '../services/file_service.dart';
import '../services/storage_service.dart';
import 'attendance_screen.dart';
import 'developer_screen.dart';
import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _rollNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final List<Student> _students = [];
  bool _isLoading = false;
  StudentGroup? _lastUsedGroup;

  @override
  void initState() {
    super.initState();
    _loadLastUsedGroup();
  }

  @override
  void dispose() {
    _rollNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadLastUsedGroup() async {
    final lastGroupId = await StorageService.getLastUsedGroup();
    if (lastGroupId != null) {
      final group = await StorageService.getGroup(lastGroupId);
      if (group != null) {
        setState(() {
          _lastUsedGroup = group;
        });
      }
    }
  }

  void _addStudent() {
    if (_rollNumberController.text.trim().isEmpty || 
        _nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter both roll number and name');
      return;
    }

    final rollNumber = _rollNumberController.text.trim();
    
    // Check for duplicate roll numbers
    if (_students.any((s) => s.rollNumber == rollNumber)) {
      _showSnackBar('Student with this roll number already exists');
      return;
    }

    setState(() {
      _students.add(Student(
        rollNumber: rollNumber,
        name: _nameController.text.trim(),
      ));
    });

    _rollNumberController.clear();
    _nameController.clear();
    _showSnackBar('Student added successfully');
  }

  void _removeStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
    _showSnackBar('Student removed');
  }

  Future<void> _uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final students = await FileService.pickAndParseFile();
      if (students != null) {
        setState(() {
          _students.clear();
          _students.addAll(students);
        });
        _showSnackBar('File uploaded successfully. ${students.length} students loaded.');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _proceedToAttendance() {
    if (_students.isEmpty) {
      _showSnackBar('Please add students or upload a file first');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(students: List.from(_students)),
      ),
    );
  }

  void _useLastGroup() async {
    if (_lastUsedGroup != null) {
      await StorageService.setLastUsedGroup(_lastUsedGroup!.id);
      
      // Reset attendance for all students
      final studentsForAttendance = _lastUsedGroup!.students.map((s) => Student(
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
  }

  Future<void> _saveAsGroup() async {
    if (_students.isEmpty) {
      _showSnackBar('Please add students first');
      return;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => _SaveGroupDialog(),
    );

    if (result != null && result.isNotEmpty) {
      final groupId = StorageService.generateGroupId();
      final now = DateTime.now();
      
      final group = StudentGroup(
        id: groupId,
        name: result,
        description: '',
        students: List.from(_students),
        createdAt: now,
        updatedAt: now,
      );

      await StorageService.saveGroup(group);
      setState(() {
        _lastUsedGroup = group;
      });
      _showSnackBar('Group "$result" saved successfully');
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
        title: const Text('AttendEase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GroupsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeveloperScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Access Card
            if (_lastUsedGroup != null)
              Card(
                color: Colors.blue.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Quick Access',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _lastUsedGroup!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_lastUsedGroup!.students.length} students',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _useLastGroup,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Use This Group'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_lastUsedGroup != null) const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Students',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _rollNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Roll Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addStudent,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Student'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Students (${_students.length})',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (_students.isNotEmpty)
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: _saveAsGroup,
                                  icon: const Icon(Icons.save, size: 16),
                                  label: const Text('Save as Group'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _students.clear();
                                    });
                                  },
                                  child: const Text('Clear All'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _students.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.school, size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'No students added yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add students manually or upload a file',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final student = _students[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(student.rollNumber.substring(
                                        student.rollNumber.length - 2)),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _students.isEmpty ? null : _proceedToAttendance,
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark Attendance'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveGroupDialog extends StatefulWidget {
  @override
  State<_SaveGroupDialog> createState() => _SaveGroupDialogState();
}

class _SaveGroupDialogState extends State<_SaveGroupDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save as Group'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Group Name',
          border: OutlineInputBorder(),
          hintText: 'Enter group name',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
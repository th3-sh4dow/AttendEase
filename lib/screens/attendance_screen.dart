import 'package:flutter/material.dart';
import '../models/student.dart';
import 'result_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final List<Student> students;

  const AttendanceScreen({super.key, required this.students});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Student> _students;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _students = widget.students;
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var student in _students) {
        student.isPresent = _selectAll;
      }
    });
  }

  void _toggleStudentAttendance(int index, bool? value) {
    setState(() {
      _students[index].isPresent = value ?? false;
      _updateSelectAllState();
    });
  }

  void _updateSelectAllState() {
    final presentCount = _students.where((s) => s.isPresent).length;
    setState(() {
      _selectAll = presentCount == _students.length;
    });
  }

  void _submitAttendance() {
    final presentCount = _students.where((s) => s.isPresent).length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Attendance'),
        content: Text(
          'Present: $presentCount\n'
          'Absent: ${_students.length - presentCount}\n\n'
          'Do you want to submit this attendance?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(students: _students),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presentCount = _students.where((s) => s.isPresent).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Students: ${_students.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Present: $presentCount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _selectAll,
                      onChanged: _toggleSelectAll,
                    ),
                    const Text('Select All'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          for (var student in _students) {
                            student.isPresent = false;
                          }
                          _selectAll = false;
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
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: CheckboxListTile(
                    value: student.isPresent,
                    onChanged: (value) => _toggleStudentAttendance(index, value),
                    title: Text(
                      student.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(student.rollNumber),
                    secondary: CircleAvatar(
                      backgroundColor: student.isPresent 
                          ? Colors.green 
                          : Colors.grey,
                      child: Icon(
                        student.isPresent 
                            ? Icons.check 
                            : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    activeColor: Colors.green,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitAttendance,
                icon: const Icon(Icons.send),
                label: const Text('Submit Attendance'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/student.dart';

class FileService {
  static Future<List<Student>?> pickAndParseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String contents = await file.readAsString();
        return parseStudentData(contents);
      }
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
    return null;
  }

  static List<Student> parseStudentData(String data) {
    List<Student> students = [];
    List<String> lines = data.split('\n');
    
    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty) {
        try {
          students.add(Student.fromString(line));
        } catch (e) {
          throw FormatException('Invalid format in line: "$line"');
        }
      }
    }
    
    return students;
  }
}
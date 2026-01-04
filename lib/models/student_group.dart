import 'student.dart';

class StudentGroup {
  final String id;
  final String name;
  final String description;
  final List<Student> students;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.students,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      students: (json['students'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'students': students.map((student) => student.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  StudentGroup copyWith({
    String? id,
    String? name,
    String? description,
    List<Student>? students,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      students: students ?? this.students,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class Student {
  final String rollNumber;
  final String name;
  bool isPresent;

  Student({
    required this.rollNumber,
    required this.name,
    this.isPresent = false,
  });

  factory Student.fromString(String line) {
    final parts = line.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid format. Expected "rollnumber:name"');
    }
    return Student(
      rollNumber: parts[0].trim(),
      name: parts[1].trim(),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      rollNumber: json['rollNumber'],
      name: json['name'],
      isPresent: json['isPresent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'name': name,
      'isPresent': isPresent,
    };
  }

  @override
  String toString() {
    return '$rollNumber:$name';
  }
}
import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _tile("Name", student['userName']),
            _tile("Email", student['userEmail']),
            _tile("Branch", student['branch']),
            _tile("Year", student['year']),
            _tile("CGPA", student['cgpa']),
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        "$title: ${value ?? ""}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
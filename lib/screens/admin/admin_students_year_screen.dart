import 'package:flutter/material.dart';
import 'admin_student_list_screen.dart';

class AdminStudentsYearScreen extends StatelessWidget {
  const AdminStudentsYearScreen({super.key});

  final years = const [
    "First Year",
    "Second Year",
    "Third Year",
    "Fourth Year"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students by Year")),
      backgroundColor: const Color(0xFFEFF3F5),

      body: ListView(
        children: years.map((year) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(year),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminStudentListScreen(year: year),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminStudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> student;

  const AdminStudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final profiles = student['profiles'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            _tile("Name", student['name']),
            _tile("Email", student['email']),
            _tile("Branch", student['branch']),
            _tile("Year", student['year']),
            _tile("CGPA", student['cgpa']),

            const SizedBox(height: 20),

            // 🔥 RESUME
            const Text("Resume",
                style: TextStyle(fontWeight: FontWeight.bold)),

            TextButton(
              onPressed: () {
                final url = student['resume'];
                if (url != null && url != "") {
                  launchUrl(Uri.parse(url));
                }
              },
              child: const Text("Open Resume"),
            ),

            const SizedBox(height: 20),

            // 🔥 CODING PROFILES
            const Text("Coding Profiles",
                style: TextStyle(fontWeight: FontWeight.bold)),

            ...profiles.map<Widget>((p) {
              return ListTile(
                title: Text(p['name']),
                subtitle: Text(p['link']),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  launchUrl(Uri.parse(p['link']));
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "$title: ${value ?? ""}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
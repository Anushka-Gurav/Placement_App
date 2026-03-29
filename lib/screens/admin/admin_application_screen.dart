import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail_screen.dart';

class AdminApplicationScreen extends StatelessWidget {
  const AdminApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applications")),
      backgroundColor: const Color(0xFFEFF3F5),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data!.docs;

          // 🔥 GROUP BY COMPANY
          Map<String, List<QueryDocumentSnapshot>> grouped = {};

          for (var app in apps) {
            final company = app['companyName'];
            grouped.putIfAbsent(company, () => []);
            grouped[company]!.add(app);
          }

          return ListView(
            children: grouped.keys.map((company) {

              final list = grouped[company]!;

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: ExpansionTile(
                    title: Text(
                      company,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    children: list.map((app) {
                      final data =
                      app.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: const Icon(Icons.person),

                        // ✅ FIXED NAME DISPLAY
                        title: Text(
                          data['userName'] != null &&
                              data['userName'] != ""
                              ? data['userName']
                              : data['userEmail'] ?? "Student",
                        ),

                        subtitle:
                        Text("Status: ${data['status']}"),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentDetailScreen(
                                      student: data),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
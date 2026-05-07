import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail_screen.dart';

class AdminApplicationScreen extends StatelessWidget {
  const AdminApplicationScreen({super.key});

  // 🔥 DELETE FUNCTION
  Future<void> deleteApplication(String id) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(id)
        .delete();
  }

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

                      final doc = app;
                      final data =
                      doc.data() as Map<String, dynamic>;

                      return Dismissible(
                        key: Key(doc.id),

                        direction: DismissDirection.endToStart,

                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        // 🔥 CONFIRM DELETE (VERY IMPORTANT)
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Application"),
                              content: const Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },

                        onDismissed: (_) async {
                          await deleteApplication(doc.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Application Deleted")),
                          );
                        },

                        child: ListTile(
                          leading: const Icon(Icons.person),

                          title: Text(
                            data['userName'] != null &&
                                data['userName'] != ""
                                ? data['userName']
                                : data['userEmail'] ?? "Student",
                          ),

                          subtitle: Text("Status: ${data['status']}"),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentDetailScreen(student: data),
                              ),
                            );
                          },
                        ),
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
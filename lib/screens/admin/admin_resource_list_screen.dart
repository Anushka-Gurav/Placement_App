import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_quiz_analytics_screen.dart';
import 'edit_quiz_screen.dart';
import 'edit_link_screen.dart';

class AdminResourceListScreen extends StatelessWidget {
  const AdminResourceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Resources")),
      backgroundColor: const Color(0xFFF6F7FB),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('resources')
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final resources = snapshot.data!.docs;

          if (resources.isEmpty) {
            return const Center(child: Text("No Resources Found"));
          }

          return ListView.builder(
            itemCount: resources.length,
            itemBuilder: (_, i) {

              final r = resources[i];
              final data = r.data() as Map<String, dynamic>;
              final type = data['type'];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                  // 🔥 ICON BASED ON TYPE
                  leading: CircleAvatar(
                    backgroundColor: type == "quiz"
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    child: Icon(
                      type == "quiz"
                          ? Icons.quiz
                          : Icons.link,
                      color: type == "quiz"
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),

                  title: Text(
                    data['title'] ?? "No Title",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(
                    type == "quiz" ? "Quiz Resource" : "External Link",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  // 🔥 FIXED POPUP MENU
                  trailing: PopupMenuButton<String>(
                    onSelected: (val) {

                      // 🔥 QUIZ ACTIONS
                      if (type == "quiz") {

                        if (val == "analytics") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AdminQuizAnalyticsScreen(resource: r),
                            ),
                          );
                        }

                        if (val == "edit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditQuizScreen(resource: r),
                            ),
                          );
                        }
                      }

                      // 🔥 LINK ACTIONS
                      if (type == "link") {

                        if (val == "edit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditLinkScreen(resource: r),
                            ),
                          );
                        }
                      }
                    },

                    itemBuilder: (_) {

                      // 🔥 QUIZ MENU
                      if (type == "quiz") {
                        return const [
                          PopupMenuItem(
                            value: "analytics",
                            child: Text("View Analytics"),
                          ),
                          PopupMenuItem(
                            value: "edit",
                            child: Text("Edit Quiz"),
                          ),
                        ];
                      }

                      // 🔥 LINK MENU (ONLY EDIT)
                      return const [
                        PopupMenuItem(
                          value: "edit",
                          child: Text("Edit Link"),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
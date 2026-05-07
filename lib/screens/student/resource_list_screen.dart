import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_attempt_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceListScreen extends StatelessWidget {
  const ResourceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Placement Resources")),

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

          return ListView.builder(
            itemCount: resources.length,
            itemBuilder: (_, i) {

              final r = resources[i];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(r['title']),
                  subtitle: Text(r['type']),

                  trailing: const Icon(Icons.arrow_forward),

                  onTap: () {

                    if (r['type'] == "quiz") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizAttemptScreen(resource: r),
                        ),
                      );
                    }

                    if (r['type'] == "link") {
                      launchUrl(Uri.parse(r['link']));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/experience_service.dart';

class AdminExperienceScreen extends StatelessWidget {
  const AdminExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final service = ExperienceService();

    return Scaffold(
      appBar: AppBar(title: const Text("Approve Experiences")),

      body: StreamBuilder<QuerySnapshot>(
        stream: service.getPendingPosts(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (_, i) {

              final p = posts[i];

              return ListTile(
                title: Text(p['company']),
                subtitle: Text(p['userName'] ?? ""),

                trailing: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    service.approvePost(p.id);
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
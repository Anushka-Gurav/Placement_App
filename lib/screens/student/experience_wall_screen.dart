import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/experience_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExperienceWallScreen extends StatelessWidget {
  const ExperienceWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ExperienceService();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Experience Wall")),

      body: StreamBuilder<QuerySnapshot>(
        stream: service.getApprovedPosts(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (_, i) {

              final p = posts[i];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(p['company'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),

                      Text("${p['role']} • ${p['type']}"),

                      Text("By ${p['userName']}"),

                      const SizedBox(height: 10),

                      Text(p['learnings']),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up),
                            onPressed: () {
                              service.likePost(p.id, user!.uid);
                            },
                          ),
                          Text("${(p['likes'] as List).length}")
                        ],
                      )
                    ],
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
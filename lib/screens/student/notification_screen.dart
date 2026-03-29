import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/notification_firestore_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "";

    final date = timestamp.toDate();

    return "${date.day}/${date.month}/${date.year} • "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final service = NotificationFirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      backgroundColor: const Color(0xFFEFF3F5),

      body: StreamBuilder<QuerySnapshot>(
        stream: service.getNotifications(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text("No Notifications"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final n = data[i];
              final ts = n['createdAt'];

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        n['message'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatTimestamp(ts),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
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
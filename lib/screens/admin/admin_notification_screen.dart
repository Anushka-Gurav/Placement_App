import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/notification_firestore_service.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState
    extends State<AdminNotificationScreen> {

  final controller = TextEditingController();
  final service = NotificationFirestoreService();

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "";

    final date = timestamp.toDate();

    return "${date.day}/${date.month}/${date.year} • "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void send() async {
    if (controller.text.trim().isEmpty) return;

    await service.addNotification(controller.text.trim());

    controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification Sent")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),
      appBar: AppBar(
        title: const Text("Manage Notifications"),
        backgroundColor: const Color(0xFF1F3C44),
      ),
      body: Column(
        children: [

          // 🔥 INPUT
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter notification...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F3C44),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: send,
                  child: const Text("Send"),
                )
              ],
            ),
          ),

          // 🔥 LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: service.getNotifications(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final data = snapshot.data!.docs;

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
                            BoxShadow(
                                color: Colors.black12, blurRadius: 6)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              n['message'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              formatTimestamp(ts),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
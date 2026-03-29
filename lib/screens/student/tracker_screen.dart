import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/application_firestore_service.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ApplicationFirestoreService();

    final statusList = [
      "Applied",
      "Shortlisted",
      "Interview",
      "Selected",
      "Rejected"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Application Tracker")),
      backgroundColor: const Color(0xFFEFF3F5),

      body: StreamBuilder<QuerySnapshot>(
        stream: service.getMyApplications(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data!.docs;

          if (apps.isEmpty) {
            return const Center(child: Text("No Applications Yet"));
          }

          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (_, i) {
              final app = apps[i];
              final data = app.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        data['companyName'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 5),

                      Text(data['role']),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [

                          const Text("Status"),

                          DropdownButton(
                            value: data['status'],
                            items: statusList
                                .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                                .toList(),
                            onChanged: (val) {
                              DropdownButton<String>(
                                value: data['status'],
                                items: statusList
                                    .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    service.updateStatus(app.id, val);
                                  }
                                },
                              );
                            },
                          ),
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/company_detail_screen.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Companies")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final companies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (_, i) {
              final c = companies[i];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(c['name']),
                  subtitle: Text("${c['role']} • ${c['package']}"),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailScreen(
                          company: c.data() as Map<String, dynamic>,
                        ),
                      ),
                    );
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
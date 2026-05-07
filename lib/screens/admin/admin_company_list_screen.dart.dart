import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_company_screen.dart';

class AdminCompanyListScreen extends StatelessWidget {
  const AdminCompanyListScreen({super.key});

  // 🔥 DELETE
  Future<void> deleteCompany(String id) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(id)
        .delete();
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Company"),
        content: const Text("Are you sure you want to delete this company?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Companies")),
      backgroundColor: const Color(0xFFEFF3F5),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final companies = snapshot.data!.docs;

          if (companies.isEmpty) {
            return const Center(child: Text("No Companies Found"));
          }

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (_, i) {

              final doc = companies[i];
              final c = doc.data() as Map<String, dynamic>;

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,

                // 🔥 RED DELETE BG
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                // 🔥 CONFIRM BEFORE DELETE
                confirmDismiss: (_) async {
                  return await _confirmDelete(context);
                },

                onDismissed: (_) async {
                  await deleteCompany(doc.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Company Deleted")),
                  );
                },

                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(c['name'] ?? ""),
                    subtitle: Text(c['role'] ?? ""),

                    // 🔥 EDIT
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditCompanyScreen(
                            docId: doc.id,
                            company: c,
                          ),
                        ),
                      );
                    },

                    // 🔥 DELETE BUTTON (BEST FOR WEB)
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await _confirmDelete(context);

                        if (confirm == true) {
                          await deleteCompany(doc.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Company Deleted")),
                          );
                        }
                      },
                    ),
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
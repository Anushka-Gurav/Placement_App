import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_company_screen.dart';

class AdminCompanyListScreen extends StatelessWidget {
  const AdminCompanyListScreen({super.key});

  // 🔥 DELETE COMPANY + APPLICATIONS
  Future<void> deleteCompany(
      String companyId,
      String companyName,
      ) async {

    final db = FirebaseFirestore.instance;

    // 🔥 DELETE RELATED APPLICATIONS
    final apps = await db
        .collection('applications')
        .where(
      "companyName",
      isEqualTo: companyName,
    )
        .get();

    for (var app in apps.docs) {
      await app.reference.delete();
    }

    // 🔥 DELETE COMPANY
    await db
        .collection('companies')
        .doc(companyId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Companies"),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('companies')
            .orderBy(
          "createdAt",
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final companies =
              snapshot.data!.docs;

          if (companies.isEmpty) {

            return const Center(
              child: Text(
                "No Companies Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.all(12),

            itemCount: companies.length,

            itemBuilder: (_, i) {

              final doc = companies[i];

              final c =
              doc.data()
              as Map<String, dynamic>;

              return Dismissible(

                key: Key(doc.id),

                direction:
                DismissDirection
                    .endToStart,

                background: Container(

                  margin:
                  const EdgeInsets.only(
                      bottom: 14),

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  alignment:
                  Alignment.centerRight,

                  decoration: BoxDecoration(
                    color: Colors.red,

                    borderRadius:
                    BorderRadius.circular(
                        18),
                  ),

                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                // 🔥 CONFIRM DELETE
                confirmDismiss:
                    (_) async {

                  return await showDialog(

                    context: context,

                    builder: (_) =>
                        AlertDialog(

                          title: const Text(
                            "Delete Company",
                          ),

                          content: Text(
                            "Delete ${c['name']} and all associated applications?",
                          ),

                          actions: [

                            TextButton(

                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  false,
                                );
                              },

                              child:
                              const Text(
                                "Cancel",
                              ),
                            ),

                            TextButton(

                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              },

                              child:
                              const Text(
                                "Delete",
                              ),
                            ),
                          ],
                        ),
                  );
                },

                // 🔥 DELETE
                onDismissed: (_) async {

                  await deleteCompany(
                    doc.id,
                    c['name'],
                  );

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    SnackBar(
                      content: Text(
                        "${c['name']} deleted",
                      ),
                    ),
                  );
                },

                child: Container(

                  margin:
                  const EdgeInsets.only(
                      bottom: 14),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        18),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      )
                    ],
                  ),

                  child: ListTile(

                    contentPadding:
                    const EdgeInsets.all(
                        16),

                    leading: Container(

                      padding:
                      const EdgeInsets
                          .all(12),

                      decoration:
                      BoxDecoration(

                        color: const Color(
                            0xFF141836)
                            .withOpacity(0.1),

                        borderRadius:
                        BorderRadius
                            .circular(
                            14),
                      ),

                      child: const Icon(
                        Icons.business,

                        color:
                        Color(0xFF141836),
                      ),
                    ),

                    title: Text(
                      c['name'],

                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    subtitle: Padding(

                      padding:
                      const EdgeInsets
                          .only(top: 6),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(
                            c['role'] ?? "",
                          ),

                          const SizedBox(
                              height: 4),

                          Text(
                            "Package: ${c['package']} LPA",
                          ),

                          const SizedBox(
                              height: 4),

                          Text(
                            "Location: ${c['location']}",
                          ),
                        ],
                      ),
                    ),

                    trailing: const Icon(
                      Icons.edit,
                    ),

                    // 🔥 EDIT COMPANY
                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              EditCompanyScreen(
                                docId: doc.id,
                                company: c,
                              ),
                        ),
                      );
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
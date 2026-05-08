import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  // 🔥 FORMAT DATE
  String formatDate(Timestamp? ts) {

    if (ts == null) return "";

    final d = ts.toDate();

    return "${d.day}/${d.month}/${d.year}";
  }

  // 🔥 STATUS COLOR
  Color getStatusColor(String status) {

    switch (status.toLowerCase()) {

      case "selected":
        return Colors.green;

      case "rejected":
        return Colors.red;

      case "shortlisted":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("My Applications"),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('applications')
            .where(
          "userId",
          isEqualTo: user!.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final apps =
              snapshot.data!.docs;

          if (apps.isEmpty) {

            return const Center(
              child: Text(
                "No Applications Yet",
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
            const EdgeInsets.all(14),

            itemCount: apps.length,

            itemBuilder: (_, i) {

              final data =
              apps[i].data()
              as Map<String, dynamic>;

              final status =
                  data['status'] ??
                      "Applied";

              return Container(

                margin:
                const EdgeInsets.only(
                    bottom: 15),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(
                      20),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    )
                  ],
                ),

                child: Padding(
                  padding:
                  const EdgeInsets.all(
                      18),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      // 🔥 TOP
                      Row(
                        children: [

                          Container(

                            padding:
                            const EdgeInsets
                                .all(12),

                            decoration:
                            BoxDecoration(

                              color: const Color(
                                  0xFF141836)
                                  .withOpacity(
                                  0.1),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  14),
                            ),

                            child: const Icon(
                              Icons.business,

                              color: Color(
                                  0xFF141836),
                            ),
                          ),

                          const SizedBox(
                              width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                Text(
                                  data['companyName'] ??
                                      "",

                                  style:
                                  const TextStyle(
                                    fontSize: 20,

                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  data['role'] ??
                                      "",

                                  style:
                                  TextStyle(
                                    color: Colors
                                        .grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 20),

                      // 🔥 DATE
                      Row(
                        children: [

                          const Icon(
                            Icons.calendar_month,

                            size: 18,
                            color: Colors.grey,
                          ),

                          const SizedBox(
                              width: 8),

                          Text(
                            "Applied On: ${formatDate(data['appliedAt'])}",
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 14),

                      // 🔥 STATUS
                      Container(

                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration:
                        BoxDecoration(

                          color: getStatusColor(
                              status)
                              .withOpacity(0.12),

                          borderRadius:
                          BorderRadius
                              .circular(
                              30),
                        ),

                        child: Text(

                          status,

                          style: TextStyle(
                            color:
                            getStatusColor(
                                status),

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/company_detail_screen.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

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
            .orderBy("createdAt",
            descending: true)
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
                "No Companies Available",
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

              return Container(

                margin:
                const EdgeInsets.only(
                    bottom: 15),

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

                child: InkWell(

                  borderRadius:
                  BorderRadius.circular(
                      18),

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            CompanyDetailScreen(

                              companyId: doc.id,
                            ),
                      ),
                    );
                  },

                  child: Padding(
                    padding:
                    const EdgeInsets.all(
                        18),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        // 🔥 TOP ROW
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
                                    c['name'] ??
                                        "",

                                    style:
                                    const TextStyle(
                                      fontSize:
                                      20,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 4),

                                  Text(
                                    c['role'] ??
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
                            height: 18),

                        // 🔥 DETAILS
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,

                          children: [

                            chip(
                              Icons.currency_rupee,
                              "${c['package']} LPA",
                            ),

                            chip(
                              Icons.location_on,
                              c['location'] ??
                                  "",
                            ),

                            chip(
                              Icons.school,
                              "CGPA ${c['cgpaCutOff']}",
                            ),

                            chip(
                              Icons.work,
                              c['type'] ?? "",
                            ),
                          ],
                        ),

                        const SizedBox(
                            height: 16),

                        // 🔥 PROCESS
                        if (c['process'] != null &&
                            c['process']
                                .isNotEmpty)

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              const Text(
                                "Hiring Process",

                                style: TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              ...List.generate(

                                c['process']
                                    .length,

                                    (index) {

                                  final p =
                                  c['process']
                                  [index];

                                  return Padding(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                        bottom:
                                        6),

                                    child: Row(
                                      children: [

                                        const Icon(
                                          Icons
                                              .check_circle,

                                          color: Colors
                                              .green,

                                          size: 18,
                                        ),

                                        const SizedBox(
                                            width:
                                            8),

                                        Expanded(
                                          child:
                                          Text(
                                            p['round'] ??
                                                "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                        const SizedBox(
                            height: 12),

                        // 🔥 VIEW DETAILS BUTTON
                        Align(
                          alignment:
                          Alignment
                              .centerRight,

                          child: TextButton(

                            onPressed: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      CompanyDetailScreen(
                                        companyId:
                                        doc.id,


                                      ),
                                ),
                              );
                            },

                            child: const Text(
                              "View Details",
                            ),
                          ),
                        )
                      ],
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

  // 🔥 CHIP
  Widget chip(
      IconData icon,
      String text,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color:
        const Color(0xFF141836)
            .withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color:
            const Color(0xFF141836),
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: const TextStyle(
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
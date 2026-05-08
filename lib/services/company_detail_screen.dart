import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'application_firestore_service.dart';

class CompanyDetailScreen extends StatelessWidget {

  final String companyId;

  final Map<String, dynamic> company;

  const CompanyDetailScreen({
    super.key,
    required this.companyId,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {

    final process =
        company['process'] ?? [];

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: Text(company['name']),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // 🔥 COMPANY CARD
            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF141836),
                    Color(0xFF1F2A5A),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(
                    20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    company['name'],

                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    company['role'],

                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: [

                      chip(
                        Icons.currency_rupee,
                        "${company['package']} LPA",
                      ),

                      chip(
                        Icons.location_on,
                        company['location'],
                      ),

                      chip(
                        Icons.school,
                        "CGPA ${company['cgpaCutOff']}",
                      ),

                      chip(
                        Icons.work,
                        company['type'],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 PROCESS SECTION
            const Text(
              "Hiring Process",

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...List.generate(
              process.length,
                  (i) {

                final p = process[i];

                return Container(

                  margin:
                  const EdgeInsets.only(
                      bottom: 12),

                  padding:
                  const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        16),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 40,
                        height: 40,

                        decoration:
                        BoxDecoration(
                          color: const Color(
                              0xFF141836)
                              .withOpacity(0.1),

                          shape:
                          BoxShape.circle,
                        ),

                        child: Center(
                          child: Text(
                            "${i + 1}",

                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,

                              color: Color(
                                  0xFF141836),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              p['round'] ?? "",

                              style:
                              const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              p['datetime'] ??
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
                );
              },
            ),

            const SizedBox(height: 30),

            // 🔥 APPLY BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF141836),

                  padding:
                  const EdgeInsets
                      .symmetric(
                    vertical: 16,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        14),
                  ),
                ),

                onPressed: () async {

                  // 🔥 CHECK IF COMPANY EXISTS
                  final doc =
                  await FirebaseFirestore
                      .instance
                      .collection(
                      'companies')
                      .doc(companyId)
                      .get();

                  if (!doc.exists) {

                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Company no longer exists",
                        ),
                      ),
                    );

                    Navigator.pop(context);

                    return;
                  }

                  // 🔥 APPLY
                  final ok =
                  await ApplicationFirestoreService()
                      .apply(
                    companyName:
                    company['name'],

                    role:
                    company['role'],
                  );

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    SnackBar(
                      content: Text(

                        ok

                            ? "Applied Successfully"

                            : "Already Applied",
                      ),
                    ),
                  );
                },

                child: const Text(
                  "Apply Now",

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
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
        color: Colors.white24,

        borderRadius:
        BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),

          const SizedBox(width: 6),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
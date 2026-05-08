import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'application_firestore_service.dart';

class CompanyDetailScreen extends StatelessWidget {
  final String companyId;

  const CompanyDetailScreen({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Company Details"),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('companies')
            .doc(companyId)
            .get(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Company not found"),
            );
          }

          final company =
          snapshot.data!.data()
          as Map<String, dynamic>;

          // 🔥 DEBUG
          print(company);

          // 🔥 SAFE CGPA FETCH
          final cgpaCutoff =
              company['cgpaCutOff'] ??
                  company['cgpaCutoff'] ??
                  0;

          final process =
              company['process'] ?? [];

          return SingleChildScrollView(

            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // 🔥 HEADER
                Container(

                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(22),

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
                        22),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(
                        company['name'] ?? "",

                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        company['role'] ?? "",

                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 22),

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
                            company['location'] ??
                                "",
                          ),

                          // ✅ FIXED CGPA
                          chip(
                            Icons.school,
                            "CGPA $cgpaCutoff",
                          ),

                          chip(
                            Icons.work,
                            company['type'] ??
                                "",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 🔥 ELIGIBILITY
                Container(

                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                        18),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      const Text(
                        "Eligibility Criteria",

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [

                          const Icon(
                            Icons.school,
                            color:
                            Color(0xFF141836),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "Minimum CGPA: $cgpaCutoff",

                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const Icon(
                            Icons.account_tree,
                            color:
                            Color(0xFF141836),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Eligible Branches: ${(company['branches'] ?? []).join(", ")}",

                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 🔥 PROCESS
                const Text(
                  "Hiring Process",

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...List.generate(
                  process.length,
                      (i) {

                    final p = process[i];

                    return Container(

                      margin:
                      const EdgeInsets.only(
                          bottom: 14),

                      padding:
                      const EdgeInsets.all(
                          16),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                            18),

                        boxShadow: const [
                          BoxShadow(
                            color:
                            Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          Container(

                            width: 42,
                            height: 42,

                            decoration:
                            BoxDecoration(

                              color: const Color(
                                  0xFF141836)
                                  .withOpacity(
                                  0.1),

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
                                    fontSize: 17,
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

                                  style: TextStyle(
                                    color:
                                    Colors.grey[
                                    700],
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
                FutureBuilder<DocumentSnapshot>(

                  future:
                  FirebaseFirestore
                      .instance
                      .collection(
                      'users')
                      .doc(FirebaseAuth
                      .instance
                      .currentUser!
                      .uid)
                      .get(),

                  builder:
                      (context, snapshot) {

                    if (!snapshot
                        .hasData) {

                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    final user =
                    snapshot.data!
                        .data()
                    as Map<String,
                        dynamic>;

                    // 🔥 STUDENT DATA
                    final studentCgpa =
                        double.tryParse(
                          user['cgpa']
                              .toString(),
                        ) ??
                            0;

                    final studentBranch =
                        user['branch'] ?? "";

                    // 🔥 COMPANY DATA
                    final cutoff =
                        double.tryParse(
                          cgpaCutoff
                              .toString(),
                        ) ??
                            0;

                    final branches =
                    List<String>.from(
                      company['branches'] ??
                          [],
                    );

                    // 🔥 ELIGIBILITY
                    final eligible =
                        studentCgpa >=
                            cutoff &&
                            branches.contains(
                                studentBranch);

                    return Column(
                      children: [

                        SizedBox(
                          width:
                          double.infinity,

                          child:
                          ElevatedButton(

                            style:
                            ElevatedButton
                                .styleFrom(

                              backgroundColor:

                              eligible

                                  ? const Color(
                                  0xFF141836)

                                  : Colors
                                  .grey,

                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 16,
                              ),

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    14),
                              ),
                            ),

                            onPressed:
                            eligible

                                ? () async {

                              final doc =
                              await FirebaseFirestore
                                  .instance
                                  .collection(
                                  'companies')
                                  .doc(
                                  companyId)
                                  .get();

                              if (!doc
                                  .exists) {

                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(

                                  const SnackBar(
                                    content:
                                    Text(
                                      "Company no longer exists",
                                    ),
                                  ),
                                );

                                Navigator.pop(
                                    context);

                                return;
                              }

                              final ok =
                              await ApplicationFirestoreService()
                                  .apply(
                                companyName:
                                company[
                                'name'],

                                role:
                                company[
                                'role'],
                              );

                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(

                                SnackBar(
                                  content:
                                  Text(

                                    ok

                                        ? "Applied Successfully"

                                        : "Already Applied",
                                  ),
                                ),
                              );
                            }

                                : null,

                            child: Text(

                              eligible

                                  ? "Apply Now"

                                  : "Not Eligible",

                              style:
                              const TextStyle(
                                fontSize: 18,
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (!eligible)

                          const Text(
                            "You do not meet eligibility criteria",

                            style: TextStyle(
                              color: Colors.red,
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔥 CHIP WIDGET
  Widget chip(
      IconData icon,
      String text,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
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
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import 'add_company_screen.dart';
import 'admin_company_list_screen.dart'; // ✅ FIXED
import 'admin_notification_screen.dart';
import 'admin_application_screen.dart';
import 'admin_students_year_screen.dart';

// 🔥 NEW IMPORT
import 'admin_experience_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),

      body: Column(
        children: [

          // 🔥 HEADER WITH LOGOUT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            decoration: const BoxDecoration(
              color: Color(0xFF1F3C44),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Manage everything easily",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),

                    // 🔥 LOGOUT
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔥 LIVE STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _liveStat("Companies", "companies"),
                    _liveStat("Applications", "applications"),
                    _liveStat("Notifications", "notifications"),
                    _liveStat("Experiences", "experience_posts"), // 🔥 NEW
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [

                  _card(Icons.add_business, "Add Company",
                      const Color(0xFF1F3C44), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AddCompanyScreen()));
                      }),

                  _card(Icons.business, "View Companies",
                      const Color(0xFF009688), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AdminCompanyListScreen()));
                      }),

                  _card(Icons.notifications, "Notifications",
                      const Color(0xFF4CAF50), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AdminNotificationScreen()));
                      }),

                  _card(Icons.people, "Applications",
                      const Color(0xFF6C63FF), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AdminApplicationScreen()));
                      }),

                  _card(Icons.school, "Students",
                      const Color(0xFF00A896), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminStudentsYearScreen(),
                          ),
                        );
                      }),

                  // 🔥 NEW FEATURE
                  _card(Icons.rate_review, "Moderate Experience",
                      const Color(0xFF1F3C44), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminExperienceScreen(),
                          ),
                        );
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 🔥 CARD UI
  Widget _card(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // 🔥 FIRESTORE LIVE COUNT
  Widget _liveStat(String label, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Column(
          children: [
            Text(count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white70)),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import 'company_list_screen.dart';
import 'tracker_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';

// 🔥 NEW IMPORTS
import 'experience_wall_screen.dart';
import 'add_experience_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),

      body: Column(
        children: [

          // 🔥 HEADER WITH LOGOUT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1F3C44),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome",
                        style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 5),
                    Text("Student Dashboard",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),

                // 🔥 LOGOUT BUTTON
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
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [

                  _card(context, "Companies", Icons.business,
                      const CompanyListScreen()),

                  _card(context, "Tracker", Icons.track_changes,
                      const TrackerScreen()),

                  _card(context, "Profile", Icons.person,
                      const ProfileScreen()),

                  _card(context, "Notifications",
                      Icons.notifications,
                      const NotificationScreen()),

                  // 🔥 NEW FEATURE
                  _card(context, "Experience Wall", Icons.forum,
                      const ExperienceWallScreen()),

                  _card(context, "Add Experience", Icons.add_circle,
                      const AddExperienceScreen()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _card(context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => screen)),
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
            Icon(icon, size: 35, color: const Color(0xFF1F3C44)),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';
import 'my_applications_screen.dart';
import 'company_list_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'resource_list_screen.dart';
import 'chatbot_screen.dart';

import 'experience_wall_screen.dart';
import 'add_experience_screen.dart';

import '../admin/placement_analytics_screen.dart';
import '../admin/placement_form_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [

          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 50),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF141836),
                  Color(0xFF2A2F5B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                // 🔥 USER INFO
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Welcome 👋",
                      style:
                      TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      user?.email ?? "Student",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // 🔥 LOGOUT
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),

                  onPressed: () async {
                    await FirebaseAuth.instance
                        .signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginScreen(),
                      ),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 DASHBOARD GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [

                  // 🔥 COMPANIES
                  _card(
                    context,
                    "Companies",
                    Icons.business,
                    const CompanyListScreen(),
                    Colors.blue,
                  ),

                  // 🔥 RESOURCES
                  _card(
                    context,
                    "Resources",
                    Icons.menu_book,
                    const ResourceListScreen(),
                    Colors.teal,
                  ),

                  // 🔥 PROFILE
                  _card(
                    context,
                    "Profile",
                    Icons.person,
                    const ProfileScreen(),
                    Colors.orange,
                  ),

                  // 🔥 NOTIFICATIONS
                  _card(
                    context,
                    "Notifications",
                    Icons.notifications,
                    const NotificationScreen(),
                    Colors.purple,
                  ),

                  // 🔥 ADD STATS
                  _card(
                    context,
                    "Add Stats",
                    Icons.edit_note,
                    const PlacementFormScreen(),
                    Colors.deepPurple,
                  ),

                  // 🔥 ANALYTICS
                  _card(
                    context,
                    "Analytics",
                    Icons.insert_chart,
                    const PlacementAnalyticsScreen(),
                    Colors.green,
                  ),

                  // 🔥 EXPERIENCE WALL
                  _card(
                    context,
                    "Experience Wall",
                    Icons.forum,
                    const ExperienceWallScreen(),
                    Colors.pink,
                  ),

                  // 🔥 ADD EXPERIENCE
                  _card(
                    context,
                    "Add Experience",
                    Icons.add_circle,
                    const AddExperienceScreen(),
                    Colors.redAccent,
                  ),

                  // 🔥 CHATBOT / ASSISTANT
                  _card(
                    context,
                    "Assistant",
                    Icons.chat,
                    const ChatbotScreen(),
                    Colors.indigo,
                  ),
                  _card(
                    context,
                    "My Applications",
                    Icons.assignment,
                    const MyApplicationsScreen(),
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CARD WIDGET
  Widget _card(
      BuildContext context,
      String title,
      IconData icon,
      Widget screen,
      Color color,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            // 🔥 ICON CIRCLE
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
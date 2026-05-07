import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';

import 'add_company_screen.dart';
import 'admin_company_list_screen.dart';
import 'admin_application_screen.dart';
import 'admin_notification_screen.dart';
import 'admin_students_year_screen.dart';

import 'add_resource_screen.dart';
import 'admin_resource_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 50,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF141836),
                  Color(0xFF1F2A5A),
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

                // 🔥 TITLE
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Welcome Admin 👋",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      user?.email ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),

                // 🔥 LOGOUT
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 28,
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

          // 🔥 GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,

                children: [

                  // 🔥 ADD COMPANY
                  _card(
                    context,
                    "Add Company",
                    Icons.add_business,
                    const AddCompanyScreen(),
                    Colors.blue,
                  ),

                  // 🔥 VIEW COMPANIES
                  _card(
                    context,
                    "Manage Companies",
                    Icons.business,
                    const AdminCompanyListScreen(),
                    Colors.indigo,
                  ),

                  // 🔥 APPLICATIONS
                  _card(
                    context,
                    "Applications",
                    Icons.assignment,
                    const AdminApplicationScreen(),
                    Colors.green,
                  ),

                  // 🔥 STUDENTS
                  _card(
                    context,
                    "Students",
                    Icons.people,
                    const AdminStudentsYearScreen(),
                    Colors.orange,
                  ),

                  // 🔥 NOTIFICATIONS
                  _card(
                    context,
                    "Notifications",
                    Icons.notifications,
                    const AdminNotificationScreen(),
                    Colors.redAccent,
                  ),

                  // 🔥 ADD RESOURCE
                  _card(
                    context,
                    "Add Resource",
                    Icons.library_add,
                    const AddResourceScreen(),
                    Colors.teal,
                  ),

                  // 🔥 MANAGE RESOURCES
                  _card(
                    context,
                    "Manage Resources",
                    Icons.menu_book,
                    const AdminResourceListScreen(),
                    Colors.purple,
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
      borderRadius: BorderRadius.circular(22),

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
          BorderRadius.circular(22),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            // 🔥 ICON BG
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 34,
                color: color,
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 TITLE
            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
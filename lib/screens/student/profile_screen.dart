import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  final branch = TextEditingController();
  final year = TextEditingController();
  final cgpa = TextEditingController();
  final resume = TextEditingController();

  List<Map<String, String>> profiles = [];

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final doc = await db.collection('users').doc(user!.uid).get();
    final data = doc.data();

    if (data != null) {
      branch.text = data['branch'] ?? "";
      year.text = data['year'] ?? "";
      cgpa.text = data['cgpa'] ?? "";
      resume.text = data['resume'] ?? "";

      if (data['profiles'] != null) {
        profiles = List<Map<String, String>>.from(
          (data['profiles'] as List).map(
                (e) => {
              "name": e['name'].toString(),
              "link": e['link'].toString(),
            },
          ),
        );
      }

      setState(() {});
    }
  }

  void saveProfile() async {
    await db.collection('users').doc(user!.uid).update({
      "branch": branch.text,
      "year": year.text,
      "cgpa": cgpa.text,
      "resume": resume.text,
      "profiles": profiles,
    });

    setState(() => isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated")),
    );
  }

  void addProfileDialog() {
    final nameCtrl = TextEditingController();
    final linkCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Platform")),
            TextField(controller: linkCtrl, decoration: const InputDecoration(labelText: "Link")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              profiles.add({
                "name": nameCtrl.text,
                "link": linkCtrl.text,
              });
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F5),

      body: Column(
        children: [

          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1F3C44),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person)),
                const SizedBox(height: 10),
                Text(user?.email ?? "",
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [

                  _field("Branch", branch),
                  _field("Year", year),
                  _field("CGPA", cgpa),
                  _field("Resume Link", resume),

                  const SizedBox(height: 20),

                  // 🔥 CODING PROFILES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Coding Profiles",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (isEditing)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: addProfileDialog,
                        )
                    ],
                  ),

                  ...profiles.map((p) => ListTile(
                    title: Text(p['name']!),
                    subtitle: Text(p['link']!),
                    trailing: isEditing
                        ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          profiles.remove(p);
                        });
                      },
                    )
                        : null,
                  )),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3C44),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (isEditing) {
                        saveProfile();
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                    child: Text(isEditing ? "Save Profile" : "Edit Profile"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final cgpa = TextEditingController();

  String role = "student";
  String selectedBranch = "Computer";
  String selectedYear = "Second Year";

  bool isLoading = false;

  final branches = ["Computer", "IT", "ENTC", "Mechanical", "Civil"];
  final years = ["First Year", "Second Year", "Third Year", "Fourth Year"];

  void register() async {
    setState(() => isLoading = true);

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = cred.user!.uid;

      await FirestoreService().saveUser(
        uid: uid,
        name: name.text,
        email: email.text,
        role: role,
        branch: selectedBranch,
        year: selectedYear,
        cgpa: cgpa.text,
      );

      // ✅ SUCCESS POPUP
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Registration Successful",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context);
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8E2DE2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text("Create Account",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),

                    TextField(controller: name,
                        decoration: _input("Name", Icons.person)),

                    const SizedBox(height: 10),

                    TextField(controller: email,
                        decoration: _input("Email", Icons.email)),

                    const SizedBox(height: 10),

                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: _input("Password", Icons.lock),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: selectedBranch,
                      items: branches
                          .map((b) => DropdownMenuItem(
                          value: b, child: Text(b)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedBranch = val!),
                      decoration: _input("Branch", Icons.school),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: selectedYear,
                      items: years
                          .map((y) => DropdownMenuItem(
                          value: y, child: Text(y)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedYear = val!),
                      decoration: _input("Year", Icons.calendar_today),
                    ),

                    const SizedBox(height: 10),

                    TextField(controller: cgpa,
                        decoration: _input("CGPA", Icons.grade)),

                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: role,
                      items: const [
                        DropdownMenuItem(
                            value: "student", child: Text("Student")),
                        DropdownMenuItem(
                            value: "admin", child: Text("Admin")),
                      ],
                      onChanged: (val) =>
                          setState(() => role = val!),
                      decoration: _input("Register As", Icons.person),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                        const Size(double.infinity, 50),
                      ),
                      onPressed: isLoading ? null : register,
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text("Register"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
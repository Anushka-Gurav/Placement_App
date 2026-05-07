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
  bool isPasswordVisible = false; // 🔥 NEW

  final branches = ["Computer", "IT", "ENTC", "Mechanical", "Civil"];
  final years = ["First Year", "Second Year", "Third Year", "Fourth Year"];

  // 🔥 ERROR DIALOG
  void showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 10),
            Text(msg),
          ],
        ),
      ),
    );
  }

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

      // ✅ SUCCESS DIALOG
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

      Navigator.pop(context); // close dialog
      Navigator.pop(context); // go back to login

    } on FirebaseAuthException catch (e) {
      String message = "Registration Failed";

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already registered";
          break;
        case 'weak-password':
          message = "Password should be at least 6 characters";
          break;
        case 'invalid-email':
          message = "Invalid email format";
          break;
      }

      showError(message);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        // 🔥 UPDATED THEME GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF141836),
              Color(0xFF1E234D),
            ],
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

                    // 🔥 PASSWORD WITH EYE ICON
                    TextField(
                      controller: password,
                      obscureText: !isPasswordVisible,
                      decoration: _input("Password", Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
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
                      onPressed: isLoading ? null : register,
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text("Register"),
                    ),

                    const SizedBox(height: 10),

                    // 🔥 LOGIN REDIRECT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already a user? "),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF141836),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
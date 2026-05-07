import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacementFormScreen extends StatefulWidget {
  const PlacementFormScreen({super.key});

  @override
  State<PlacementFormScreen> createState() => _PlacementFormScreenState();
}

class _PlacementFormScreenState extends State<PlacementFormScreen> {
  final name = TextEditingController();
  final roll = TextEditingController();

  String branch = "COMP";
  String year = "Third Year";
  String status = "Placed";

  final branches = ["COMP", "IT", "ENTC", "MECH", "INSTRU"];
  final years = ["First Year", "Second Year", "Third Year", "Fourth Year"];
  final statusList = ["Placed", "Internship", "Not Placed"];

  void submit() async {
    await FirebaseFirestore.instance.collection('placement_stats').add({
      "name": name.text,
      "branch": branch,
      "rollNo": roll.text,
      "year": year,
      "status": status,
      "createdAt": FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data Submitted")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Placement Form")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            // ── BRANCH DROPDOWN ──────────────────────────────────────────
            DropdownButtonFormField<String>(
              value: branch,
              decoration: const InputDecoration(labelText: "Branch"),
              items: branches
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => branch = v!),
            ),
            TextField(
              controller: roll,
              decoration: const InputDecoration(labelText: "Roll No"),
            ),
            DropdownButtonFormField<String>(
              value: year,
              decoration: const InputDecoration(labelText: "Year"),
              items: years
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => year = v!),
            ),
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: "Status"),
              items: statusList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => status = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
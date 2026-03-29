import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCompanyScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> company;

  const EditCompanyScreen({
    super.key,
    required this.docId,
    required this.company,
  });

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {

  late TextEditingController name;
  late TextEditingController role;
  late TextEditingController package;
  late TextEditingController location;
  late TextEditingController cgpa;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(text: widget.company['name']);
    role = TextEditingController(text: widget.company['role']);
    package = TextEditingController(text: widget.company['package']);
    location = TextEditingController(text: widget.company['location']);
    cgpa = TextEditingController(
        text: widget.company['cgpaCutoff'].toString());
  }

  Future<void> updateCompany() async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.docId)
        .update({
      "name": name.text,
      "role": role.text,
      "package": package.text,
      "location": location.text,
      "cgpaCutoff": double.tryParse(cgpa.text) ?? 0,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Updated Successfully")),
    );

    Navigator.pop(context);
  }

  Future<void> deleteCompany() async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.docId)
        .delete();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Company"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteCompany,
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Company Name"),
            ),

            TextField(
              controller: role,
              decoration: const InputDecoration(labelText: "Role"),
            ),

            TextField(
              controller: package,
              decoration: const InputDecoration(labelText: "Package"),
            ),

            TextField(
              controller: location,
              decoration: const InputDecoration(labelText: "Location"),
            ),

            TextField(
              controller: cgpa,
              decoration: const InputDecoration(labelText: "CGPA Cutoff"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F3C44),
                foregroundColor: Colors.white,
              ),
              onPressed: updateCompany,
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
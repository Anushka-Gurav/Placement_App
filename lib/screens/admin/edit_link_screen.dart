import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditLinkScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const EditLinkScreen({super.key, required this.resource});

  @override
  State<EditLinkScreen> createState() => _EditLinkScreenState();
}

class _EditLinkScreenState extends State<EditLinkScreen> {

  late TextEditingController title;
  late TextEditingController link;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.resource['title']);
    link = TextEditingController(text: widget.resource['link']);
  }

  void save() async {
    await FirebaseFirestore.instance
        .collection('resources')
        .doc(widget.resource.id)
        .update({
      "title": title.text,
      "link": link.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Link")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(controller: title),
            const SizedBox(height: 10),
            TextField(controller: link),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
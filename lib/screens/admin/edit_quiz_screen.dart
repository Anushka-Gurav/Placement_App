import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuizScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const EditQuizScreen({super.key, required this.resource});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {

  late List questions;

  @override
  void initState() {
    super.initState();
    questions = List.from(widget.resource['questions']);
  }

  void save() async {
    await FirebaseFirestore.instance
        .collection('resources')
        .doc(widget.resource.id)
        .update({
      "questions": questions,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Quiz")),

      body: ListView(
        children: questions.map((q) {

          return Card(
            child: Column(
              children: [

                TextField(
                  controller: TextEditingController(text: q['question']),
                  onChanged: (v) => q['question'] = v,
                ),

                ...["A","B","C","D"].map((opt) {
                  return TextField(
                    controller: TextEditingController(text: q[opt]),
                    onChanged: (v) => q[opt] = v,
                  );
                }),

                DropdownButton(
                  value: q['correct'],
                  items: ["A","B","C","D"]
                      .map((e) => DropdownMenuItem(
                      value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => q['correct'] = val),
                )
              ],
            ),
          );
        }).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: const Icon(Icons.save),
      ),
    );
  }
}
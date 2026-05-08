import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuizScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const EditQuizScreen({
    super.key,
    required this.resource,
  });

  @override
  State<EditQuizScreen> createState() =>
      _EditQuizScreenState();
}

class _EditQuizScreenState
    extends State<EditQuizScreen> {

  late List questions;

  final labels = ["A", "B", "C", "D"];

  @override
  void initState() {
    super.initState();

    questions = List.from(
      widget.resource['questions'],
    );
  }

  // 🔥 SAVE
  Future<void> save() async {

    await FirebaseFirestore.instance
        .collection('resources')
        .doc(widget.resource.id)
        .update({
      "questions": questions,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Quiz Updated"),
      ),
    );

    Navigator.pop(context);
  }

  Widget buildQuestion(
      Map<String, dynamic> q,
      int qIndex,
      ) {

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              "Question ${qIndex + 1}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 QUESTION
            TextFormField(
              initialValue: q['question'],

              decoration: InputDecoration(
                labelText: "Question",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              onChanged: (v) {
                q['question'] = v;
              },
            ),

            const SizedBox(height: 20),

            // 🔥 OPTIONS
            ...List.generate(4, (i) {

              return Padding(
                padding:
                const EdgeInsets.only(bottom: 12),

                child: TextFormField(

                  // ✅ LIST ACCESS
                  initialValue: q['options'][i],

                  decoration: InputDecoration(
                    labelText:
                    "Option ${labels[i]}",

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),

                  onChanged: (v) {

                    // ✅ UPDATE LIST
                    q['options'][i] = v;
                  },
                ),
              );
            }),

            const SizedBox(height: 10),

            // 🔥 CORRECT ANSWER
            DropdownButtonFormField<int>(
              value: q['correctIndex'],

              decoration: InputDecoration(
                labelText: "Correct Answer",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              items: List.generate(4, (i) {

                return DropdownMenuItem(
                  value: i,
                  child: Text(labels[i]),
                );
              }),

              onChanged: (val) {

                setState(() {
                  q['correctIndex'] = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Quiz"),
      ),

      body: ListView.builder(
        itemCount: questions.length,

        itemBuilder: (_, i) {

          return buildQuestion(
            questions[i],
            i,
          );
        },
      ),

      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        const Color(0xFF141836),

        onPressed: save,

        child: const Icon(Icons.save),
      ),
    );
  }
}
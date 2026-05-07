import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizBuilderScreen extends StatefulWidget {
  final String title;

  const QuizBuilderScreen({super.key, required this.title});

  @override
  State<QuizBuilderScreen> createState() => _QuizBuilderScreenState();
}

class _QuizBuilderScreenState extends State<QuizBuilderScreen> {
  List<Map<String, dynamic>> questions = [];

  void addQuestion() {
    setState(() {
      questions.add({
        "question": "",
        "A": "",
        "B": "",
        "C": "",
        "D": "",
        "correct": "A"
      });
    });
  }

  void saveQuiz() async {
    await FirebaseFirestore.instance.collection("resources").add({
      "title": widget.title,
      "type": "quiz",
      "questions": questions,
      "createdAt": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quiz Saved")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          ElevatedButton(
            onPressed: addQuestion,
            child: const Text("Add Question"),
          ),

          ...questions.asMap().entries.map((entry) {
            int i = entry.key;
            var q = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [

                    TextField(
                      decoration: const InputDecoration(labelText: "Question"),
                      onChanged: (v) => q["question"] = v,
                    ),

                    const SizedBox(height: 10),

                    ...["A", "B", "C", "D"].map((opt) {
                      return TextField(
                        decoration:
                        InputDecoration(labelText: "Option $opt"),
                        onChanged: (v) => q[opt] = v,
                      );
                    }),

                    const SizedBox(height: 10),

                    DropdownButtonFormField(
                      value: q["correct"],
                      items: ["A", "B", "C", "D"]
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("Correct: $e"),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => q["correct"] = val),
                    )
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: saveQuiz,
            child: const Text("Save Quiz"),
          )
        ],
      ),
    );
  }
}
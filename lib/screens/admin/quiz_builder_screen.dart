import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizBuilderScreen extends StatefulWidget {

  final String title;

  const QuizBuilderScreen({
    super.key,
    required this.title,
  });

  @override
  State<QuizBuilderScreen> createState() =>
      _QuizBuilderScreenState();
}

class _QuizBuilderScreenState
    extends State<QuizBuilderScreen> {

  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    addQuestion();
  }

  void addQuestion() {

    setState(() {
      questions.add(QuestionModel());
    });
  }

  void removeQuestion(int index) {

    setState(() {
      questions.removeAt(index);
    });
  }

  Future<void> saveQuiz() async {

    if (questions.isEmpty) return;

    List<Map<String, dynamic>> quizData = [];

    for (var q in questions) {

      if (q.question.text.trim().isEmpty) {
        showError("Question cannot be empty");
        return;
      }

      if (q.options.any(
            (e) => e.text.trim().isEmpty,
      )) {
        showError("All options are required");
        return;
      }

      quizData.add({
        "question": q.question.text.trim(),
        "options": q.options
            .map((e) => e.text.trim())
            .toList(),
        "correctIndex": q.correctIndex,
      });
    }

    await FirebaseFirestore.instance
        .collection("resources")
        .add({

      "title": widget.title,
      "type": "quiz",
      "questions": quizData,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Quiz Saved Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  void showError(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addQuestion,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: questions.length + 1,

        itemBuilder: (context, index) {

          if (index == questions.length) {

            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: saveQuiz,
                child: const Text("Save Quiz"),
              ),
            );
          }

          final q = questions[index];

          return Card(

            margin: const EdgeInsets.only(bottom: 20),

            elevation: 3,

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "Question ${index + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () =>
                            removeQuestion(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: q.question,
                    decoration: const InputDecoration(
                      labelText: "Enter Question",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...List.generate(4, (optIndex) {

                    return Padding(

                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      child: Row(

                        children: [

                          Radio<int>(
                            value: optIndex,
                            groupValue: q.correctIndex,
                            onChanged: (val) {

                              setState(() {
                                q.correctIndex = val!;
                              });
                            },
                          ),

                          Expanded(
                            child: TextField(
                              controller:
                              q.options[optIndex],

                              decoration: InputDecoration(
                                labelText:
                                "Option ${optIndex + 1}",
                                border:
                                const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuestionModel {

  TextEditingController question =
  TextEditingController();

  List<TextEditingController> options =
  List.generate(
    4,
        (_) => TextEditingController(),
  );

  int correctIndex = 0;
}
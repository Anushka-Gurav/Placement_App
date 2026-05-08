import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizAttemptScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const QuizAttemptScreen({
    super.key,
    required this.resource,
  });

  @override
  State<QuizAttemptScreen> createState() =>
      _QuizAttemptScreenState();
}

class _QuizAttemptScreenState
    extends State<QuizAttemptScreen> {

  late List questions;

  List<int?> answers = [];

  bool submitted = false;
  int score = 0;

  final labels = ["A", "B", "C", "D"];

  @override
  void initState() {
    super.initState();

    questions = widget.resource['questions'];

    answers =
    List<int?>.filled(questions.length, null);

    checkAlreadyAttempted();
  }

  // 🔥 CHECK ATTEMPT
  Future<void> checkAlreadyAttempted() async {

    final user =
        FirebaseAuth.instance.currentUser;

    final res = await FirebaseFirestore.instance
        .collection('quiz_attempts')
        .where("userId",
        isEqualTo: user!.uid)
        .where("quizId",
        isEqualTo: widget.resource.id)
        .get();

    if (res.docs.isNotEmpty) {

      final data = res.docs.first.data();

      setState(() {
        submitted = true;

        answers =
        List<int?>.from(data['answers']);

        score = data['score'];
      });
    }
  }

  // 🔥 SUBMIT QUIZ
  Future<void> submitQuiz() async {

    final user =
        FirebaseAuth.instance.currentUser;

    final userDoc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final userData = userDoc.data();

    int tempScore = 0;

    for (int i = 0;
    i < questions.length;
    i++) {

      if (answers[i] ==
          questions[i]['correctIndex']) {
        tempScore++;
      }
    }

    // 🔥 SAVE ATTEMPT
    await FirebaseFirestore.instance
        .collection('quiz_attempts')
        .add({

      "userId": user.uid,
      "userName": userData?['name'],
      "userEmail": userData?['email'],

      "quizId": widget.resource.id,

      "answers": answers,

      "score": tempScore,
      "total": questions.length,

      "submittedAt":
      FieldValue.serverTimestamp(),
    });

    setState(() {
      submitted = true;
      score = tempScore;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.resource['title']),
      ),

      body: submitted
          ? resultView()
          : quizView(),

      floatingActionButton: submitted
          ? null
          : FloatingActionButton(
        backgroundColor:
        const Color(0xFF141836),

        onPressed: submitQuiz,

        child: const Icon(Icons.check),
      ),
    );
  }

  // 🔥 QUIZ VIEW
  Widget quizView() {

    return ListView.builder(
      itemCount: questions.length,

      itemBuilder: (_, i) {

        final q = questions[i];

        return Card(
          margin: const EdgeInsets.all(10),

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  "Q${i + 1}. ${q['question']}",

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 OPTIONS
                ...List.generate(
                  q['options'].length,
                      (optIndex) {

                    return RadioListTile<int>(

                      value: optIndex,

                      groupValue:
                      answers[i],

                      title: Text(
                        "${labels[optIndex]}. ${q['options'][optIndex]}",
                      ),

                      onChanged: (val) {

                        setState(() {
                          answers[i] = val;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔥 RESULT VIEW
  Widget resultView() {

    return ListView(
      children: [

        const SizedBox(height: 20),

        // 🔥 SCORE
        Center(
          child: Container(
            padding:
            const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: const Color(0xFF141836),
              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Text(
              "Score: $score / ${questions.length}",

              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 🔥 QUESTIONS REVIEW
        ...List.generate(
          questions.length,
              (i) {

            final q = questions[i];

            final correctIndex =
            q['correctIndex'];

            final userAns = answers[i];

            return Card(
              margin:
              const EdgeInsets.all(10),

              child: Padding(
                padding:
                const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Q${i + 1}. ${q['question']}",

                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      q['options'].length,
                          (optIndex) {

                        Color? bg;

                        // ✅ CORRECT
                        if (optIndex ==
                            correctIndex) {

                          bg = Colors.green
                              .withOpacity(0.25);
                        }

                        // ❌ WRONG SELECTED
                        else if (optIndex ==
                            userAns) {

                          bg = Colors.red
                              .withOpacity(0.25);
                        }

                        return Container(
                          margin:
                          const EdgeInsets.symmetric(
                              vertical: 4),

                          padding:
                          const EdgeInsets.all(12),

                          decoration:
                          BoxDecoration(
                            color: bg,
                            borderRadius:
                            BorderRadius.circular(
                                12),
                          ),

                          child: Row(
                            children: [

                              Text(
                                "${labels[optIndex]}. ",

                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  q['options']
                                  [optIndex],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
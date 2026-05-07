import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizAttemptScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const QuizAttemptScreen({super.key, required this.resource});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {

  List answers = [];
  bool submitted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();

    final questions = widget.resource['questions'];
    answers = List.filled(questions.length, null);

    checkAlreadyAttempted();
  }

  Future<void> checkAlreadyAttempted() async {

    final user = FirebaseAuth.instance.currentUser;

    final res = await FirebaseFirestore.instance
        .collection('quiz_attempts')
        .where("userId", isEqualTo: user!.uid)
        .where("quizId", isEqualTo: widget.resource.id)
        .get();

    if (res.docs.isNotEmpty) {

      final data = res.docs.first.data();

      setState(() {
        submitted = true;
        answers = List.from(data['answers']);
        score = data['score'];
      });
    }
  }

  void submitQuiz() async {

    final user = FirebaseAuth.instance.currentUser;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final userData = userDoc.data();

    final questions = widget.resource['questions'];

    int tempScore = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i]['correct']) {
        tempScore++;
      }
    }

    await FirebaseFirestore.instance.collection('quiz_attempts').add({
      "userId": user.uid,
      "userName": userData?['name'],
      "userEmail": userData?['email'],
      "quizId": widget.resource.id,
      "answers": answers,
      "score": tempScore,
      "total": questions.length,
      "submittedAt": DateTime.now(),
    });

    setState(() {
      submitted = true;
      score = tempScore;
    });
  }

  @override
  Widget build(BuildContext context) {

    final questions = widget.resource['questions'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.resource['title'])),

      body: submitted
          ? _resultView(questions)
          : _quizView(questions),

      floatingActionButton: submitted
          ? null
          : FloatingActionButton(
        onPressed: submitQuiz,
        child: const Icon(Icons.check),
      ),
    );
  }

  // 🔥 QUIZ UI
  Widget _quizView(List questions) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (_, i) {

        final q = questions[i];

        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(q['question'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),

                ...["A","B","C","D"].map((opt) {

                  return RadioListTile(
                    value: opt,
                    groupValue: answers[i],
                    title: Text(q[opt]),
                    onChanged: (val) {
                      setState(() {
                        answers[i] = val;
                      });
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔥 RESULT UI
  Widget _resultView(List questions) {

    return ListView(
      children: [

        const SizedBox(height: 10),

        // SCORE
        Center(
          child: Text(
            "Score: $score / ${questions.length}",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 20),

        ...List.generate(questions.length, (i) {

          final q = questions[i];
          final correct = q['correct'];
          final userAns = answers[i];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(q['question'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  ...["A","B","C","D"].map((opt) {

                    Color? bg;

                    if (opt == correct) {
                      bg = Colors.green.withOpacity(0.3);
                    } else if (opt == userAns && opt != correct) {
                      bg = Colors.red.withOpacity(0.3);
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("$opt. ${q[opt]}"),
                    );
                  }),
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
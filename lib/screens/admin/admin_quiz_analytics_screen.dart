import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQuizAnalyticsScreen extends StatefulWidget {
  final QueryDocumentSnapshot resource;

  const AdminQuizAnalyticsScreen({super.key, required this.resource});

  @override
  State<AdminQuizAnalyticsScreen> createState() =>
      _AdminQuizAnalyticsScreenState();
}

class _AdminQuizAnalyticsScreenState
    extends State<AdminQuizAnalyticsScreen> {

  List<Map<String, dynamic>> attempted = [];
  List<Map<String, dynamic>> notAttempted = [];

  int totalStudents = 0;
  bool showAttempted = true;

  Map<String, dynamic>? topScorer;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final usersSnap = await FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "student")
        .get();

    final attemptsSnap = await FirebaseFirestore.instance
        .collection('quiz_attempts')
        .where("quizId", isEqualTo: widget.resource.id)
        .get();

    totalStudents = usersSnap.docs.length;

    final attemptMap = {
      for (var a in attemptsSnap.docs)
        (a.data() as Map<String, dynamic>)['userId']:
        a.data() as Map<String, dynamic>
    };

    List<Map<String, dynamic>> tempAttempted = [];
    List<Map<String, dynamic>> tempNotAttempted = [];

    for (var u in usersSnap.docs) {

      final userData = u.data();
      final data = attemptMap[u.id];

      if (data != null) {

        tempAttempted.add({
          "name": data['userName'] ?? userData['name'] ?? "Student",
          "email": data['userEmail'] ?? userData['email'] ?? "No Email",
          "score": data['score'] ?? 0,
          "total": data['total'] ?? 0,
        });

      } else {

        tempNotAttempted.add({
          "name": userData['name'] ?? "Student",
          "email": userData['email'] ?? "No Email",
        });
      }
    }

    // 🔥 SORT BY SCORE DESC
    tempAttempted.sort((a, b) =>
        (b['score'] as int).compareTo(a['score'] as int));

    // 🔥 TOP SCORER
    Map<String, dynamic>? top;
    if (tempAttempted.isNotEmpty) {
      top = tempAttempted.first;
    }

    setState(() {
      attempted = tempAttempted;
      notAttempted = tempNotAttempted;
      topScorer = top;
    });
  }

  @override
  Widget build(BuildContext context) {

    final currentList = showAttempted ? attempted : notAttempted;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource['title']),
        centerTitle: true,
      ),

      backgroundColor: const Color(0xFFF6F7FB),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 STATS
              Row(
                children: [
                  _statCard("Total", totalStudents),
                  _statCard("Attempted", attempted.length),
                  _statCard("Not Attempted", notAttempted.length),
                ],
              ),

              const SizedBox(height: 20),

              // 🏆 TOP SCORER
              if (topScorer != null)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.orange),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topScorer!['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(topScorer!['email']),
                          ],
                        ),
                      ),

                      Text(
                        "${topScorer!['score']} / ${topScorer!['total']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // 🔥 TOGGLE
              Row(
                children: [
                  Expanded(child: _toggleBtn("Attempted", true)),
                  const SizedBox(width: 10),
                  Expanded(child: _toggleBtn("Not Attempted", false)),
                ],
              ),

              const SizedBox(height: 20),

              // 🔥 LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentList.length,
                itemBuilder: (_, i) {

                  final s = currentList[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Row(
                      children: [

                        const CircleAvatar(
                          backgroundColor: Color(0xFF141836),
                          child: Icon(Icons.person, color: Colors.white),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(s['email'],
                                  style: const TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                        ),

                        if (showAttempted)
                          Text(
                            "${s['score']} / ${s['total']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 STAT CARD
  Widget _statCard(String title, int value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5)
          ],
        ),
        child: Column(
          children: [
            Text("$value",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF141836))),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // 🔥 TOGGLE BUTTON
  Widget _toggleBtn(String text, bool value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        showAttempted == value ? const Color(0xFF141836) : Colors.grey,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        setState(() => showAttempted = value);
      },
      child: Text(text),
    );
  }
}
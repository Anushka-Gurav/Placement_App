import 'package:flutter/material.dart';
import 'company_list_screen.dart';
import 'tracker_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'resource_list_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {

  final controller = TextEditingController();
  List<Map<String, String>> messages = [];

  // 🔥 KEYWORDS RELATED TO TNP
  final tnpKeywords = [
    "hi",
    "hello",
    "company",
    "placement",
    "apply",
    "application",
    "tracker",
    "profile",
    "notification",
    "quiz",
    "resource",
    "job",
  ];

  bool isTnpQuery(String text) {
    return tnpKeywords.any((word) => text.contains(word));
  }

  void sendMessage() {
    final text = controller.text.trim().toLowerCase();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"type": "user", "msg": text});
    });

    controller.clear();

    // 🔥 CHECK IF TNP RELATED
    if (!isTnpQuery(text)) {
      setState(() {
        messages.add({
          "type": "bot",
          "msg": "I can only help with TNP-related queries like companies, applications, quizzes, etc."
        });
      });
      return;
    }

    // 🔥 PROCESS INTENT
    final response = getBotResponse(text);

    setState(() {
      messages.add({"type": "bot", "msg": response['msg']});
    });

    // 🔥 NAVIGATE
    if (response['route'] != null) {
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.push(context, response['route']);
      });
    }
  }

  // 🔥 INTENT DETECTION
  Map<String, dynamic> getBotResponse(String text) {

    if(text.contains("Hi")|| text.contains("Hello"))
      {
        return {
          "msg": "Hello, Welcome to Placement Cell",
        };
      }
    if (text.contains("company") || text.contains("job")) {
      return {
        "msg": "Here are the available companies.",
        "route": MaterialPageRoute(
            builder: (_) => const CompanyListScreen())
      };
    }

    if (text.contains("track") || text.contains("application")) {
      return {
        "msg": "Opening your application tracker.",
        "route": MaterialPageRoute(
            builder: (_) => const TrackerScreen())
      };
    }

    if (text.contains("profile")) {
      return {
        "msg": "Here is your profile.",
        "route": MaterialPageRoute(
            builder: (_) => const ProfileScreen())
      };
    }

    if (text.contains("notification")) {
      return {
        "msg": "Showing notifications.",
        "route": MaterialPageRoute(
            builder: (_) => const NotificationScreen())
      };
    }

    if (text.contains("quiz") || text.contains("resource")) {
      return {
        "msg": "Opening preparation resources.",
        "route": MaterialPageRoute(
            builder: (_) => const ResourceListScreen())
      };
    }

    // 🔥 DEFAULT TNP RESPONSE
    return {
      "msg": "I can help you with companies, applications, quizzes, and notifications."
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TNP Assistant")),

      body: Column(
        children: [

          // 🔥 CHAT UI
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) {

                final m = messages[i];

                return Align(
                  alignment: m['type'] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m['type'] == "user"
                          ? const Color(0xFF141836)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m['msg']!,
                      style: TextStyle(
                        color: m['type'] == "user"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔥 INPUT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask TNP related query...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
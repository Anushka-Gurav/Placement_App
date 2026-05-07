import 'package:flutter/material.dart';
import '../../services/resource_firestore_service.dart';
import 'quiz_builder_screen.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {

  final title = TextEditingController();
  String type = "quiz";
  final link = TextEditingController();

  final service = ResourceService();

  void submit() async {

    if (type == "quiz") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizBuilderScreen(title: title.text),
        ),
      );
      return;
    }

    await service.addResource({
      "title": title.text,
      "type": type,
      "link": link.text,
      "createdAt": DateTime.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Resource")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: type,
              items: const [
                DropdownMenuItem(value: "quiz", child: Text("Quiz")),
                DropdownMenuItem(value: "pdf", child: Text("PDF")),
                DropdownMenuItem(value: "link", child: Text("Link")),
              ],
              onChanged: (val) => setState(() => type = val!),
            ),

            if (type == "link")
              TextField(
                controller: link,
                decoration: const InputDecoration(labelText: "URL"),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submit,
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
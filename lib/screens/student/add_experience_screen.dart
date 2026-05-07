import 'package:flutter/material.dart';
import '../../services/experience_service.dart';

class AddExperienceScreen extends StatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  State<AddExperienceScreen> createState() =>
      _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {

  final company = TextEditingController();
  final role = TextEditingController();
  final duration = TextEditingController();
  final stipend = TextEditingController();
  final learnings = TextEditingController();

  String type = "internship";
  String workMode = "Online";

  void submit() async {
    await ExperienceService().addExperience(
      type: type,
      company: company.text,
      role: role.text,
      duration: duration.text,
      stipend: stipend.text,
      workMode: workMode,
      learnings: learnings.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Submitted for approval")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Experience")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            DropdownButtonFormField(
              value: type,
              items: const [
                DropdownMenuItem(value: "internship", child: Text("Internship")),
                DropdownMenuItem(value: "placement", child: Text("Placement")),
                DropdownMenuItem(value: "ppo", child: Text("PPO")),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),

            TextField(controller: company, decoration: const InputDecoration(labelText: "Company")),
            TextField(controller: role, decoration: const InputDecoration(labelText: "Role")),
            TextField(controller: duration, decoration: const InputDecoration(labelText: "Duration")),
            TextField(controller: stipend, decoration: const InputDecoration(labelText: "Stipend")),

            DropdownButtonFormField(
              value: workMode,
              items: const [
                DropdownMenuItem(value: "Online", child: Text("Online")),
                DropdownMenuItem(value: "Offline", child: Text("Offline")),
              ],
              onChanged: (v) => setState(() => workMode = v!),
            ),

            TextField(
              controller: learnings,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Key Learnings"),
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
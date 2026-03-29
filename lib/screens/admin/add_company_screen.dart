import 'package:flutter/material.dart';
import '../../services/company_firestore_service.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {

  final name = TextEditingController();
  final role = TextEditingController();
  final package = TextEditingController();
  final location = TextEditingController();
  final cgpa = TextEditingController();

  String type = "Placement";
  List<String> selectedBranches = [];
  List<Map<String, dynamic>> rounds = [];

  final branches = ["Computer", "IT", "ENTC", "Mechanical", "Civil"];

  void addRound() {
    rounds.add({
      "round": "",
      "datetime": DateTime.now(),
    });
    setState(() {});
  }

  Future<void> pickDateTime(int index) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: rounds[index]['datetime'],
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(rounds[index]['datetime']),
    );

    if (time == null) return;

    setState(() {
      rounds[index]['datetime'] = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void addCompany() async {
    await CompanyFirestoreService().addCompany({
      "name": name.text,
      "role": role.text,
      "package": package.text,
      "location": location.text,
      "type": type,
      "cgpaCutoff": double.tryParse(cgpa.text) ?? 0,
      "branches": selectedBranches,
      "process": rounds.map((r) => {
        "round": r['round'],
        "datetime": r['datetime'].toString(),
      }).toList(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Company")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _input(name, "Company Name"),
            _input(role, "Role"),
            _input(package, "Package"),
            _input(location, "Location"),
            _input(cgpa, "CGPA"),

            const SizedBox(height: 10),

            const Text("Branches"),
            Wrap(
              children: branches.map((b) {
                return CheckboxListTile(
                  title: Text(b),
                  value: selectedBranches.contains(b),
                  onChanged: (val) {
                    setState(() {
                      val!
                          ? selectedBranches.add(b)
                          : selectedBranches.remove(b);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Text("Hiring Process"),

            Column(
              children: List.generate(rounds.length, (i) {
                final r = rounds[i];

                return Card(
                  child: Column(
                    children: [

                      TextField(
                        decoration: const InputDecoration(labelText: "Round"),
                        onChanged: (val) => r['round'] = val,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Text(r['datetime'].toString()),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => pickDateTime(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() => rounds.removeAt(i));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
            ),

            TextButton(onPressed: addRound, child: const Text("+ Add Round")),

            ElevatedButton(onPressed: addCompany, child: const Text("Save"))
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return TextField(controller: c, decoration: InputDecoration(labelText: label));
  }
}
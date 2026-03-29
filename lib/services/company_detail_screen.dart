import 'package:flutter/material.dart';
import '../../services/application_firestore_service.dart';

class CompanyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  State<CompanyDetailScreen> createState() =>
      _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {

  bool isApplied = false;

  @override
  void initState() {
    super.initState();
    checkApplied();
  }

  Future<void> checkApplied() async {
    final applied = await ApplicationFirestoreService()
        .hasAlreadyApplied(widget.company['name']);

    setState(() {
      isApplied = applied;
    });
  }

  @override
  Widget build(BuildContext context) {

    final company = widget.company;

    return Scaffold(
      appBar: AppBar(title: Text(company['name'])),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(company['role'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Text("${company['package']} • ${company['location']}"),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isApplied ? Colors.grey : const Color(0xFF1F3C44),
                foregroundColor: Colors.white,
              ),
              onPressed: isApplied
                  ? null
                  : () async {
                final success =
                await ApplicationFirestoreService().apply(
                  companyName: company['name'],
                  role: company['role'],
                );

                if (success) {
                  setState(() => isApplied = true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Applied")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Already Applied")),
                  );
                }
              },
              child: Text(isApplied ? "Applied" : "Apply"),
            )
          ],
        ),
      ),
    );
  }
}
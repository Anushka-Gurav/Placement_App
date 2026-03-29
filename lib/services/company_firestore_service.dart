import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyFirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addCompany(Map<String, dynamic> data) async {
    await _db.collection('companies').add({
      ...data,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
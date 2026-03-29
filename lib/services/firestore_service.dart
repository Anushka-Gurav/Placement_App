import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String role,
    required String branch,
    required String year,
    required String cgpa,
  }) async {
    await _db.collection('users').doc(uid).set({
      "name": name,
      "email": email,
      "role": role,
      "branch": branch,
      "year": year,
      "cgpa": cgpa,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }
}
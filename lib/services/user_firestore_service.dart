import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Stream<DocumentSnapshot> getUser() {
    return _db.collection('users').doc(uid).snapshots();
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
}
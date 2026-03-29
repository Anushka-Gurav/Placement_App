import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationFirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ✅ CHECK DUPLICATE
  Future<bool> hasAlreadyApplied(String companyName) async {
    final user = _auth.currentUser;

    final res = await _db
        .collection('applications')
        .where("userId", isEqualTo: user!.uid)
        .where("companyName", isEqualTo: companyName)
        .get();

    return res.docs.isNotEmpty;
  }

  // ✅ APPLY WITH FULL USER DATA
  Future<bool> apply({
    required String companyName,
    required String role,
  }) async {
    final user = _auth.currentUser;

    final already = await hasAlreadyApplied(companyName);
    if (already) return false;

    // 🔥 FETCH USER DATA FROM FIRESTORE
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final data = userDoc.data();

    await _db.collection('applications').add({
      "userId": user.uid,

      // ✅ IMPORTANT FIELDS
      "userName": data?['name'] ?? "Student",
      "userEmail": data?['email'] ?? "",
      "branch": data?['branch'] ?? "",
      "year": data?['year'] ?? "",
      "cgpa": data?['cgpa'] ?? "",

      "companyName": companyName,
      "role": role,
      "status": "Applied",
      "appliedAt": FieldValue.serverTimestamp(),
    });

    return true;
  }

  // ✅ STUDENT TRACKER
  Stream<QuerySnapshot> getMyApplications() {
    final user = _auth.currentUser;

    return _db
        .collection('applications')
        .where("userId", isEqualTo: user!.uid)
        .snapshots();
  }

  Future<void> updateStatus(String docId, String status) async {
    await _db.collection('applications').doc(docId).update({
      "status": status,
    });
  }
}
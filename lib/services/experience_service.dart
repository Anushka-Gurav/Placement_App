import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExperienceService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // 🔥 ADD EXPERIENCE
  Future<void> addExperience({
    required String type,
    required String company,
    required String role,
    required String duration,
    required String stipend,
    required String workMode,
    required String learnings,
  }) async {
    final user = _auth.currentUser;

    final userDoc = await _db.collection('users').doc(user!.uid).get();
    final userData = userDoc.data();

    await _db.collection('experience_posts').add({
      "type": type,
      "company": company,
      "role": role,
      "duration": duration,
      "stipend": stipend,
      "workMode": workMode,
      "learnings": learnings,
      "userName": userData?['name'] ?? "Student",
      "userId": user.uid,
      "approved": false, // 🔥 ADMIN CONTROL
      "likes": [],
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 🔥 FIXED (REMOVED orderBy → NO INDEX NEEDED)
  Stream<QuerySnapshot> getApprovedPosts() {
    return _db
        .collection('experience_posts')
        .where("approved", isEqualTo: true)
        .snapshots();
  }

  // 🔥 ADMIN VIEW
  Stream<QuerySnapshot> getPendingPosts() {
    return _db
        .collection('experience_posts')
        .where("approved", isEqualTo: false)
        .snapshots();
  }

  // 🔥 APPROVE POST
  Future<void> approvePost(String id) async {
    await _db.collection('experience_posts').doc(id).update({
      "approved": true,
    });
  }

  // 🔥 LIKE POST
  Future<void> likePost(String id, String uid) async {
    await _db.collection('experience_posts').doc(id).update({
      "likes": FieldValue.arrayUnion([uid])
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addNotification(String message) async {
    await _db.collection('notifications').add({
      "message": message,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getNotifications() {
    return _db
        .collection('notifications')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
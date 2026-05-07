import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceService {
  final _db = FirebaseFirestore.instance;

  Future<void> addResource(Map<String, dynamic> data) async {
    await _db.collection("resources").add(data);
  }

  Stream<QuerySnapshot> getResources() {
    return _db
        .collection("resources")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
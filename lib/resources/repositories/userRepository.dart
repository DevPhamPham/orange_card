import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<CollectionReference<Map<String, dynamic>>> getTopicUser(
      String userId) async {
    return await _usersCollection.doc(userId).collection("topics");
  }
}

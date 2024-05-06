import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CollectionReference<Map<String, dynamic>>> getTopicUser(
      String userId) async {
    return _usersCollection.doc(userId).collection("topics");
  }

  bool checkCurrentUser(DocumentReference<Object?>? user) {
    User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      DocumentReference currentUserRef =
          _firestore.collection('users').doc(firebaseUser.uid);
      if (user == currentUserRef) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:orange_card/resources/models/user.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CollectionReference<Map<String, dynamic>>> getTopicUser(
      String userId) async {
    return _usersCollection.doc(userId).collection("topics");
  }

  Future<void> create(
      String username, String avatar, List<String> topicIds) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      String uid = firebaseUser.uid;
      await _usersCollection.doc(uid).set({
        'displayName': username,
        'avatarUrl': avatar,
        'topicIds': topicIds,
      });
    } else {
      throw Exception('User is not authenticated');
    }
  }

  Future<void> updateAvatar(String userId, String newAvatar) async {
    await _usersCollection.doc(userId).update({
      'avatarUrl': newAvatar,
    });
  }

  Future<UserCurrent?> userFromDocumentReference(
      DocumentReference<Map<String, dynamic>>? userRef) async {
    try {
      if (userRef == null) {
        throw Exception('User reference is null');
      }

      DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
      print(snapshot.data());

      if (snapshot.exists) {
        return _fromSnapshot(snapshot);
      } else {
        print('User document does not exist');
        return null; // Return null when user document doesn't exist
      }
    } catch (e) {
      print("Error creating UserCurrent from DocumentReference: $e");
      return null; // Return null in case of any errors
    }
  }

  Future<String?> getAvatar(DocumentReference<Object?>? userRef) async {
    try {
      if (userRef == null) {
        return null;
      }

      final snapshot = await userRef.get();
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (snapshot.exists) {
        return data?['avatarUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user avatar: $e");
      return null; // Error occurred
    }
  }

  bool checkCurrentUser(DocumentReference<Object?>? user) {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentReference currentUserRef =
          _firestore.collection('users').doc(firebaseUser.uid);
      return user == currentUserRef;
    } else {
      return false;
    }
  }

  Future<UserCurrent?> getUserByDocumentReference(
      DocumentReference? userRef) async {
    if (userRef == null) {
      return null; // Return null if the user reference is null
    }

    try {
      DocumentSnapshot<Object?> snapshot = await userRef.get();
      if (snapshot.exists) {
        return UserCurrent.fromMap(snapshot.data()! as Map<String, dynamic>);
      } else {
        print('User document does not exist');
        return null; // Return null when user document doesn't exist
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null; // Return null in case of any errors
    }
  }

  UserCurrent _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCurrent(
        username: data['displayName'],
        avatar: data['avatarUrl'],
        topicIds: List<String>.from(data['topicIds']));
  }

  Future<String> getImageAddress(String imagePath) async {
    try {
      Reference imageRef = FirebaseStorage.instance.ref().child(imagePath);
      String address =
          await imageRef.getMetadata().then((value) => value.fullPath);
      return address;
    } catch (e) {
      print('Error getting image address: $e');
      return ''; // Return an empty string or null to signify failure
    }
  }
}

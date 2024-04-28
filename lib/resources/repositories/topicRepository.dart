import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orange_card/resources/models/topicInUser.dart';
import 'package:orange_card/resources/models/word.dart';
import '../models/topic.dart';

class TopicRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _topicsCollection =
      FirebaseFirestore.instance.collection('topics');
  Future<void> addTopic(Topic topic, List<Word> words) async {
    topic.users = [
      _usersCollection.doc(FirebaseAuth.instance.currentUser!.uid)
    ];
    DocumentReference documentReference =
        await _topicsCollection.add(topic.toMap());
    TopicInUser topicInUser = TopicInUser(id: documentReference.id, lastUse: 0);
    _usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("topics")
        .add(topicInUser.toMap());

    CollectionReference wordCollection = FirebaseFirestore.instance
        .collection("topics/${documentReference.id}/words");
    for (Word word in words) {
      await wordCollection.add(word.toMap());
    }
  }

  Future<void> deleteTopic(String topicId) async {
    await _topicsCollection.doc(topicId).delete();
  }

  Future<void> updateTopic(Topic topic) async {
    await _topicsCollection.doc(topic.id).update(topic.toMap());
  }

  Stream<List<Topic>> getAllTopics() {
    return _topicsCollection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => _fromSnapshot(doc)).toList());
  }

  Topic _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Topic(
      id: data['id'],
      title: data['title'],
      creationTime: data['creationTime'],
      numberOfChildren: data['numberOfChildren'],
      learnedWords: data['learnedWords'],
      updateTime: data['updateTime'],
      views: data['views'],
    );
  }
}

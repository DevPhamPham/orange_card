import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orange_card/config/app_logger.dart';
import 'package:orange_card/resources/models/userInTopic.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/utils/enum.dart';
import '../models/topic.dart';

class TopicRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _topicsCollection =
      FirebaseFirestore.instance.collection('topics');

  Future<void> addTopic(Topic topic, List<Word> words) async {
    topic.user = _usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentReference documentReference =
        await _topicsCollection.add(topic.toMap());
    CollectionReference wordCollection = FirebaseFirestore.instance
        .collection("topics/${documentReference.id}/words");
    for (Word word in words) {
      await wordCollection.add(word.toMap());
    }
  }

  Future<void> deleteTopic(String id) async {
    try {
      final userCollection = _usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('topics');

      final querySnapshot =
          await userCollection.where('id', isEqualTo: id).get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      await _topicsCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting topic: $e');
    }
  }

  Future<void> updateTopic(Topic topic, List<Word> words) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(_topicsCollection.doc(topic.id), topic.toMap());
    QuerySnapshot wordSnapshot = await FirebaseFirestore.instance
        .collection("topics/${topic.id}/words")
        .get();
    for (DocumentSnapshot doc in wordSnapshot.docs) {
      batch.delete(doc.reference);
    }
    for (Word word in words) {
      batch.set(
          FirebaseFirestore.instance
              .collection("topics/${topic.id}/words")
              .doc(),
          word.toMap());
    }
    await batch.commit();
  }

  Future<List<Topic>> getAllTopicsByUserId(String userId,
      {int limit = 10, DocumentSnapshot? startAfter}) async {
    final userRef = FirebaseFirestore.instance.doc("/users/$userId");
    final snapshot =
        await _topicsCollection.where("user", isEqualTo: userRef).get();
    final List<Topic> topics = [];
    for (final topicDoc in snapshot.docs) {
      final topicId = topicDoc.id;
      final topicSnapshot = await _topicsCollection.doc(topicId).get();
      if (topicSnapshot.exists) {
        final topic = _fromSnapshot(topicSnapshot);
        topic.id = topicId;
        topics.add(topic);
      }
    }
    return topics;
  }

  Future<Topic> getTopicByID(String id) async {
    final snapshot = await _topicsCollection.doc(id).get();
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    logger.i("data from topicRepository: ${data}");
    if (data != null) {
      final topic = Topic.fromMap(data, id);
      return topic;
    } else {
      throw Exception("No data available for topic with ID $id");
    }
  }

  Future<List<UserInTopic>> getRank(String topicId) async {
    final snapshot =
        await _topicsCollection.doc(topicId).collection('ranks').get();
    final List<UserInTopic> listRank = [];
    for (final rank in snapshot.docs) {
      final user = UserInTopic.fromMap(rank.data(), rank.id);
      listRank.add(user);
    }
    return listRank;
  }

  Future<void> addRank(UserInTopic user, String topicId) async {
    await _topicsCollection.doc(topicId).collection('ranks').add(user.toMap());
  }

  Future<List<Topic>> getTopicsPublic() async {
    final snapshot = await _topicsCollection.get();
    final List<Topic> topics = [];

    for (final topicDoc in snapshot.docs) {
      final topicId = topicDoc.id;
      final topicSnapshot = await _topicsCollection.doc(topicId).get();

      if (topicSnapshot.exists) {
        final topic = _fromSnapshot(topicSnapshot);
        topic.id = topicId;
        if (topic.status == STATUS.PUBLIC) {
          topics.add(topic);
        }
      }
    }

    return topics;
  }

  Future<List<Topic>> getTopicsSaved(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        return [];
      }

      final List<dynamic> topicIds = userDoc['topicIds'];

      final List<Topic> savedTopics = [];
      for (final topicId in topicIds) {
        final topicDoc = await _topicsCollection.doc(topicId).get();
        if (topicDoc.exists) {
          final topic = _fromSnapshot(topicDoc);
          topic.id = topicId;
          savedTopics.add(topic);
        }
      }
      return savedTopics;
    } catch (e) {
      print('Error fetching saved topics: $e');
      return [];
    }
  }

  Future<void> setStatusTopic(String status, String id) async {
    try {
      DocumentReference topicRef =
          FirebaseFirestore.instance.collection('topics').doc(id);
      Map<String, dynamic> dataToUpdate = {
        'status': status,
      };
      await topicRef.update(dataToUpdate);
    } catch (error) {
      print(error.toString());
    }
  }

  Topic _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Topic(
      id: doc.id,
      title: data['title'],
      creationTime: data['creationTime'],
      numberOfChildren: data['numberOfChildren'],
      learnedWords: data['learnedWords'],
      status: data['status'] != null
          ? EnumToString.fromString(STATUS.values, data['status'])
          : null,
      updateTime: data['updateTime'],
      user: data['user'] as DocumentReference?,
      views: data['views'],
    );
  }
}

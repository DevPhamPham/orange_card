import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orange_card/resources/models/word.dart';

class WordRepository {
  final CollectionReference _wordsCollection =
      FirebaseFirestore.instance.collection('words');

  Future<List<Word>> getAllWords(String topicId) async {
    List<Word> words = [];
    CollectionReference wordCollection =
        FirebaseFirestore.instance.collection("topics");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await wordCollection.doc(topicId).collection('words').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      Word word = Word.fromMap(doc.data(), doc.id);
      words.add(word);
    }
    return words;
  }

  Future<void> addWord(Word word) async {
    await _wordsCollection.add(word.toMap());
  }

  Future<void> updateWord(Word word) async {
    await _wordsCollection.doc(word.id).update(word.toMap());
  }

  Future<void> deleteWord(String id) async {
    await _wordsCollection.doc(id).delete();
  }

  Word _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Word(
      id: doc.id,
      english: data['english'],
      vietnamese: data['vietnamese'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      imageUrl: data['imageUrl'],
      learnt: data['learnt'],
      markedUser: data['markedUser'] ?? {},
    );
  }
}

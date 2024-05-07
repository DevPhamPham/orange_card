import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orange_card/resources/models/folder.dart';

class FolderRepository {
  final CollectionReference _foldersCollection =
      FirebaseFirestore.instance.collection('folders');

  Future<void> addFolder(Folder folder) async {
    try {
      await _foldersCollection.add(folder.toMap());
    } catch (e) {
      print('Error adding folder: $e');
      // Handle error
    }
  }

  Future<List<Folder>> getFolders(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _foldersCollection.where('userId', isEqualTo: userId).get();
      List<Folder> folders = querySnapshot.docs
          .map((doc) =>
              Folder.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      return folders;
    } catch (e) {
      print('Error getting folders: $e');
      // Handle error
      return [];
    }
  }

  Future<void> updateFolder(String folderId, Folder newFolderData) async {
    try {
      await _foldersCollection.doc(folderId).update(newFolderData.toMap());
    } catch (e) {
      print('Error updating folder: $e');
      // Handle error
    }
  }

  Future<void> deleteFolder(String folderId) async {
    try {
      await _foldersCollection.doc(folderId).delete();
    } catch (e) {
      print('Error deleting folder: $e');
      // Handle error
    }
  }

  Future<void> addTopicId(String folderId, String topicId) async {
    try {
      await _foldersCollection.doc(folderId).update({
        'topicIds': FieldValue.arrayUnion([topicId]),
      });
    } catch (e) {
      print('Error adding topic id: $e');
      // Handle error
    }
  }

  Future<void> removeTopicId(String folderId, String topicId) async {
    try {
      await _foldersCollection.doc(folderId).update({
        'topicIds': FieldValue.arrayRemove([topicId]),
      });
    } catch (e) {
      print('Error removing topic id: $e');
      // Handle error
    }
  }
}

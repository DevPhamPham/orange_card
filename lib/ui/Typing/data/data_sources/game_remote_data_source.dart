import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exception.dart';

abstract class TypingGameRemoteDataSource {
  Future<void> updateUserPoint(String uid, Map<String, dynamic> map);
  Future<void> updateUserGold(String uid, Map<String, dynamic> map);
}

class TypingGameRemoteDataSourceImpl implements TypingGameRemoteDataSource {
  final FirebaseFirestore _db;
  final String _users = "users";

  TypingGameRemoteDataSourceImpl(this._db);

  @override
  Future<void> updateUserPoint(String uid, Map<String, dynamic> map) async {
    try {
      await _db.collection(_users).doc(uid).update(map);
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> updateUserGold(String uid, Map<String, dynamic> map) async {
    try {
      await _db.collection(_users).doc(uid).update(map);
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/repositories/userRepository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository userRepository = UserRepository();
  UserCurrent? _userCurrent;
  UserCurrent? get userCurrent => _userCurrent;

  UserViewModel() {}

  Future<UserCurrent?> getUserByDocumentReference(
      DocumentReference? userRef) async {
    return await userRepository.getUserByDocumentReference(userRef);
  }

  bool checkCurrentUser(DocumentReference<Object?>? user) {
    return userRepository.checkCurrentUser(user);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String? id;
  String? title;
  int? creationTime;
  int? numberOfChildren;
  int? learnedWords;
  String? status;
  String? description;
  int? updateTime;
  List<DocumentReference>? users; // Updated to store document references
  int? views;

  Topic({
    this.id,
    this.title,
    this.creationTime,
    this.numberOfChildren,
    this.learnedWords,
    this.status,
    this.description,
    this.updateTime,
    this.users,
    this.views,
  });

  factory Topic.fromMap(Map<String, dynamic> map, String id) {
    return Topic(
      id: id,
      title: map['title'],
      creationTime: map['creationTime'],
      numberOfChildren: map['numberOfChildren'],
      learnedWords: map['learnedWords'],
      status: map['status'],
      description: map['description'],
      updateTime: map['updateTime'],
      users: (map['users'] as List<dynamic>?)
          ?.map((ref) => ref as DocumentReference)
          .toList(),
      views: map['views'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creationTime': creationTime,
      'numberOfChildren': numberOfChildren,
      'learnedWords': learnedWords,
      'status': status,
      'description': description,
      'updateTime': updateTime,
      'users': users
          ?.map((ref) => ref)
          .toList(), // Convert List<DocumentReference> to List<dynamic>
      'views': views,
    };
  }
}

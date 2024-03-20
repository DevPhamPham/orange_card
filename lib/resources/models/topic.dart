import 'package:orange_card/resources/models/word.dart';

class Topic {
  final String id;
  late final String title;
  final int creationTime;
  late int numberOfChildren;
  late int learnedWords;
  late int view;
  late List<Word> words;

  Topic(
      {required this.id,
      required this.title,
      required this.creationTime,
      required this.numberOfChildren,
      required this.learnedWords,
      required this.view,
      required this.words});

  Topic copyWith({
    String? id,
    String? title,
    int? creationTime,
    int? numberOfChildren,
    int? learnedWords,
    int? view,
  }) {
    return Topic(
      words: words,
      id: id ?? this.id,
      title: title ?? this.title,
      creationTime: creationTime ?? this.creationTime,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      learnedWords: learnedWords ?? this.learnedWords,
      view: view ?? this.view,
    );
  }
}

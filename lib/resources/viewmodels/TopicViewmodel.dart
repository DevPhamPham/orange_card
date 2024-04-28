import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/resources/repositories/topicRepository.dart';
import 'package:orange_card/resources/utils/enum.dart';
import '../models/topic.dart';
import '../models/word.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicRepository _topicRepository = TopicRepository();
  final List<Topic> _topics = [];
  final List<Topic> _filteredTopics = [];

  List<Topic> get topics => List.unmodifiable(_topics);
  List<Topic> get filteredTopics => List.unmodifiable(_filteredTopics);

  TopicViewModel() {
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    _topics.clear();
    _filteredTopics.clear();
    final topics = _topicRepository.getAllTopics();
    _topics.addAll(topics as Iterable<Topic>);
    _filteredTopics.addAll(topics as Iterable<Topic>);
    notifyListeners();
  }

  void addTopic(
      String title, List<Word> words, String description, bool mode) async {
    final topic = Topic(
      title: title,
      creationTime: DateTime.now().millisecondsSinceEpoch,
      numberOfChildren: words.length,
      learnedWords: 0,
      status: mode ? "Public" : "Private",
      views: 0,
      updateTime: DateTime.now().millisecondsSinceEpoch,
    );
    await _topicRepository.addTopic(topic, words);
    _loadTopics();
  }

  Future<void> deleteTopic(Topic topic) async {
    await _topicRepository.deleteTopic(topic.id!);
    _loadTopics();
  }

  Future<void> updateTopic(Topic topic) async {
    await _topicRepository.updateTopic(topic);
    _loadTopics();
  }

  Map<String, List<Topic>> groupedTopicsByDay(List<Topic> topics) {
    final Map<String, List<Topic>> groupedTopicsByDay = {};
    for (final topic in topics) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(topic.creationTime!);
      final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      groupedTopicsByDay.putIfAbsent(formattedDate, () => []);
      groupedTopicsByDay[formattedDate]?.add(topic);
    }
    return groupedTopicsByDay;
  }
}

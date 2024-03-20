import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/resources/models/word.dart';
import '../models/topic.dart';

class TopicViewModel extends ChangeNotifier {
  final List<Topic> _fakeTopics = [];
  late List<Topic> _filteredTopics = []; // List to store filtered topics

  List<Topic> get fakeTopics => List.unmodifiable(_fakeTopics);
  List<Topic> get filteredTopics => List.unmodifiable(_filteredTopics);

  TopicViewModel() {
    _generateFakeTopics();
  }

  void _generateFakeTopics() {
    int numberOfDays = 10;
    int topicsPerDay = 2;

    for (int i = 0; i < numberOfDays; i++) {
      for (int j = 0; j < topicsPerDay; j++) {
        List<Word> words = []; // Initialize words list
        _fakeTopics.add(
          Topic(
            words: words,
            id: 'topic_${i * topicsPerDay + j}',
            title: 'Topic ${i * topicsPerDay + j}',
            creationTime:
                DateTime.now().millisecondsSinceEpoch - (i * 86400000),
            numberOfChildren: 5,
            learnedWords: (i + 1) * 100,
            view: 0,
          ),
        );
      }
    }
  }

  void addTopic(String title, String description, List<Word> words) {
    _fakeTopics.add(
      Topic(
        id: '${_fakeTopics.length + 1}',
        title: title,
        creationTime: DateTime.now().millisecondsSinceEpoch,
        numberOfChildren: 0,
        learnedWords: 0,
        view: 0,
        words: words,
      ),
    );
    notifyListeners();
  }

  bool deleteTopic(Topic topic) {
    if (_fakeTopics.contains(topic)) {
      _fakeTopics.remove(topic);
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateTopic(Topic topic) {
    int index = _fakeTopics.indexWhere((element) => element.id == topic.id);
    if (index != -1) {
      _fakeTopics[index] = topic;
      notifyListeners();
    }
  }

  Map<String, List<Topic>> groupedTopicsByDay(List<Topic> topics) {
    Map<String, List<Topic>> groupedTopicsByDay = {};
    for (var topic in topics) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(topic.creationTime);
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      if (!groupedTopicsByDay.containsKey(formattedDate)) {
        groupedTopicsByDay[formattedDate] = [];
      }
      groupedTopicsByDay[formattedDate]?.add(topic);
    }
    return groupedTopicsByDay;
  }

  void _filterTopics(String query) {
    _filteredTopics = _fakeTopics.where((topic) {
      // Convert both the query and topic title to lowercase for case-insensitive comparison
      final lowerCaseQuery = query.toLowerCase();
      final lowerCaseTitle = topic.title.toLowerCase();
      return lowerCaseTitle.contains(lowerCaseQuery);
    }).toList();
    notifyListeners();
  }

  void filterTopics(String query) {
    if (query.isNotEmpty) {
      _filterTopics(query);
    } else {
      _filteredTopics.clear();
      notifyListeners();
    }
  }
}

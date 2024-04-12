import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/viewmodels/WordViewModel.dart';
import '../models/topic.dart';

class TopicViewModel extends ChangeNotifier {
  late List<Topic> _fakeTopics = [];
  late List<Topic> _filteredTopics = [];

  List<Topic> get fakeTopics => _fakeTopics;
  List<Topic> get filteredTopics => _filteredTopics;
  TopicViewModel() {
    _generateFakeTopics();
  }

  void _generateFakeTopics() {
    int numberOfDays = 3;
    int topicsPerDay = 2;

    for (int i = 0; i < numberOfDays; i++) {
      for (int j = 0; j < topicsPerDay; j++) {
        WordViewModel wordViewModel = WordViewModel();
        List<Word> words = wordViewModel.words;
        print(words.length);
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

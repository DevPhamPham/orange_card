import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/repositories/topicRepository.dart';
import 'package:orange_card/resources/repositories/wordRepository.dart';
import 'package:orange_card/resources/utils/enum.dart';
import '../models/topic.dart';
import '../models/word.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicRepository _topicRepository = TopicRepository();
  final WordRepository _wordRepository = WordRepository();
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;
  List<Word> _words = [];
  List<Word> get words => _words;
  Topic get topic => _topic;
  Topic _topic = Topic();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _isString = "Change";
  String get test => _isString;

  TopicViewModel() {
    loadTopics();
  }

  void clearTopic() {
    _topic = Topic();
    notifyListeners();
  }

  Future<void> loadTopics() async {
    try {
      _isLoading = true;
      notifyListeners();
      _topics = await _topicRepository
          .getAllTopicsByUserId(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      print('Error loading topics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDetailTopics(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      _topic = await _topicRepository.getTopicByID(id);
      _words = await _wordRepository.getAllWords(id);
    } catch (e) {
      print('Error loading topics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print(_isLoading);
    }
  }

  Future<void> addTopic(
      String title, List<Word> words, String description, bool isPublic) async {
    try {
      final topic = Topic(
        title: title,
        creationTime: DateTime.now().millisecondsSinceEpoch,
        numberOfChildren: words.length,
        learnedWords: 0,
        status: isPublic ? STATUS.PUBLIC : STATUS.PRIVATE,
        views: 0,
        updateTime: DateTime.now().millisecondsSinceEpoch,
      );
      await _topicRepository.addTopic(topic, words);
      loadTopics();
      notifyListeners();
    } catch (e) {
      print('Error adding topic: $e');
    }
  }

  Future<void> deleteTopic(Topic topic) async {
    try {
      await _topicRepository.deleteTopic(topic.id!);
      _topics.remove(topic);
      loadTopics();
      notifyListeners();
    } catch (e) {
      print('Error deleting topic: $e');
    }
  }

  Future<void> updateTopic(Topic topic, List<Word> words) async {
    try {
      await _topicRepository.updateTopic(topic, words);
      loadTopics();
      loadDetailTopics(topic.id!);
      notifyListeners();
    } catch (e) {
      print('Error updating topic: $e');
    }
  }
}

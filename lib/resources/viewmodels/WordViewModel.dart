import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/word.dart';

class WordViewModel extends ChangeNotifier {
  List<Word> _words = [];

  List<Word> get words => _words;
  WordViewModel() {
    fetchWords();
  }
  // Method to add a word
  void addWord(Word word) {
    _words.add(word);
  }

  // Method to update a word
  void updateWord(Word updatedWord) {
    final index = _words.indexWhere((word) => word.id == updatedWord.id);
    if (index != -1) {
      _words[index] = updatedWord;
    }
  }

  // Method to delete a word
  void deleteWord(String id) {
    _words.removeWhere((word) => word.id == id);
  }

  void fetchWords() {
    _words = [
      Word(
          id: '1',
          created_at: 123456789,
          type: 'Noun',
          english: 'Book',
          vietnamese: 'Sách',
          learnt: true),
      Word(
          id: '2',
          created_at: 123456789,
          type: 'Verb',
          english: 'Run',
          vietnamese: 'Chạy',
          learnt: true),
      Word(
          id: '3',
          created_at: 123456789,
          type: 'Adjective',
          english: 'Beautiful',
          vietnamese: 'Đẹp',
          learnt: false),
    ];
  }
}

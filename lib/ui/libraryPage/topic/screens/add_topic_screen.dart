import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/add_word_item.dart';

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  late List<Word> _words;
  String _topicName = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _words = [Word(id: '1', english: '', vietnamese: '', type: '', created_at: DateTime.now().microsecondsSinceEpoch)];
  }

  void _removeWordItem(int index) {
    setState(() {
      _words.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Topic"),
        backgroundColor: kPrimaryColor,
        titleTextStyle: const TextStyle(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Navigate back
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (value) {
                _topicName = value;
              },
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onChanged: (value) {
                _description = value;
              },
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return AddWordItem(
                    word: _words[index],
                    onDelete: () => _removeWordItem(index),
                    onUpdateWord: (updatedWord) {
                      setState(() {
                        _words[index] = updatedWord;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _words.add(Word(
                    id: (_words.length + 1).toString(),
                    english: '',
                    vietnamese: '', created_at:  DateTime.now().microsecondsSinceEpoch, type: '',
                  ));
                });
              },
              child: const Text('Thêm từ'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Topic Name: $_topicName');
                print('Description: $_description');
                _words.forEach((word) {
                  print(word.english);
                });
                Navigator.pop(context,[ _topicName,_description,_words]);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

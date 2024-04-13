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
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _words = [
      Word(
          id: '1',
          english: '',
          vietnamese: '',
          type: '',
          created_at: DateTime.now().microsecondsSinceEpoch,
          learnt: false),
    ];
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
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) {
                  _topicName = value;
                },
                decoration: const InputDecoration(
                    labelText: 'Tên',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: kPrimaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  _description = value;
                },
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
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
                      number: index + 1,
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
                        vietnamese: '',
                        created_at: DateTime.now().microsecondsSinceEpoch,
                        type: '',
                        learnt: false));
                  });
                },
                child: const Text('Thêm từ'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Topic Name: $_topicName');
                    print('Description: $_description');
                    for (var word in _words) {
                      print(word.english);
                    }
                    Navigator.pop(context, [_topicName, _description, _words]);
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

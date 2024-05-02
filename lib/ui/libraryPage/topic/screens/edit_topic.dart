import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/utils/enum.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/add_word_item.dart';
import 'package:orange_card/ui/message/sucess_message.dart';

class EditTopic extends StatefulWidget {
  final Topic topic;
  final List<Word> words;
  final TopicViewModel topicViewModel;
  const EditTopic(
      {super.key,
      required this.topic,
      required this.words,
      required this.topicViewModel});

  @override
  State<EditTopic> createState() => _EditTopicState();
}

class _EditTopicState extends State<EditTopic> {
  late List<Word> _words;
  String _topicName = '';
  final _formKey = GlobalKey<FormState>();
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _words = List<Word>.from(widget.words);
    _topicName = widget.topic.title ?? '';
    _isPublic = widget.topic.status == STATUS.PUBLIC;
  }

  void removeWordItem(int index) {
    setState(() {
      _words.removeAt(index);
    });
  }

  void updateWord(int index, Word updatedWord) {
    setState(() {
      _words[index] = updatedWord;
    });
  }

  Word createEmptyWord() {
    return Word(
      english: '',
      vietnamese: '',
      createdAt: DateTime.now().microsecondsSinceEpoch,
      learnt: STATUS.NOT_LEARN,
      updatedAt: 0,
      markedUser: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Topic"),
        backgroundColor: kPrimaryColor,
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
              buildTopicNameField(),
              const SizedBox(height: 16),
              Expanded(child: buildWordList()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildAddListByCSVButton(),
                  buildAddWordButton(),
                  buildSaveButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopicNameField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _topicName,
            onChanged: (value) {
              _topicName = value;
            },
            decoration: const InputDecoration(
              labelText: 'Tên',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Vui lòng nhập tên';
              }
              return null;
            },
          ),
        ),
        buildPublicSwitch(),
      ],
    );
  }

  Widget buildPublicSwitch() {
    return Column(
      children: [
        Switch(
          value: _isPublic,
          activeColor: Colors.orange,
          onChanged: (bool value) {
            setState(() {
              _isPublic = value;
            });
          },
        ),
        Text(_isPublic ? 'Public' : 'Private'),
      ],
    );
  }

  Widget buildWordList() {
    return ListView.builder(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        return AddWordItem(
          word: _words[index],
          onDelete: () => removeWordItem(index),
          onUpdateWord: (updatedWord) => updateWord(index, updatedWord),
          number: index + 1,
        );
      },
    );
  }

  Widget buildAddWordButton() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: kPrimaryColor,
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              _words.add(createEmptyWord());
            });
          },
          constraints: const BoxConstraints.tightFor(width: 50, height: 50),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildAddListByCSVButton() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: kPrimaryColor,
        ),
        child: IconButton(
          onPressed: () {},
          constraints: const BoxConstraints.tightFor(width: 50, height: 50),
          icon: const Icon(
            Icons.file_upload,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: kPrimaryColor,
        ),
        child: IconButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _updateTopic();
            }
          },
          constraints: const BoxConstraints.tightFor(width: 50, height: 50),
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _updateTopic() async {
    await widget.topicViewModel.updateTopic(
      Topic(
        id: widget.topic.id,
        title: _topicName,
        user: widget.topic.user,
        status: _isPublic ? STATUS.PUBLIC : STATUS.PRIVATE,
        numberOfChildren: _words.length,
        updateTime: DateTime.now().microsecondsSinceEpoch,
      ),
      _words,
    );
    MessageUtils.showSuccessMessage(context, "Cập nhật thành công !");
    Navigator.pop(context);
  }
}
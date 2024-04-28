import 'package:flutter/material.dart';
import 'package:orange_card/resources/viewmodels/topicViewmodel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/list_topic_body.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/add_topic_screen.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({Key? key}) : super(key: key);

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late TopicViewModel _topicViewModel; // Declare ViewModel

  @override
  void initState() {
    super.initState();
    _topicViewModel = TopicViewModel(); // Initialize ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          ListTopic(viewModel: _topicViewModel), // Pass ViewModel to ListTopic
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<List>(
            context: context,
            builder: (_) => const AddTopicScreen(),
          );
        },
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

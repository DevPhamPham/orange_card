import 'package:flutter/material.dart';
import 'package:orange_card/resources/viewmodels/topicViewmodel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/list_topic_item.dart';

class ListTopic extends StatefulWidget {
  final TopicViewModel viewModel;

  const ListTopic({super.key, required this.viewModel});

  @override
  State<ListTopic> createState() => _ListTopicState();
}

class _ListTopicState extends State<ListTopic> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
                fillColor: Colors.white,
                focusColor: kPrimaryColor),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListTopicItem(
                viewModel: widget.viewModel,
                topics: widget.viewModel.topics,
              )),
        ),
      ],
    );
  }
}

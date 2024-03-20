import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/ui/auth/constants.dart';

class TopicDetail extends StatefulWidget {
  final Topic topic;
  const TopicDetail({Key? key, required this.topic}) : super(key: key);

  @override
  State<TopicDetail> createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        backgroundColor: kPrimaryColor,
        leading: const Icon(Icons.arrow_back,color: Colors.white,),
      ),
      body: const Center(
        child:  Text('Topic Details'), // Placeholder for topic details
      ),
    );
  }
}

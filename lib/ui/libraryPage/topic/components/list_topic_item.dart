import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/topicViewmodel.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:orange_card/ui/libraryPage/topic/components/card_item.dart';
import 'package:orange_card/resources/models/user.dart';

class ListTopicItem extends StatefulWidget {
  final TopicViewModel viewModel;
  final List<Topic> topics;

  ListTopicItem({
    Key? key,
    required this.viewModel,
    required this.topics,
  }) : super(key: key);

  @override
  _ListTopicItemState createState() => _ListTopicItemState();
}

class _ListTopicItemState extends State<ListTopicItem> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.topics.length,
      itemBuilder: (context, index) {
        Topic topic = widget.topics[index];
        return GestureDetector(
          onTap: () async {
            UserCurrent user = UserCurrent(
                username: FirebaseAuth.instance.currentUser!.email.toString(),
                avatar: "");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicDetail(
                  topic: topic,
                  user: user,
                ),
              ),
            );
          },
          child: Dismissible(
            key: Key(topic.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                widget.topics.remove(topic);
                widget.viewModel.deleteTopic(topic);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Deleted ${topic.title}"),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      setState(() {
                        widget.topics.insert(index, topic);
                      });
                    },
                  ),
                ),
              );
            },
            child: TopicCardItem(
              topic: topic,
              onEdit: (topic) {
                setState(() {
                  widget.viewModel.updateTopic(topic);
                });
              },
            ),
          ),
        );
      },
    );
  }
}

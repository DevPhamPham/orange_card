import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/viewmodels/topicViewmodel.dart';
import 'package:orange_card/ui/libraryPage/topic/components/card_item.dart';
import 'package:orange_card/ui/message/sucess_message.dart';

class ListTopicItem extends StatefulWidget {
  final TopicViewModel viewModel;
  final List<Topic> topics;

  const ListTopicItem({super.key, required this.viewModel, required this.topics});
  @override
  // ignore: library_private_types_in_public_api
  _ListTopicItemState createState() => _ListTopicItemState();
}

class _ListTopicItemState extends State<ListTopicItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildDayContainers(widget.viewModel.fakeTopics, context),
    );
  }

  List<Widget> _buildDayContainers(List<Topic> topics, BuildContext context) {
    List<Widget> dayContainers = [];
    Map<String, List<Topic>> groupedTopicsByDay = widget.viewModel.groupedTopicsByDay(topics);
    groupedTopicsByDay.forEach((day, topics) {
      dayContainers.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Column(
                children: topics.map((topic) {
                  return TopicCardItem(
                    topic: topic,
                    onDelete: (topic) {
                      setState(() {
                        bool delete = widget.viewModel.deleteTopic(topic);
                        if (delete) {
                          MessageUtils.showSuccessMessage(context,"Delete Topic ${topic.title}");
                        }else{
                          MessageUtils.showFailureMessage(context,"Delete Topic ${topic.title} Fail");
                        }
                      });
                    },
                    onEdit: (topic) {
                      setState(() {
                        widget.viewModel.updateTopic(topic);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    });
    return dayContainers;
  }
}

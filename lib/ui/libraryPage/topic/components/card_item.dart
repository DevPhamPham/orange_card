import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/dialog_edit_topic.dart';

class TopicCardItem extends StatelessWidget {
  final Topic topic;
  final Function(Topic)? onEdit;
  final Function(Topic)? onDelete;

  const TopicCardItem({
    super.key,
    required this.topic,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        shadowColor: kPrimaryColorBlur,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                        child: Icon(
                          Icons.topic,
                          size: 30.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title.toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Time: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(topic.creationTime!))}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Children: ${topic.numberOfChildren.toString()}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 0 && onEdit != null) {
                    final Topic? topicUpdated = await showDialog<Topic>(
                      context: context,
                      builder: (_) => EditTopicDialog(topic: topic),
                    );
                    if (topicUpdated != null) {
                      onEdit!(topicUpdated);
                    }
                  } else if (value == 1 && onDelete != null) {
                    onDelete!(topic);
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem<int>(
                      value: 0,
                      child:
                          Text('Edit', style: TextStyle(color: Colors.black)),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem<int>(
                      value: 1,
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

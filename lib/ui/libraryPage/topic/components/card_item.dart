import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/repositories/userRepository.dart';
import 'package:orange_card/constants/constants.dart';
import 'package:orange_card/ui/libraryPage/topic/components/dialog_edit_topic.dart';

class TopicCardItem extends StatefulWidget {
  final Topic topic;
  final Function(Topic)? onEdit;
  final Function(Topic)? onDelete;

  const TopicCardItem({
    Key? key,
    required this.topic,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _TopicCardItemState createState() => _TopicCardItemState();
}

class _TopicCardItemState extends State<TopicCardItem> {
  String? _avatarUrl;
  String? _username;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      UserCurrent? user = await UserRepository().userFromDocumentReference(
          widget.topic.user as DocumentReference<Map<String, dynamic>>?);
      setState(() {
        _avatarUrl = user?.avatar;
        _username = user?.username;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Card(
        elevation: 6,
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
                      _avatarUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_avatarUrl!),
                              radius: 30,
                            )
                          : const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://i.pinimg.com/236x/7f/e0/3e/7fe03e29bf34dca114b4c22f11513a5b.jpg"),
                              radius: 30,
                            ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.topic.title.toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '$_username' ?? "Loading ...",
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'word : ${widget.topic.numberOfChildren.toString()}',
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
                  if (value == 0 && widget.onEdit != null) {
                    final Topic? topicUpdated = await showDialog<Topic>(
                      context: context,
                      builder: (_) => EditTopicDialog(topic: widget.topic),
                    );
                    if (topicUpdated != null) {
                      widget.onEdit!(topicUpdated);
                    }
                  } else if (value == 1 && widget.onDelete != null) {
                    widget.onDelete!(widget.topic);
                  }
                },
                itemBuilder: (context) => [
                  if (widget.onEdit != null)
                    const PopupMenuItem<int>(
                      value: 0,
                      child:
                          Text('Edit', style: TextStyle(color: Colors.black)),
                    ),
                  if (widget.onDelete != null)
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

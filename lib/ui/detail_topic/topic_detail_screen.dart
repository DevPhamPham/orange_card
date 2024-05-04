import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/repositories/userRepository.dart';
import 'package:orange_card/resources/services/CSVService.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/FlashCard/flashcard.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/detail_topic/components/word_item.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/edit_topic.dart';
import 'package:orange_card/ui/message/sucess_message.dart';
import 'package:orange_card/ui/skelton/detailTopic.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TopicDetail extends StatefulWidget {
  final UserCurrent user;
  final Topic topic;
  final TopicViewModel topicViewModel;
  const TopicDetail({
    super.key,
    required this.topic,
    required this.user,
    required this.topicViewModel,
  });

  @override
  _TopicDetailState createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  late final TopicViewModel topicViewModel;

  Future<void> setData() async {
    topicViewModel = Provider.of<TopicViewModel>(context);
    topicViewModel.loadDetailTopics(widget.topic.id!);
  }

  @override
  Widget build(BuildContext context) {
    final List<UserCard> users = List.generate(3, (index) {
      return UserCard(
        avatarUrl:
            "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
        rank: index + 1,
      );
    });
    final topicViewModel = Provider.of<TopicViewModel>(context);
    final userViewModel = UserRepository();
    bool check = userViewModel.checkCurrentUser(widget.topic.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Topic Detail",
          style: AppTheme.title_appbar2,
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, topicViewModel);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.more_vert),
      ),
      body: widget.topicViewModel.isLoading
          ? const DetailTopicSkeletonLoading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    elevation: 5,
                    shadowColor: kPrimaryColorBlur,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: kPrimaryColor, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              radius: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.topicViewModel.topic.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMicrosecondsSinceEpoch(widget
                                          .topicViewModel.topic.creationTime!)),
                                ),
                                Text(
                                  widget.user.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: CircularPercentIndicator(
                              radius: 30.0,
                              animation: true,
                              animationDuration: 800,
                              lineWidth: 5.0,
                              percent: widget.topic.learnedWords! /
                                  widget.topicViewModel.topic.numberOfChildren!,
                              center: widget.topic.learnedWords !=
                                      widget
                                          .topicViewModel.topic.numberOfChildren
                                  ? Text(
                                      "${widget.topic.learnedWords}/${widget.topicViewModel.topic.numberOfChildren}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : const Text(
                                      "Great",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 110, 255, 115),
                                      ),
                                    ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor:
                                  const Color.fromARGB(188, 218, 218, 218),
                              progressColor: widget.topic.learnedWords == 0
                                  ? const Color.fromARGB(255, 255, 0, 0)
                                  : widget.topic.learnedWords !=
                                          widget.topicViewModel.topic
                                              .numberOfChildren
                                      ? const Color.fromARGB(255, 255, 123,
                                          0) // Color for unlearned words (orange)
                                      : const Color.fromARGB(
                                          255, 110, 255, 115),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 15, top: 15),
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        elevation: 4,
                        color: kPrimaryColorBlur,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(user.avatarUrl),
                                radius: 30,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Top ${user.rank}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlashCard(
                                    topicViewModel: topicViewModel,
                                    words: topicViewModel.words)),
                          );
                        },
                        child: const Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.analytics,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Flashcard",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.purpleAccent,
                              child: Icon(
                                Icons.quiz,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Quiz",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Typing",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: const SizedBox(
                    child: Text(
                      "Từ vựng",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 80),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.topicViewModel.words.length,
                            itemBuilder: (context, index) {
                              final word = widget.topicViewModel.words[index];
                              return WordItem(
                                Auth: check,
                                word: word,
                                backgroundColor: index % 2 == 0
                                    ? const Color.fromARGB(197, 255, 213, 150)
                                    : const Color.fromARGB(255, 255, 239, 224),
                                TopicId: widget.topic.id!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showBottomSheet(BuildContext context, TopicViewModel topicViewModel) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildActionIconWithText(
                icon: Icons.save,
                text: 'Tải về',
                onPressed: () async {
                  String? filename = await CSVService().makeFile(context,
                      widget.topicViewModel.words, widget.topic.title!);
                  if (filename != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('File Tải Thành Công'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tên File: $filename'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                if (filename != null) {
                                  await OpenFile.open(filename);
                                } else {
                                  // Error saving file, show error message
                                  MessageUtils.showFailureMessage(
                                      context, "Lỗi khi tải file");
                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Mở File'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Đóng'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    MessageUtils.showFailureMessage(
                        context, "Lỗi khi tải file");
                  }
                },
              ),
              _buildActionIconWithText(
                icon: Icons.edit,
                text: 'Chỉnh sửa',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTopic(
                              topic: widget.topicViewModel.topic,
                              words: widget.topicViewModel.words,
                              topicViewModel: topicViewModel,
                            )),
                  );
                  setState(() {});
                },
              ),
              _buildActionIconWithText(
                icon: Icons.create_new_folder,
                text: 'Thêm vào Thư mục',
                onPressed: () {
                  // Add functionality for addfolder action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionIconWithText({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            color: kPrimaryColor,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}

class UserCard {
  final String avatarUrl;
  final int rank;
  UserCard({required this.avatarUrl, required this.rank});
}

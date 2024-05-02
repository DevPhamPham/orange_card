import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/resources/viewmodels/WordViewModel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/detail_topic/components/word_item.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/edit_topic.dart';
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
  late int learnt = 0;
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
      body: widget.topicViewModel.isLoading
          ? const DetailTopicSkeletonLoading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.topicViewModel.topic.title!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: kPrimaryColor,
                                          size: 18,
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditTopic(
                                                      topic: widget
                                                          .topicViewModel.topic,
                                                      words: widget
                                                          .topicViewModel.words,
                                                      topicViewModel:
                                                          topicViewModel,
                                                    )),
                                          );
                                          setState(() {});
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Text(widget.topicViewModel.test),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMicrosecondsSinceEpoch(widget
                                          .topicViewModel
                                          .topic!
                                          .creationTime!)),
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
                              percent: learnt /
                                  widget.topicViewModel.topic.numberOfChildren!,
                              center: learnt !=
                                      widget
                                          .topicViewModel.topic.numberOfChildren
                                  ? Text(
                                      "$learnt/${widget.topicViewModel.topic.numberOfChildren}",
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
                              progressColor: learnt !=
                                      widget.topicViewModel.topic!
                                          .numberOfChildren
                                  ? const Color.fromARGB(255, 255, 123, 0)
                                  : const Color.fromARGB(255, 110, 255, 115),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Text(
                      "Từ vựng",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.topicViewModel.words.length,
                    itemBuilder: (context, index) {
                      final word = widget.topicViewModel.words[index];
                      return WordItem(
                        word: word,
                        backgroundColor: index % 2 == 0
                            ? const Color.fromARGB(134, 245, 193, 145)
                            : const Color.fromARGB(255, 255, 239, 224),
                      );
                    },
                  ),
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

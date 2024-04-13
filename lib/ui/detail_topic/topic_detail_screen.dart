import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/detail_topic/components/animation_rank.dart';
import 'package:orange_card/ui/detail_topic/components/word_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TopicDetail extends StatefulWidget {
  final UserCurrent user;
  final Topic topic;

  const TopicDetail({
    Key? key,
    required this.topic,
    required this.user,
  }) : super(key: key);

  @override
  _TopicDetailState createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  late int learnt = 0;
  @override
  void initState() {
    super.initState();
    setLearntWord();
    // Add initialization code here
  }

  @override
  Widget build(BuildContext context) {
    final List<UserCard> users = [
      UserCard(
          avatarUrl:
              "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
          rank: 1),
      UserCard(
          avatarUrl:
              "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
          rank: 2),
      UserCard(
          avatarUrl:
              "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
          rank: 3),
      UserCard(
          avatarUrl:
              "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
          rank: 3),
      UserCard(
          avatarUrl:
              "https://i.pinimg.com/736x/1c/b2/73/1cb2738b9cf909d4507298a6052c5761.jpg",
          rank: 3),
      // Add more users as needed
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topic Detail"),
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
      body: Column(
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
                  side: const BorderSide(color: kPrimaryColor, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://cdn.discordapp.com/attachments/961226655412670484/1226846971239727125/435464821_954991279331225_1075893805650300255_n.png?ex=66264147&is=6613cc47&hm=3a93e5bc27247c70d5006043f97c75ba1104966b7254c1113bade24a0653774a&',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.topic.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Created at: ${DateFormat('HH:mm - dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(widget.topic.creationTime))}',
                          ),
                          Text("Username: ${widget.user.username}"),
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
                        percent: learnt / widget.topic.words.length,
                        center: learnt != widget.topic.words.length
                            ? Text(
                                "$learnt/${widget.topic.words.length}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : const Text(
                                "Great",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 110, 255, 115)),
                              ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor:
                            const Color.fromARGB(188, 218, 218, 218),
                        progressColor: learnt != widget.topic.words.length
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
                    child: index == 0
                        ? Column(
                            children: [
                              AnimatedGradientBorder(
                                imageUrl: user.avatarUrl,
                                radius: 30,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Top ${user.rank}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(user.avatarUrl),
                                radius: 30,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: widget.topic.words.length,
              itemBuilder: (context, index) {
                final word = widget.topic.words[index];
                return WordItem(
                  word: word,
                  backgroundColor: index % 2 == 0
                      ? const Color.fromARGB(134, 245, 193, 145)
                      : Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void setLearntWord() {
    for (Word word in widget.topic.words) {
      if (word.learnt) {
        learnt += 1;
      }
    }
  }
}

class UserCard {
  final String avatarUrl;
  final int rank;
  UserCard({required this.avatarUrl, required this.rank});
}

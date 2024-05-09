import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/communityPage/components/card_community_item.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:provider/provider.dart';

class MyBags extends StatefulWidget {
  final TopicViewModel topicViewModel;
  const MyBags({super.key, required this.topicViewModel});

  @override
  State<MyBags> createState() => _MyBagsState();
}

class _MyBagsState extends State<MyBags> {
  @override
  Widget build(BuildContext context) {
    return widget.topicViewModel.topcicsSaved.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/empty_bag.svg',
                  width: 200,
                  // height: 100,
                ),
                const SizedBox(height: 16),
                const Text('Bag empty now', style: AppTheme.caption),
              ],
            ),
          )
        : ListView.builder(
            itemCount: widget.topicViewModel.topicsPublic.length,
            itemBuilder: (context, index) {
              final topic = widget.topicViewModel.topicsPublic[index];
              return GestureDetector(
                onTap: () async {
                  final currentUser = UserCurrent(
                    username:
                        FirebaseAuth.instance.currentUser!.email.toString(),
                    avatar: "",
                    topicIds: [],
                  );
                  await _navigateToTopicDetailScreen(
                      context, topic, currentUser);
                },
                child: TopicCardCommunityItem(
                  topic: topic,
                ),
              );
            },
          );
  }

  Future<void> _navigateToTopicDetailScreen(
      BuildContext context, Topic topic, UserCurrent user) async {
    final TopicViewModel topicViewModel =
        Provider.of<TopicViewModel>(context, listen: false);
    topicViewModel.clearTopic();
    topicViewModel.loadDetailTopics(topic.id!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetail(
            topic: topic, user: user, topicViewModel: topicViewModel),
      ),
    );
  }
}

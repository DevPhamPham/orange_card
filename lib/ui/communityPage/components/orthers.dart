import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/communityPage/components/card_community_item.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:orange_card/ui/skelton/topic.dart';
import 'package:provider/provider.dart';

class Orthers extends StatefulWidget {
  const Orthers({super.key, required this.topicViewModel});
  final TopicViewModel topicViewModel;
  @override
  State<Orthers> createState() => _OrthersState();
}

class _OrthersState extends State<Orthers> {
  @override
  Widget build(BuildContext context) {
    return widget.topicViewModel.isLoading
        ? ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return TopicCardSkeleton();
            },
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

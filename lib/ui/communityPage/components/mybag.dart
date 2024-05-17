import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/resources/viewmodels/UserViewModel.dart';
import 'package:orange_card/ui/communityPage/components/card_community_item.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:provider/provider.dart';

class MyBags extends StatefulWidget {
  final TopicViewModel topicViewModel;
  final UserViewModel userViewModel;

  const MyBags(
      {super.key, required this.topicViewModel, required this.userViewModel});

  @override
  State<MyBags> createState() => _MyBagsState();
}

class _MyBagsState extends State<MyBags> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setdata();
      },
      child: widget.topicViewModel.topcicsSaved.isEmpty
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
                  const Text('Danh sách trống...', style: AppTheme.caption),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.topicViewModel.topcicsSaved.length,
              itemBuilder: (context, index) {
                final topic = widget.topicViewModel.topcicsSaved[index];
                return GestureDetector(
                  onTap: () async {
                    await _navigateToTopicDetailScreen(context, topic);
                  },
                  child: TopicCardCommunityItem(
                    topic: topic,
                    like: widget.userViewModel.userCurrent!.topicIds
                        .contains(topic.id),
                    userViewModel: widget.userViewModel,
                  ),
                );
              },
            ),
    );
  }

  Future<void> _navigateToTopicDetailScreen(
      BuildContext context, Topic topic) async {
    final TopicViewModel topicViewModel =
        Provider.of<TopicViewModel>(context, listen: false);
    final UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    UserCurrent? owner =
        await userViewModel.getUserByDocumentReference(topic.user);
    topicViewModel.clearTopic();
    topicViewModel.loadDetailTopics(topic.id!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetail(
            topic: topic, user: owner!, topicViewModel: topicViewModel),
      ),
    );
  }

  Future<void> setdata() async {
    await widget.topicViewModel.loadTopicsSaved();
  }
}

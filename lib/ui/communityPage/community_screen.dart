import 'package:flutter/material.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/resources/viewmodels/UserViewModel.dart';
import 'package:orange_card/ui/communityPage/components/app_bar.dart';
import 'package:orange_card/ui/communityPage/components/community_page.dart';
import 'package:provider/provider.dart';

class CommunityPageScreen extends StatefulWidget {
  const CommunityPageScreen({super.key});

  @override
  _CommunityPageScreenState createState() => _CommunityPageScreenState();
}

class _CommunityPageScreenState extends State<CommunityPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topicViewModel = Provider.of<TopicViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getUserById();
    topicViewModel.loadTopicsPublic();
    topicViewModel.loadTopicsSaved();
    return Scaffold(
      appBar: const CommunityPageAppBar(),
      body: CommunityPage(
          topicViewModel: topicViewModel, userViewModel: userViewModel),
    );
  }
}

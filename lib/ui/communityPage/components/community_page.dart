import 'package:flutter/material.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/communityPage/components/mybag.dart';
import 'package:orange_card/ui/communityPage/components/orthers.dart';
import 'package:provider/provider.dart'; // Nếu cần import Word

class CommunityPage extends StatefulWidget {
  final TopicViewModel topicViewModel;
  const CommunityPage({super.key, required this.topicViewModel});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TopicViewModel>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Others'),
                  Tab(text: 'Your Bag'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    Orthers(topicViewModel: widget.topicViewModel),
                    MyBags(topicViewModel: widget.topicViewModel)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

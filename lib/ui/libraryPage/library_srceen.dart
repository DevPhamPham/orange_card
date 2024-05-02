import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/components/app_bar.dart';
import 'package:orange_card/ui/libraryPage/folder/srceens/folder_screen.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/topic_screen.dart';
import 'package:provider/provider.dart';

class LibraryPageScreen extends StatefulWidget {
  const LibraryPageScreen({Key? key});

  @override
  _LibraryPageScreenState createState() => _LibraryPageScreenState();
}

class _LibraryPageScreenState extends State<LibraryPageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TopicViewModel viewModel;
  final List<Tab> _listTab = [
    const Tab(
      text: 'Topics',
    ),
    const Tab(
      text: 'Folders',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TopicViewModel>(context, listen: false);
    _tabController =
        TabController(length: _listTab.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TopicViewModel>(context);
    return Scaffold(
      appBar: const LibraryPageAppBar(),
      body: Container(
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 4,
                tabs: _listTab,
                labelColor: Colors.white,
                labelStyle: AppTheme.title_tabbar,
                unselectedLabelColor: kPrimaryColor,
                indicatorColor: kPrimaryColor,
                indicator: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorPadding: const EdgeInsets.only(left: 20, right: 20),
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 5),
                onTap: (index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TopicScreen(
                    key: null,
                    topicViewModel: viewModel,
                  ),
                  FolderScreen(
                    key: null,
                    viewModel: viewModel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

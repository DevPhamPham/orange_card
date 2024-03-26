import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/libraryPage/components/app_bar.dart';
import 'package:orange_card/ui/libraryPage/folder/srceens/folder_screen.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/topic_screen.dart';

class LibraryPageScreen extends StatelessWidget {
  const LibraryPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LibraryPageAppBar(),
      body: Container(
        color: Colors.blue, // Set the background color here
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              indicatorWeight: 4,
              tabs: const [
                Tab(
                  text: 'Topics',
                ),
                Tab(
                  text: 'Folders',
                ),
              ],
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
              padding: const EdgeInsets.only(left: 20, right: 20,bottom: 5,top: 5),
            ),
            body: const TabBarView(
              children: [
                TopicScreen(key: null),
                FolderScreen(key: null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

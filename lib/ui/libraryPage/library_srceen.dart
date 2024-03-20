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
    return const Scaffold(
      appBar: LibraryPageAppBar(),
      body: DefaultTabController(
        length: 2, // Specify the number of tabs
        child: Scaffold(
          appBar: TabBar(
            indicatorSize: TabBarIndicatorSize
                .label, // Đặt kích thước của thanh chỉ báo bằng kích thước của nhãn
            indicatorWeight: 4, // Đặt độ dày của thanh chỉ báo
            tabs: [
              Tab(
                text: 'Topics',
                
              ),
              Tab(
                text: 'Folders',
              ),
            ],
            labelColor: kPrimaryColor,
            labelStyle: AppTheme.title_tabbar,
            unselectedLabelColor: Colors.grey,
            indicatorColor: kPrimaryColor,
          ),
          body: TabBarView(
            children: [
              TopicScreen(key : null),
              FolderScreen(key: null),
            ],
          ),
        ),
      ),
    );
  }
}

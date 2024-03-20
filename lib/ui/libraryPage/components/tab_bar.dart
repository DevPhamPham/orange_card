import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/ui/auth/constants.dart';

class LibraryTabBar extends StatefulWidget {
  const LibraryTabBar({super.key});

  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorSize: TabBarIndicatorSize
          .label, // Đặt kích thước của thanh chỉ báo bằng kích thước của nhãn
      indicatorWeight: 4, // Đặt độ dày của thanh chỉ báo
      tabs: [
        Tab(
          text: 'Folders',
        ),
        Tab(
          text: 'Topics',
        ),
      ],
      labelColor: kPrimaryColor,
      labelStyle: AppTheme.title_tabbar,
      unselectedLabelColor: Colors.grey,
      indicatorColor: kPrimaryColor,
    );
  }
}

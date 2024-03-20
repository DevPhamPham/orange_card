import 'package:flutter/material.dart';
import 'package:orange_card/ui/communityPage/components/app_bar.dart';

class CommunityPageScreen extends StatelessWidget {
  const CommunityPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommunityPageAppBar(),
    );
  }
}




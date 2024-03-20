import 'package:flutter/material.dart';
import 'package:orange_card/ui/personalPage/components/app_bar.dart';

class PersionalPageScreen extends StatelessWidget {
  const PersionalPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PersionalPageAppBar(),
      
    );
  }
}




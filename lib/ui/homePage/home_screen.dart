import 'package:flutter/material.dart';
import 'package:orange_card/ui/homePage/components/app_bar.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomePageAppBar(),
    );
  }
}




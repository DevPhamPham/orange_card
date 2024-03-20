import 'package:flutter/material.dart';
import 'package:orange_card/ui/auth/constants.dart';

import '../components/listFolder.dart';



class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}


class _FolderScreenState extends State<FolderScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ListFolder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        backgroundColor: kPrimaryColor, 
        foregroundColor: Colors.white, 
        shape: const CircleBorder(),
        child: const Icon(Icons.add), 
      ),
    );
  }

  
}

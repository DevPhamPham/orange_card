import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/folder.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/FolderViewModel.dart';
import 'package:orange_card/resources/viewmodels/UserViewModel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:orange_card/ui/libraryPage/topic/components/card_item.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/add_topic_screen.dart';
import 'package:orange_card/ui/message/sucess_message.dart';
import 'package:orange_card/ui/skelton/topic.dart';
import 'package:provider/provider.dart';
import '../../../../resources/viewmodels/TopicViewmodel.dart';

class DetailFolder extends StatefulWidget {
  final Folder folder;
  final FolderViewModel folderViewModel;

  const DetailFolder(
      {super.key, required this.folderViewModel, required this.folder});

  @override
  State<DetailFolder> createState() => _DetailFolderState();
}

class _DetailFolderState extends State<DetailFolder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.title),
        titleTextStyle: AppTheme.title_appbar,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await setdata();
        },
        child: _buildTopicList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await _navigateToAddTopicScreen(context);
          // await setdata();
          setState(() {});
        },
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTopicList() {
    return widget.folderViewModel.isLoading
        ? ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return TopicCardSkeleton();
            },
          )
        : widget.folderViewModel.topics.isEmpty
            ? const Center(child: Text('Chưa có chủ đề nào'))
            : ListView.builder(
                itemCount: widget.folderViewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = widget.folderViewModel.topics[index];
                  return GestureDetector(
                    onTap: () async {
                      final currentUser = UserCurrent(
                        username:
                            FirebaseAuth.instance.currentUser!.email.toString(),
                        avatar: "",
                        topicIds: [],
                      );
                      await _navigateToTopicDetailScreen(
                          context, topic, currentUser);
                    },
                    child: TopicCardItem(
                      topic: topic,
                    ),
                  );
                },
              );
  }

  Future<void> _navigateToAddTopicScreen(BuildContext context) async {
    await showDialog<List>(
      context: context,
      builder: (_) => const AddTopicScreen(),
    );
  }

  Future<void> _navigateToTopicDetailScreen(
      BuildContext context, Topic topic, UserCurrent user) async {
    final TopicViewModel topicViewModel =
        Provider.of<TopicViewModel>(context, listen: false);
    final UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    UserCurrent? userCurrent =
        await userViewModel.getUserByDocumentReference(topic.user);
    topicViewModel.clearTopic();
    topicViewModel.loadDetailTopics(topic.id!);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetail(
            topic: topic, user: userCurrent!, topicViewModel: topicViewModel),
      ),
    );
  }

  void _showDeleteConfirmation(Topic topic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận Xóa"),
          content: const Text("Bạn có chắc muốn xóa chủ đề này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  Future<void> setdata() async {
    await widget.folderViewModel.getTopicInModel(widget.folder.topicIds);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/user.dart';
import 'package:orange_card/resources/viewmodels/UserViewModel.dart';
import 'package:orange_card/ui/auth/constants.dart';
import 'package:orange_card/ui/detail_topic/topic_detail_screen.dart';
import 'package:orange_card/ui/libraryPage/topic/components/card_item.dart';
import 'package:orange_card/ui/libraryPage/topic/screens/add_topic_screen.dart';
import 'package:orange_card/ui/skelton/topic.dart';
import 'package:provider/provider.dart';
import '../../../../resources/viewmodels/TopicViewmodel.dart';
import '../../../message/sucess_message.dart';
import '../components/dialog_edit_topic.dart';

class TopicScreen extends StatefulWidget {
  final TopicViewModel topicViewModel;

  const TopicScreen({super.key, required this.topicViewModel});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  @override
  void initState() {
    super.initState();
    // setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await setdata();
        },
        child: _buildTopicList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _navigateToAddTopicScreen(context);
          await setdata();
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
    return widget.topicViewModel.isLoading
        ? ListView.builder(
            itemCount: 5, // Adjust the number of skeleton cards as needed
            itemBuilder: (context, index) {
              return TopicCardSkeleton();
            },
          )
        : widget.topicViewModel.topics.isEmpty
            ? const Center(child: Text('Chưa có chủ đề nào'))
            : ListView.builder(
                itemCount: widget.topicViewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = widget.topicViewModel.topics[index];
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
                      onDelete: (topic) {
                        _showDeleteConfirmation(topic);
                      },
                      onEdit: (topic) {
                        _navigateToEditTopicScreen(context, topic);
                      },
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

  Future<void> _navigateToEditTopicScreen(
      BuildContext context, Topic topic) async {
    final updatedTopic = await showDialog<Topic>(
      context: context,
      builder: (_) => EditTopicDialog(topic: topic),
    );
    if (updatedTopic != null) {
      // widget.topicViewModel.updateTopic(updatedTopic,);
    }
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
                await _deleteTopic(topic);
                Navigator.pop(context);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTopic(Topic topic) async {
    await widget.topicViewModel.deleteTopic(topic);
    MessageUtils.showSuccessMessage(
      context,
      "Đã xóa thành công chủ đề ${topic.title}",
    );
  }

  Future<void> setdata() async {
    await widget.topicViewModel.loadTopics();
  }
}

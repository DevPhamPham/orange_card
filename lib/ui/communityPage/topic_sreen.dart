import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicTitle;

  const TopicDetailScreen({Key? key, required this.topicTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          title: Text(topicTitle),
          backgroundColor: AppTheme.kPrimaryColor,
          bottom: const TabBar(
            labelColor: Colors.white, // Màu chữ cho tab được chọn
            unselectedLabelColor:
                AppTheme.deactivatedText, // Màu chữ cho các tab không được chọn
            tabs: [
              Tab(text: 'Flashcard'),
              Tab(text: 'Quiz'),
              Tab(text: 'Typing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(Icons.analytics, "Start To Study With Flashcard"),
            _buildTabContent(Icons.quiz, "Start To Study With Quiz"),
            _buildTabContent(Icons.edit, "Start To Study With Typing"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(IconData icon, String label) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildLearningOption(icon, label),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 20, // Số lượng dữ liệu bảng xếp hạng
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()), // Hiển thị số hạng
                ),
                title: Text('User ${index + 1}'), // Tên người dùng
                trailing: const Text('100 points'), // Điểm số
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLearningOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi người dùng chọn cách học
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200), // Giới hạn chiều rộng
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.kPrimaryLightColor,
          child: InkWell(
            onTap: () {
              // Xử lý khi người dùng nhấn vào nút
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.kPrimaryColor,
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      overflow:
                          TextOverflow.ellipsis, // Hiển thị dấu ... khi quá dài
                      maxLines: 3, // Giới hạn số dòng
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

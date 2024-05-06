import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/ui/communityPage/topic_sreen.dart'; // Nếu cần import Word

// Mô hình Topic
class Topic {
  final String id;
  String title;
  final int creationTime;
  int numberOfChildren;
  int learnedWords;
  int view;
  List<Word> words;
  bool isSaved; // Thêm trạng thái lưu topic

  Topic({
    required this.id,
    required this.title,
    required this.creationTime,
    required this.numberOfChildren,
    required this.learnedWords,
    required this.view,
    required this.words,
    this.isSaved = false, // Mặc định là chưa được lưu
  });

  Topic copyWith({
    String? id,
    String? title,
    int? creationTime,
    int? numberOfChildren,
    int? learnedWords,
    int? view,
    bool? isSaved,
  }) {
    return Topic(
      words: words,
      id: id ?? this.id,
      title: title ?? this.title,
      creationTime: creationTime ?? this.creationTime,
      numberOfChildren: numberOfChildren ?? this.numberOfChildren,
      learnedWords: learnedWords ?? this.learnedWords,
      view: view ?? this.view,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late TextEditingController _searchController;
  List<Topic> _topics = List.generate(
    20,
    (index) => Topic(
      id: 'topic$index',
      title: 'Topic $index',
      creationTime: DateTime.now().millisecondsSinceEpoch,
      numberOfChildren: 0,
      learnedWords: 0,
      view: 0,
      words: [], // Tạo danh sách rỗng ban đầu
    ),
  );

  List<Topic> _savedTopics = []; // Danh sách topic đã lưu

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Khởi tạo trạng thái lưu cho mỗi topic
    _topics.forEach((topic) {
      topic.isSaved = false; // Mặc định chưa lưu
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSaved(Topic topic) {
    setState(() {
      final savedIndex =
          _savedTopics.indexWhere((savedTopic) => savedTopic.id == topic.id);
      if (savedIndex != -1) {
        _savedTopics.removeAt(savedIndex);
      } else {
        _savedTopics.add(topic);
      }
      topic.isSaved = !topic.isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Others'), // Tab Others
                  Tab(text: 'Your Bag'), // Tab Your Bag
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    // TabView cho Others
                    ListView.builder(
                      itemCount: _topics.length,
                      itemBuilder: (context, index) {
                        final topic = _topics[index];
                        return Card(
                          child: ListTile(
                            title: Text(topic.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_circle),
                                    SizedBox(width: 8),
                                    Text('Creator Name'),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.book),
                                    SizedBox(width: 8),
                                    Text('${topic.words.length} words'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                _toggleSaved(topic);
                              },
                              child: topic.isSaved
                                  ? Icon(Icons.favorite,
                                      color:
                                          Colors.red) // Trái tim đỏ nếu đã lưu
                                  : Icon(Icons.favorite_border),
                            ),
                            onTap: () {
                              // Xử lý khi người dùng nhấn vào một topic
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TopicDetailScreen(
                                      topicTitle: topic.title),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    // TabView cho Your Bag
                    _savedTopics.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/empty_bag.svg', // Đường dẫn tới file SVG
                                  width: 200,
                                  // height: 100,
                                ),
                                SizedBox(height: 16),
                                Text('Bag empty now', style: AppTheme.caption),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _savedTopics.length,
                            itemBuilder: (context, index) {
                              final topic = _savedTopics[index];
                              return Card(
                                child: ListTile(
                                  title: Text(topic.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.account_circle),
                                          SizedBox(width: 8),
                                          Text('Creator Name'),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.book),
                                          SizedBox(width: 8),
                                          Text('${topic.words.length} words'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _toggleSaved(topic);
                                    },
                                    child: Icon(Icons.favorite,
                                        color: Colors
                                            .red), // Trái tim đỏ vì đã lưu
                                  ),
                                  onTap: () {
                                    // Xử lý khi người dùng nhấn vào một topic
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TopicDetailScreen(
                                            topicTitle: topic.title),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

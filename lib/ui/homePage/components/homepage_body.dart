// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orange_card/ui/auth/constants.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Study With Random Topic",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              listMenu(),
              const Text(
                "Recommended For You",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              topics(),
              const Text(
                "Every Day A New Word",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              newWord(),
              const Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  ranks(),
                  myRanks(),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container ranks() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 350,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20.0),
            //   border: Border.all(color: Colors.black, width: 2.0), // Đổi màu và độ dày viền tùy ý
            // ),
            child: ClipRRect(
              child: SvgPicture.asset(
                "./assets/icons/leaderboard_box.svg",
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Các widget sẽ căn giữa và đều nhau
            crossAxisAlignment:
                CrossAxisAlignment.start, // Canh chỉnh theo chiều dọc
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Canh chỉnh theo chiều dọc
                  children: [
                    const SizedBox(height: 30), // Điều chỉnh khoảng cách top
                    _buildAvatarCircle(
                        "User 1", "https://via.placeholder.com/150"),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Canh chỉnh theo chiều dọc
                  children: [
                    _buildAvatarCircle(
                        "User 2", "https://via.placeholder.com/150"),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Canh chỉnh theo chiều dọc
                  children: [
                    const SizedBox(height: 60), // Điều chỉnh khoảng cách top
                    _buildAvatarCircle(
                        "User 3", "https://via.placeholder.com/150"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40, // Đường kính hình tròn
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget myRanks() {
    return Column(
      children: [
        _buildRankCard("User 1", "https://via.placeholder.com/150", 4),
        const SizedBox(height: 10), // Khoảng cách giữa các card
        _buildRankCard("User 2", "https://via.placeholder.com/150", 5),
        const SizedBox(height: 10),
        _buildRankCard("User 3", "https://via.placeholder.com/150", 6),
        const SizedBox(height: 10),
        _buildRankCard("You", "https://via.placeholder.com/150", 100),
      ],
    );
  }

  Widget _buildRankCard(String name, String imageUrl, int rank) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        // side: BorderSide(color: Colors.transparent, width: 0), // Border đen rõ
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 74, 56, 40), // Nền đen
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Màu shadow
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // Di chuyển shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.white), // Chữ trắng
            ),
            const Spacer(), // Đẩy về cuối container
            Container(
              width: double.infinity, // Đảm bảo vòng tròn lấp đầy width
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container newWord() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 123, 123, 123),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 251, 104, 64),
                      child: Icon(
                        Icons.edit_note,
                      ),
                    ),
                    title: const Text(
                      "Book",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text("Sách"),
                  ),
                  Positioned(
                    top: 8,
                    bottom: 8,
                    right: 8,
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý khi nhấn nút "New Word"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Màu nền của nút
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Kích thước của Row phụ thuộc vào nội dung
                          children: [
                            Text(
                              'New Word',
                              style: TextStyle(fontSize: 12),
                            ),
                            Icon(Icons.arrow_forward, size: 12), // Icon mũi tên
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container topics() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: const DecorationImage(
                        image: AssetImage("./assets/images/backgroundCard.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Stack(
                      children: [
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Text(
                            "Topic Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '10 thuật ngữ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "creator",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  Container listMenu() {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.analytics,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Flashcard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.purpleAccent,
                  child: Icon(
                    Icons.quiz,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Quiz",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Typing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

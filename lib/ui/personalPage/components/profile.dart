import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:orange_card/ui/auth/Screens/Login/login_screen.dart';
import 'package:orange_card/ui/auth/Screens/ResetPassword/reset_password.dart';
import 'package:orange_card/ui/message/sucess_message.dart';
import 'package:orange_card/ui/personalPage/components/change_password.dart';
import 'package:date_format/date_format.dart';
import 'package:orange_card/constants/constants.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:typed_data';
import 'package:orange_card/resources/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late String _displayName;
  late String _preDisplayName;
  late String _email;
  late String _avatarUrl; // Thêm biến để lưu URL ảnh đại diện
  late bool _isLoading = false;
  late DateTime _creationTime = DateTime.now();
  late TabController _tabController;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  bool _isNotificationOn = false;
  late TimeOfDay _savedTime;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsFlutterBinding.ensureInitialized();
    setAndLoadSharedPreferences();
  }

  void setAndLoadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // Sau khi SharedPreferences được khởi tạo, ta cập nhật trạng thái
    setState(() {
      _isNotificationOn = _prefs!.getBool('notification_on') ?? false;
    });
    if (_isNotificationOn) {
      final int? savedHour = _prefs!.getInt('notification_hour');
      final int? savedMinute = _prefs!.getInt('notification_minute');
      _savedTime = TimeOfDay(hour: savedHour ?? 0, minute: savedMinute ?? 0);

      await _setScheduleNotification(_savedTime);
    }
  }

  Future<void> _saveNotificationStatus(bool status, TimeOfDay saveTime) async {
    if (_prefs != null) {
      await _prefs!.setBool('notification_on', status);
      await _prefs!.setInt('notification_hour', saveTime.hour);
      await _prefs!.setInt('notification_minute', saveTime.minute);
    } else {
      // Xử lý khi _prefs là null
      // Có thể hiển thị thông báo lỗi hoặc thực hiện hành động thích hợp
    }
  }

  Future<bool> _setScheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();
    final scheduleDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    try {
      await NotificationService.showScheduleNotification(
        title: "HEY BUDDY",
        body: "Let's start learning new vocabulary",
        payload: 'payload',
        scheduleDate: scheduleDate,
      );
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> _onSetNotification(bool isTurnOn, BuildContext context) async {
    if (isTurnOn) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        final result = await _setScheduleNotification(pickedTime);

        if (result) {
          _saveNotificationStatus(true, pickedTime);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification set successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          _isNotificationOn =
              false; // Cập nhật _isNotificationOn thành false ở đây
          _saveNotificationStatus(false, TimeOfDay.now());
          NotificationService.cancelNotification(id: 0);
        }
      } else {
        setState(() {
          _isNotificationOn =
              false; // Cập nhật _isNotificationOn thành false ở đây
        });
        _saveNotificationStatus(false, TimeOfDay.now());
        await NotificationService.cancelNotification();
      }
    } else {
      setState(() {
        _isNotificationOn =
            false; // Cập nhật _isNotificationOn thành false ở đây
      });
      _saveNotificationStatus(false, TimeOfDay.now());
      await NotificationService.cancelNotification();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    final user = _auth.currentUser;
    // print(user);
    _displayName = user?.displayName ?? '';
    _preDisplayName = _displayName;
    _email = user?.email ?? '';
    _avatarUrl = '';
    _creationTime = user?.metadata.creationTime ?? DateTime.now();

    try {
      final avatarFolder = _storage.ref('avatars');
      final imageUrl =
          await avatarFolder.child(user?.uid ?? '').getDownloadURL();
      setState(() {
        _avatarUrl = imageUrl; // Cập nhật URL ảnh đại diện
      });
    } catch (e) {
      print('Error initializing avatar URL: $e');
      setState(() {
        _avatarUrl = ''; // Xử lý khi không có URL ảnh đại diện
      });
    }
  }

  Future<void> _updateDisplayName() async {
    try {
      final user = _auth.currentUser;

      // Tạo một document mới nếu chưa tồn tại
      final docRef = _firestore.collection('users').doc(user?.uid);
      if (!(await docRef.get()).exists) {
        await docRef.set({'displayName': ''});
      }

      final confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận'),
            content: Text('Bạn có muốn đổi tên của mình?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Update'),
              ),
            ],
          );
        },
      );

      if (confirm != null && confirm) {
        // Hiển thị tiến trình hoạt động
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        await user?.updateDisplayName(_displayName);
        await docRef.update({'displayName': _displayName});
        _preDisplayName = _displayName;

        // Cập nhật trạng thái của widget để hiển thị icon đúng trạng thái
        setState(() {});

        // Ẩn tiến trình hoạt động
        Navigator.of(context).pop();

        // Hiển thị thông báo thành công
        MessageUtils.showSuccessMessage(
            context, "Display name updated successfully");
      }
    } catch (e) {
      // Ẩn tiến trình hoạt động (nếu có)
      Navigator.of(context).pop();

      // Hiển thị thông báo thất bại
      MessageUtils.showFailureMessage(context, "Failed to update display name");
    }
  }

  Future<void> _updateAvatar() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final user = _auth.currentUser;

      setState(() {
        _isLoading = true; // Bắt đầu hiển thị tiến trình hoạt động
      });

      try {
        // Tạo thư mục 'avatars' nếu chưa tồn tại
        final avatarFolder = _storage.ref('avatars');
        await avatarFolder.child(user?.uid ?? '').putFile(file);

        final imageUrl =
            await avatarFolder.child(user?.uid ?? '').getDownloadURL();

        setState(() {
          _avatarUrl = imageUrl; // Cập nhật URL ảnh đại diện mới
          _isLoading = false; // Ẩn tiến trình hoạt động khi upload hoàn tất
        });

        await _firestore
            .collection('users')
            .doc(user?.uid)
            .update({'avatarUrl': imageUrl});

        MessageUtils.showSuccessMessage(context, "Avatar updated successfully");
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          _isLoading = false; // Ẩn tiến trình hoạt động khi có lỗi
        });
        MessageUtils.showFailureMessage(context, "Failed to update avatar");
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      MessageUtils.showFailureMessage(context, "Failed to logout");
    }
  }

  Future<void> _confirmLogout() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Không đóng dialog khi nhấn bên ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).maybePop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _logout(); // Thực hiện hành động logout
                Navigator.of(context).maybePop(); // Đóng dialog
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  String formatCreationTime(DateTime creationTime) {
    final formattedTime = formatDate(creationTime, [dd, '-', mm, '-', yyyy]);
    return formattedTime;
  }

  void _confirmDeleteAccount() {
    String enteredName = ''; // Tên mà người dùng nhập

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please enter your name in the following box to delete"),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter $_displayName to delete',
                ),
                onChanged: (value) {
                  enteredName = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Kiểm tra nếu tên nhập vào khớp với _displayName thì mới thực hiện xóa tài khoản
                if (enteredName == _displayName) {
                  Navigator.of(context).pop(); // Ẩn dialog nhập tên
                  _deleteAccount();
                } else {
                  // Hiển thị thông báo lỗi
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Invalid name. Please enter your name correctly.'),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Xóa ảnh đại diện từ Firebase Storage
        if (_avatarUrl.isNotEmpty) {
          final defaultAvatarPath = "assets/images/default_avatar.jpg";
          if (_avatarUrl != defaultAvatarPath) {
            // Trích xuất tên file từ URL
            final fileName = _avatarUrl.split('/').last;

            // Tham chiếu đến file trong thư mục 'avatars'
            final firebase_storage.Reference avatarRef =
                _storage.ref('avatars').child(user.uid).child(fileName);

            // Xóa file từ Firebase Storage
            await avatarRef.delete();
          }
        }

        // Xóa tài khoản người dùng từ Firebase Authentication
        await user.delete();

        // Xóa tài khoản người dùng từ Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Hiển thị thông báo thành công và chuyển về màn hình đăng nhập
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Your account has been deleted."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ẩn dialog thông báo
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error deleting account: $e");
        // Hiển thị thông báo lỗi nếu xảy ra lỗi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content:
                  Text("Failed to delete account. Please try again later."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      print("Current user is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (!_isLoading) {
                    _updateAvatar();
                  }
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatarUrl.isNotEmpty
                          ? Image.network(_avatarUrl).image
                          : AssetImage(
                              "assets/images/default_avatar.jpg",
                            ),
                    ),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText:
                            _displayName.isEmpty ? 'Display Name' : 'Your Name',
                        suffixIcon: IconButton(
                          icon: _displayName != _preDisplayName
                              ? const Icon(Icons.update, color: Colors.green)
                              : const Icon(Icons.check, color: Colors.green),
                          onPressed: _displayName.isNotEmpty &&
                                  _displayName != _preDisplayName
                              ? _updateDisplayName
                              : null,
                        ),
                      ),
                      initialValue:
                          _displayName.isNotEmpty ? _displayName : null,
                      onChanged: (value) {
                        setState(() {
                          _displayName = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // TabBar for profile sections
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: kPrimaryColor,
                tabs: const [
                  Tab(text: 'Informations'),
                  Tab(text: 'Settings'),
                  Tab(text: 'Achievements'),
                ],
              ),
            ],
          ),
        ),

        // TabBarView to display corresponding content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Thông tin tab
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(Icons.mail), // Icon label text
                          const SizedBox(
                            width: 8.0,
                          ), // Khoảng cách giữa icon và nội dung email
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                  ), // Border dưới cho email
                                ),
                              ),
                              child: TextFormField(
                                readOnly: true,
                                initialValue:
                                    _email, // Giá trị ban đầu của email
                                decoration: InputDecoration(
                                  labelText:
                                      'Email', // Label text cho TextFormField
                                  filled: false, // Không sử dụng màu nền
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today), // Icon label text
                          const SizedBox(
                            width: 8.0,
                          ), // Khoảng cách giữa icon và nội dung email
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              child: TextFormField(
                                readOnly: true,
                                initialValue:
                                    formatCreationTime(_creationTime), // data
                                decoration: InputDecoration(
                                  labelText:
                                      'Creation time', // Label text cho TextFormField
                                  filled: false, // Không sử dụng màu nền
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Cài đặt tab
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileItem(
                        title: 'Forget Password',
                        icon: Icons.lock,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ),
                        ),
                      ),
                      ProfileItem(
                        title: 'Change Password',
                        icon: Icons.lock_open,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangePasswordDialog();
                            },
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Turn on Notification'),
                        leading: Icon(Icons.notifications),
                        subtitle: _isNotificationOn
                            ? Text(
                                'Remind at: ${_savedTime.format(context)}') // Hiển thị giá trị thời gian nhắc nhở khi _isNotificationOn là true
                            : null, // Không hiển thị subtitle khi _isNotificationOn là false
                        trailing: Switch(
                          value: _isNotificationOn,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _isNotificationOn = value;
                              _onSetNotification(_isNotificationOn, context);
                            });
                          },
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Danger Zone',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        height: 2.0,
                        color:
                            Colors.red, // Màu sắc của ranh giới "danger zone"
                      ),
                      ProfileItem(
                        title: 'Logout',
                        icon: Icons.logout,
                        onPressed: _confirmLogout,
                      ),
                      ProfileItem(
                        title: 'Delete Account',
                        icon: Icons.delete,
                        onPressed: _confirmDeleteAccount,
                      ),
                    ],
                  ),
                ),
              ),

              // Thành tựu tab
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thành tựu',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 24),
                        _buildAchievementCard(
                          title: 'Personal achievements',
                          content: [
                            'Flutter: 15 / 30 topics',
                            'Firebase: 10 / 25 topics',
                            'Dart: 20 / 40 topics',
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildAchievementCard(
                          title: 'Community Achievements',
                          content: [
                            'Rank tổng thể: Top 10%',
                            'Flutter: #3',
                            'Firebase: #5',
                            'Dart: #1',
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildAchievementCard(
    {required String title, required List<String> content}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.grey[300], thickness: 1, height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((item) => Text(item)).toList(),
          ),
        ],
      ),
    ),
  );
}

class ProfileItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  const ProfileItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onPressed,
    );
  }
}

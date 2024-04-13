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
// import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:typed_data';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _displayName;
  late String _preDisplayName;
  late String _email;
  late String _avatarUrl; // Thêm biến để lưu URL ảnh đại diện
  late bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final user = _auth.currentUser;
    _displayName = user?.displayName ?? '';
    _preDisplayName = _displayName;
    _email = user?.email ?? '';
    _avatarUrl = '';

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

  // Future<void> _changePassword() async {
  //   // Hiển thị dialog nhập mật khẩu
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       String oldPassword = '';
  //       String newPassword = '';
  //       String confirmPassword = '';

  //       return AlertDialog(
  //         title: Text('Change Password'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 labelText: 'Old Password',
  //                 filled: true,
  //                 fillColor: Colors.white54,
  //               ),
  //               onChanged: (value) {
  //                 oldPassword = value;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             TextField(
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 labelText: 'New Password',
  //                 filled: true,
  //                 fillColor: Colors.white54,
  //               ),
  //               onChanged: (value) {
  //                 newPassword = value;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             TextField(
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 labelText: 'Confirm New Password',
  //                 filled: true,
  //                 fillColor: Colors.white54,
  //               ),
  //               onChanged: (value) {
  //                 confirmPassword = value;
  //               },
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               if (newPassword != confirmPassword) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('New passwords do not match'),
  //                     backgroundColor: Colors.red,
  //                   ),
  //                 );
  //                 return;
  //               }

  //               try {
  //                 final user = FirebaseAuth.instance.currentUser;
  //                 if (user != null) {
  //                   // Reauthenticate user before changing password
  //                   AuthCredential credential = EmailAuthProvider.credential(
  //                       email: user.email!, password: oldPassword);
  //                   await user.reauthenticateWithCredential(credential);

  //                   // Change password
  //                   await user.updatePassword(newPassword);
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text('Password changed successfully'),
  //                       backgroundColor: Colors.green,
  //                     ),
  //                   );
  //                   Navigator.of(context)
  //                       .pop(); // Đóng dialog sau khi thay đổi mật khẩu
  //                 }
  //               } catch (e) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text('Failed to change password: $e'),
  //                     backgroundColor: Colors.red,
  //                   ),
  //                 );
  //               }
  //             },
  //             child: Text('Change Password'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        ), // Ảnh mặc định khi không có ảnh đại diện
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
                  initialValue: _displayName.isNotEmpty ? _displayName : null,
                  onChanged: (value) {
                    setState(() {
                      _displayName = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),
          Text(
            _email,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            title: 'Forget Password',
            icon: Icons.lock,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassword())),
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

          ProfileItem(
            title: 'Achievement',
            icon: Icons.star,
            onPressed: () {
              // Do something for achievement
            },
          ),
          ProfileItem(
            title: 'Settings',
            icon: Icons.settings,
            onPressed: () {
              // Do something for settings
            },
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            title: 'Logout',
            icon: Icons.logout,
            onPressed: _logout,
          ),
          // Thêm các mục hồ sơ khác ở đây (thành tựu, nâng cấp, vv.)
        ],
      ),
    );
  }
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

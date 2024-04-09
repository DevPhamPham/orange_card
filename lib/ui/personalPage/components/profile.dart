import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:orange_card/ui/auth/Screens/Login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _displayName;
  late String _email;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _displayName = user?.displayName ?? '';
    _email = user?.email ?? '';
  }

  Future<void> _updateDisplayName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(_displayName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update display name')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)..pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout')),
      );
    }
  }

  Future<void> _updateAvatar() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final String fileName = 'avatar.jpg';
      final file = File(pickedFile.path);
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('avatars/$fileName')
            .putFile(file);
        // Xử lý khi upload thành công
      } catch (e) {
        // Xử lý khi có lỗi xảy ra
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _updateAvatar,
            child: CircleAvatar(
              radius: 50,
              // Hiển thị ảnh đại diện hiện tại của người dùng ở đây
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: _updateDisplayName,
                    ),
                  ),
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
            title: 'Change Password',
            icon: Icons.lock,
            onPressed: () {
              // Chuyển đến màn hình đổi mật khẩu
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

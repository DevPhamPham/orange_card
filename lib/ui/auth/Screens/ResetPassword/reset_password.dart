import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailTextController = TextEditingController();

    void _resetPassword() {
      String email = _emailTextController.text.trim();
      FirebaseAuth.instance.sendPasswordResetEmail(email: email)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Password reset email sent to $email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green, // Màu nền
              behavior: SnackBarBehavior.floating, // Hiển thị SnackBar ở dạng floating
            ),
          );
          Navigator.pop(context); // Quay lại trang trước đó
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to send password reset email: $error',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red, // Màu nền
              behavior: SnackBarBehavior.floating, // Hiển thị SnackBar ở dạng floating
            ),
          );
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Quay lại trang trước đó
              },
              child: Text(
                'Back',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String email;
  UpdatePasswordPage({required this.email});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    email = widget.email; // Assign the passed email to the variable
  }

  String email = '';
  

  void updatePassword() {
    if (passwordController.text == confirmPasswordController.text) {
      print(email); // This is the email of the user
      // You would typically send the new password to your backend for updating.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password Updated')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Email: $email'),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: updatePassword,
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}

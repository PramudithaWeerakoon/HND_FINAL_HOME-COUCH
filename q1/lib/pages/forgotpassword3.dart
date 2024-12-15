import 'package:flutter/material.dart';
import 'db_connection.dart';
import 'login_page.dart';

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

  late String email;
  final DatabaseConnection dbConnection = DatabaseConnection();

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  // Regex to validate password
  final String passwordRegex =
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$';

  void updatePasswordInDatabase(String email, String newPassword) async {
    try {
      await dbConnection.updatePasswordInDatabase(email, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // Navigate to Q8Screen
        ),
      ); // Navigate back after updating
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: $e')),
      );
    }
  }

  void updatePassword() {
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!RegExp(passwordRegex).hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password must include a capital letter, a number, a special character, and be at least 6 characters long',
          ),
        ),
      );
      return;
    }

    updatePasswordInDatabase(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: updatePassword,
                child: Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

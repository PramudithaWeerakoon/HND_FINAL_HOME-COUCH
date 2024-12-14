import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'send_email.dart'; // Import the email service
import 'fogotpassword2.dart';
import 'forgotpassword3.dart';

class EnterEmailPage extends StatefulWidget {
  @override
  _EnterEmailPageState createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  final TextEditingController emailController = TextEditingController();

  void sendOTP() {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      // Generate 6-digit OTP
      String otp = generateOTP();

      // Call the email service to send OTP to the user
      sendEmailOTP(email, otp);

      // Navigate to the OTP entry page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterOTPPage(
            email: email,
            otp: otp,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  String generateOTP() {
    final rand = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += rand.nextInt(10).toString();
    }
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: sendOTP,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

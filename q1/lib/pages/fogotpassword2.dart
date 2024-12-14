import 'package:flutter/material.dart';
import 'forgotpassword3.dart'; // Import the UpdatePasswordPage

class EnterOTPPage extends StatefulWidget {
  final String email;
  final String otp;
  EnterOTPPage({required this.email, required this.otp});

  @override
  _EnterOTPPageState createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  final TextEditingController otpController = TextEditingController();

  void validateOTP() {
    if (otpController.text == widget.otp) {
      // OTP is correct, navigate to the update password page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdatePasswordPage(email: widget.email)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            ElevatedButton(
              onPressed: validateOTP,
              child: Text('Validate OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

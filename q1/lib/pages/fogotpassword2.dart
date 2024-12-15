import 'package:flutter/material.dart';
import 'forgotpassword3.dart'; // Import the UpdatePasswordPage

class EnterOTPPage extends StatefulWidget {
  final String email;
  final String otp;

  const EnterOTPPage({super.key, required this.email, required this.otp});

  @override
  _EnterOTPPageState createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  void validateOTP() {
    String enteredOTP = otpController.text.trim();

    if (enteredOTP.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    if (enteredOTP == widget.otp) {
      setState(() {
        isLoading = true;
      });

      // Simulate a short delay for user experience
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });

        // Navigate to the update password page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePasswordPage(email: widget.email),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'A verification code has been sent to ${widget.email}',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            SizedBox(height: 20.0),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: validateOTP,
                    child: Text('Validate OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';
import 'send_email.dart'; // Import the email service
import 'fogotpassword2.dart';
import 'login_page.dart';

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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(
                      'lib/assets/logo.png', 
                      height: 60,
                    ),
                    SizedBox(height: 16),

                    // Title
                    Text(
                      'Forgot Your Password?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Enter your email address and we will send you instructions to reset your password.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    // Email Input Field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendOTP,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor:  const Color(0xFF21007E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Back to Platform
                    TextButton(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage(), // Navigate to Q8Screen
                          ),
                        );
                      },
                      child: Text(
                        'Back to the Login Page',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

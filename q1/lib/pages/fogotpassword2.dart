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
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  bool isLoading = false;

  void validateOTP() {
    String enteredOTP =
        controllers.map((controller) => controller.text).join().trim();

    if (enteredOTP.isEmpty || enteredOTP.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the complete 6-digit OTP')),
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

  Widget buildOTPBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 45,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60),
            Text(
              'Get Your Code',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF21007E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Please enter the 6-digit code sent to your email address',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            buildOTPBoxes(),
            SizedBox(height: 20.0),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: validateOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21007E),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  'Verify and Proceed',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('OTP Resent! Please check your email.')),
                );
              },
              child: Text(
                'Resend Code',
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

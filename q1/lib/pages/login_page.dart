import 'package:q1/components/login/auth_button.dart';
import 'package:q1/components/login/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 85),

              const Text(
                'Coach@Home',
                style: TextStyle(
                  color: Color(0xFF21007E), // Replace with your desired color code
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 45),

              // Welcome back text
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.black, // Replace with your desired color code
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Sign in text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Email text field
              MyTextField(
                controller: usernameController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // Password text field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              // Remember me and Forgot Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Color.fromARGB(255, 128, 127, 127),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 128, 127, 127), // Change to desired color
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Add other widgets here
              GestureDetector(
                onTap: () {
                  // Navigate to /question1 route
                  Navigator.pushNamed(context, '/question1');
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  decoration: BoxDecoration(
                    color: const Color(0xFF21007E), // Add your desired background color
                    borderRadius: BorderRadius.circular(50), // Add border radius if needed
                  ),
                  child: const Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Or text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0), // Adjust the padding as needed
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(color: Color.fromARGB(255, 77, 76, 76)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),  

              const SizedBox(height: 16),
            

              // third party login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthButton(imagePath: 'lib/assets/google.png'), // Google icon
                  SizedBox(width: 20),
                  const AuthButton(imagePath: 'lib/assets/apple.png'), // Apple icon
                  SizedBox(width: 20),
                  const AuthButton(imagePath: 'lib/assets/microsoft.png'), // Microsoft icon
                ],
              ),

              //signup redirect button
              const SizedBox(height: 170),
              TextButton(
                onPressed: null, // No need for onPressed
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 128, 127, 127), // Grey color
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                          color: Color(0xFF21007E), // Blue color
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:q1/components/login/auth_button.dart';
import 'package:q1/components/login/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must be at least 8 characters, include uppercase, lowercase, a number, and a special character';
  }
  return null;
}

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'lib/assets/logo.png',
                  width: 300, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
                const SizedBox(height: 30),
                const Text(
                  'Let\'s Begin The Journey!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Name field
                MyTextField(
                  controller: usernameController,
                  hintText: 'Name',
                  obscureText: false,
                  validator: _validateName,
                ),
                const SizedBox(height: 10),

                // Email field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 10),

                // Password field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 10),

                // Confirm Password field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),

                // Remember me checkbox
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
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
                ),
                const SizedBox(height: 5),

                // Sign up button with form validation check
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.pushNamed(context, '/question1');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21007E),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign up',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
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

                // Third-party login buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthButton(imagePath: 'lib/assets/google.png'),
                    SizedBox(width: 20),
                    AuthButton(imagePath: 'lib/assets/apple.png'),
                    SizedBox(width: 20),
                    AuthButton(imagePath: 'lib/assets/microsoft.png'),
                  ],
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 128, 127, 127),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Sign in",
                          style: const TextStyle(
                            color: Color(0xFF21007E),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/login');
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
      ),
    );
  }
}

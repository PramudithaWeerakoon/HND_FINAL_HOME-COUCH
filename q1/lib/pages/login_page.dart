import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Validation function for email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validation function for password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Login function
  Future<void> _loginUser() async {
    final dbHelper = DatabaseHelper();
    bool loginSuccess = await dbHelper.loginUser(
      usernameController.text,
      passwordController.text,
    );

    if (loginSuccess) {
      Navigator.pushNamed(context, '/question1'); // Navigate on successful login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'lib/assets/logo.png',
                      width: 300,
                      height: 100,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome back!',
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

                    // Email text field with validation
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 10),

                    // Password text field with validation
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: _validatePassword,
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
                              color: Color.fromARGB(255, 128, 127, 127),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Sign in button with form validation check
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _loginUser(); // Attempt login with database
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
                              style: TextStyle(
                                  color: Color.fromARGB(255, 77, 76, 76)),
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
                    const SizedBox(height: 170),
                    TextButton(
                      onPressed: null,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 128, 127, 127),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: const TextStyle(
                                color: Color(0xFF21007E),
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
          ),
        ),
      ),
    );
  }
}

// Custom text field widget
class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_isPasswordVisible,
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          hintText: widget.hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String imagePath;

  const AuthButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 29,
          height: 29,
        ),
      ),
    );
  }
}

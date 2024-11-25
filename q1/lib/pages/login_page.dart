import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'db_connection.dart'; // Import the database connection

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
  bool isLoading = false; // Track loading state

  final DatabaseConnection _databaseConnection = DatabaseConnection();

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

  // Attempt login with database
  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Show loading spinner
      });

      String email = usernameController.text;
      String password = passwordController.text;

      bool isLoggedIn = await _databaseConnection.loginUser(email, password);

      setState(() {
        isLoading = false; // Hide loading spinner
      });

      if (isLoggedIn) {
        // Navigate to the home screen or authenticated area
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
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
                      onTap: _handleLogin, // Call the login handler
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.symmetric(horizontal: 35),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21007E),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // Show loading spinner when logging in
                              : const Text(
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
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF21007E), width: 2.0),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 128, 127, 127),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF21007E),
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
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20,
      child: Image.asset(imagePath),
    );
  }
}

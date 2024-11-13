import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'database_helper.dart'; // Import the DatabaseHelper file

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
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
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

  // Save user data to database
  Future<void> registerUser() async {
    final dbHelper = DatabaseHelper();
    final user = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    try {
      await dbHelper.registerUser(
          emailController.text, passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushNamed(context, '/question1'); // Navigate to next page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Image.asset(
                        'lib/assets/logo.png',
                        width: constraints.maxWidth * 0.75,
                        height: constraints.maxHeight * 0.15,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      const Text(
                        'Let\'s Begin The Journey!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.025),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.015),

                      // Name field
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Name',
                        obscureText: false,
                        validator: _validateName,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.01),

                      // Email field
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.01),

                      // Password field
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.01),

                      // Confirm Password field
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        validator: _validateConfirmPassword,
                      ),

                      // Remember me checkbox
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
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
                      SizedBox(height: constraints.maxHeight * 0.005),

                      // Sign up button
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            registerUser(); // Register the user on successful validation
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
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
                      SizedBox(height: constraints.maxHeight * 0.015),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.2),
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
                      SizedBox(height: constraints.maxHeight * 0.016),

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
                      SizedBox(height: constraints.maxHeight * 0.05),
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
            );
          },
        ),
      ),
    );
  }
}

// MyTextField widget
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
  final FocusNode _focusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_isPasswordVisible,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Color(0xFF21007E), width: 2.0),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: _focusNode.hasFocus ? Colors.grey[600] : Colors.grey[400],
          ),
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

// AuthButton widget
class AuthButton extends StatelessWidget {
  final String imagePath;

  const AuthButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
    );
  }
}

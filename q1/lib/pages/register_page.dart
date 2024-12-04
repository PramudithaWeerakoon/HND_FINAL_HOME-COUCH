import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'db_connection.dart'; // Make sure this import is correct
import 'q1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool rememberMe = false;

  final DatabaseConnection _databaseConnection = DatabaseConnection();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }
  

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Retrieve the form values
      final name = usernameController.text;
      final email = emailController.text;
      final password = passwordController.text;

      try {
        // Insert the user into the database
        await _databaseConnection.insertUser(name, email, password);

        // Show success message and navigate to the next screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Navigate to the next screen
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Q1Page()));
      } catch (e) {
        // Handle any errors (e.g., if the email is already in use)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String? loggedinAuthUserEmail;
  String? loggedinAuthUserName;

 Future<void> handleGooglein(BuildContext context) async {
    try {
      print('Starting Google sign-in...');
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn
          .signOut(); // Ensure the user is signed out before signing in again
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('User canceled the sign-in.');
        return;
      }

      print('Google user signed in: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Access token: ${googleAuth.accessToken}');
      print('ID token: ${googleAuth.idToken}');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        print('Firebase user logged in: ${user.email}');
        loggedinAuthUserEmail = user.email!;
        loggedinAuthUserName = user.displayName!;

        // Check if the user already exists in the database
        final userExists =
            await _databaseConnection.userExists(loggedinAuthUserEmail!);

        if (userExists) {
          // Email already exists; show a message to the user
          print('Email is already registered. Please log in.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'The email ${loggedinAuthUserEmail!} is already registered. Please log in.'),
            ),
          );
          return; // Do not proceed further
        } else {
          // Insert new user into the database
          await _databaseConnection.insertUser(
            loggedinAuthUserName!,
            loggedinAuthUserEmail!,
            'GoogleUser', // Use a placeholder for password
          );
          print('New user added to the database.');
        }

        // Insert or update AuthProvider details in the database
        await _databaseConnection.insertOrUpdateAuthProvider(
          'Google', // Authentication provider type
          loggedinAuthUserEmail!,
          googleAuth.accessToken,
          googleAuth.idToken,
          'https://oauth2.googleapis.com/token', // Example URL
          DateTime.now()
              .add(Duration(hours: 1))
              .toIso8601String(), // Example expiry
        );

        // Navigate to the first question screen for new users
        if (user.metadata.creationTime == user.metadata.lastSignInTime) {
          Navigator.pushReplacementNamed(context, '/question1');
        }
      } else {
        print('Firebase user information not available.');
      }
    } catch (error) {
      print('Error during Google sign-in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'lib/assets/logo.png',
                    width: 300,
                    height: 100,
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

                  // Sign up button
                  GestureDetector(
                    onTap: _registerUser, // Call _registerUser on tap
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

                  // Third-party login buttons
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                      onTap: () {
                        handleGooglein(context);
                      },
                      child: const AuthButton(imagePath: 'lib/assets/google.png'),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                      onTap: () {
                        // Handle Apple sign-in
                      },
                      child: const AuthButton(imagePath: 'lib/assets/apple.png'),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                      onTap: () {
                        // Handle Microsoft sign-in
                      },
                      child: const AuthButton(imagePath: 'lib/assets/microsoft.png'),
                      ),
                    ],
                    ),
                  const SizedBox(height: 20),
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

import 'package:flutter/material.dart';
import 'package:q1/pages/q1.dart';
import 'package:q1/pages/q2.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/question1': (context) => const Q1Page(),
        '/question2': (context) => const Q2Page(),

      },
    );
  }
}

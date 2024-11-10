import 'package:flutter/material.dart';
import 'package:q1/pages/q1.dart';
import 'package:q1/pages/q2.dart';
import 'package:q1/pages/Home.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/q19.dart';
import 'pages/mealoptions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/question1': (context) => const Q1Page(),
        '/question2': (context) => const Q2Page(),
        '/home': (context) => const HomePage(),
        '/q19': (context) => CustomizedPlanScreen(),
        '/q20': (context) => MealPlanScreen(),

      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:q1/pages/q1.dart';
import 'package:q1/pages/q2.dart';
import 'package:q1/pages/Home.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/instructionPage.dart';
import 'pages/settings.dart';
import 'pages/q19.dart';
import 'pages/mealoptions.dart';
import 'pages/goals.dart';
import 'pages/mealplan.dart';
import 'pages/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/instruction',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/question1': (context) => const Q1Page(),
        '/question2': (context) => const Q2Page(),
        '/home': (context) => const HomePage(),
        '/instruction': (context) => const InstructionPage(),
        '/settings': (context) => const SettingsPage(),
        '/goals': (context) => const FitnessHomePage(),
        '/q19': (context) => const CustomizedPlanScreen(),
        '/q20': (context) => const MealPlanScreen(),
        '/meals': (context) => const DailyMealPlan(),
        '/loading': (context) => const LoadingScreen(),
      },
    );
  }
}

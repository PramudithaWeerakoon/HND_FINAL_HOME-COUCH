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
import 'pages/mealplan.dart';
import 'pages/goals.dart';
import 'pages/loading.dart';
import 'pages/fitnessgoal.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/fitnessgoal',

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/question1': (context) => Q1Page(userEmail: 'example@example.com'),
        '/question2': (context) => Q2Page(currentUserEmail: 'example@example.com'),
        '/home': (context) => const HomePage(),
        '/instruction': (context) => const InstructionPage(),
        '/settings': (context) => const SettingsPage(),
        '/goals': (context) =>  FitnessHomePage(),
        '/q19': (context) => CustomizedPlanScreen(),
        '/q20': (context) => MealPlanScreen(),
        '/meals': (context) => DailyMealPlan(),
        '/loading': (context) => const LoadingScreen(),
        '/fitnessgoal': (context) => FitnessGoalSelectionScreen(),

      },
    );
  }
}

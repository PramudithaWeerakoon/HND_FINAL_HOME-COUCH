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
import 'pages/db_connection.dart'; 
import 'pages/auth_provider.dart';


Future<void> main() async {
  final db = DatabaseConnection();
  await db.getConnection();

  final authProvider = AuthProvider(db); // Create an instance of AuthProvider

  // Run the Flutter app
  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/loading',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/question1': (context) =>Q1Page(), 
        '/question2': (context) =>const Q2Page(), 
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

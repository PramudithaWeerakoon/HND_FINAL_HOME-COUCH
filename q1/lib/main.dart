import 'package:flutter/material.dart';
import 'package:q1/firebase_options.dart';
import 'package:q1/pages/q1.dart';
import 'package:q1/pages/q2.dart';
import 'package:q1/pages/Home.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/instructionPage.dart';
import 'pages/settings.dart';
import 'pages/q19.dart';
import 'pages/mealplan.dart';
import 'pages/goals.dart';
import 'pages/loading.dart';
import 'pages/db_connection.dart'; 
import 'pages/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/analysis.dart';
import 'pages/goal_byday.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  final db = DatabaseConnection();
  await db.getConnection(); // Connect to the database
  final authProvider = AuthProvider(db); // Create an instance of AuthProvider
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
        '/meals': (context) => const DailyMealPlan(),
        '/loading': (context) => const LoadingScreen(),
        '/statistics': (context) => const WeightTrackerPage(),
        //'/q20': (context) => const MealPlanScreen(),
        '/meals': (context) => const DailyMealPlan(),
        '/loading': (context) => const LoadingScreen(),
        '/statistics': (context) => const WeightTrackerPage(),
        '/goal_byday': (context) => const GoalsByDay(weekNumber: 1),
      },
    );
  }
}

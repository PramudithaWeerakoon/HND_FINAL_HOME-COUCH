import 'package:flutter/material.dart';
import 'pages/q1.dart'; // Import your q1.dart page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Set HomePage as the initial route
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to q1.dart when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Q1Page()),
            );
          },
          child: const Text('Go to Q1'),
        ),
      ),
    );
  }
}
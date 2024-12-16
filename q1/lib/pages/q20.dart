import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_connection.dart'; // Replace with your actual file path

class PlanSummaryScreen extends StatefulWidget {
  const PlanSummaryScreen({Key? key}) : super(key: key);

  @override
  _PlanSummaryScreenState createState() => _PlanSummaryScreenState();
}

class _PlanSummaryScreenState extends State<PlanSummaryScreen> {
  Future<Map<String, dynamic>>? userFitnessData;

  @override
  void initState() {
    super.initState();
    userFitnessData = _fetchAndSaveFitnessData();
  }

  Future<Map<String, dynamic>> _fetchAndSaveFitnessData() async {
    try {
      final data = await fetchUserFitnessDetails();
      final prefs = await SharedPreferences.getInstance();
      // Save JSON string locally
      await prefs.setString('user_fitness_data', jsonEncode(data));
      return data;
    } catch (e) {
      print("Error fetching or saving user fitness details: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchUserFitnessDetails() async {
    // Replace this with your actual implementation
    return {
      'user_info': {'username': 'JohnDoe'},
      'fitness_data': {'steps': 10000, 'calories': 500},
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: userFitnessData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load fitness data.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            // You can now use the fetched data in the UI
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Welcome ${data['user_info']['username']}!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Your fitness details are successfully loaded.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: const Text("Go to Home"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("No data found. Please try again."),
            );
          }
        },
      ),
    );
  }
}

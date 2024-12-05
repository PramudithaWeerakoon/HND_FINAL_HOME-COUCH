import 'package:flutter/material.dart';
import 'db_connection.dart'; 
import 'fitnessgoal.dart';

class Q13Screen extends StatelessWidget {
  const Q13Screen({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseConnection dbConnection = DatabaseConnection();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100), // Space from the top
            const Text(
              "Your Fitness Profile is ready!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50),

            // FutureBuilder to fetch and display health data
            FutureBuilder<Map<String, dynamic>>(
              future: dbConnection.fetchAndUpsertHealthData(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      _buildInfoTile("Body Weight", "${data['weight']} kg"),
                      _buildInfoTile("Height", "${data['heightInMeters']} m"),
                      _buildInfoTile("BMI", data['bmi'].toStringAsFixed(2)),
                      _buildInfoTile(
                          "Body Fat %", data['bodyFat'].toStringAsFixed(2)),
                      _buildInfoTile("Daily Caloric Intake",
                          "${data['dailyCalories']} kcal"),
                    ],
                  );
                } else {
                  return const Text("No data found.");
                }
              },
            ),
            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Q16 when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FitnessGoalSelectionScreen(), // Navigate to Q15Screen
                          
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build individual data rows
  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

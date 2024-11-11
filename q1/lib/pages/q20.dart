import 'package:flutter/material.dart';

class PlanSummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> daysData = [
    {
      "day": "Day 01",
      "exercises": [
        ["Overhead Press", "Shoulders", "4", "8"],
        ["Dumbbell Fly", "Chest & Shoulders", "3", "10"],
        ["Lateral Raise", "Shoulders", "4", "8"],
        ["Concentration Curls", "Shoulders", "4", "8"],
        ["Skull-Crushes", "Triceps", "3", "10"],
        ["Bicep Curls", "Biceps", "4", "8"],
      ]
    },
    {
      "day": "Day 02",
      "exercises": [
        ["Bench Press", "Chest", "3", "8"],
        ["Pushup", "Chest", "3", "10"],
      ]
    },
    {
      "day": "Day 03",
      "exercises": [
        ["Deadlift", "Back", "4", "6"],
        ["Pull-up", "Back", "3", "8"],
      ]
    },
    // Add more day data as needed
  ];

  PlanSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Congratulations!\nPlan is ready",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Body Re-composition - 3 Months Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Scrollable list of day cards
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Prevents inner scrolling within SingleChildScrollView
                  itemCount: daysData.length,
                  itemBuilder: (context, index) {
                    final dayData = daysData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child:
                          _buildDayCard(dayData["day"], dayData["exercises"]),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: "Your plan is tailored to fit your body and goals. ",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    children: [
                      TextSpan(
                        text: "Work hard",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ", and results will follow!"),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 22),
                    backgroundColor: Color(0xFFB30000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to home
                  },
                  child: Text(
                    "Continue To Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(String dayTitle, List<List<String>> exercises) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  children: [
                    _buildTableHeader("Exercise"),
                    _buildTableHeader("Target Area"),
                    _buildTableHeader("Sets"),
                    _buildTableHeader("Reps"),
                  ],
                ),
                ...exercises.map((exercise) => TableRow(
                      children: exercise
                          .map((data) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  data,
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          .toList(),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

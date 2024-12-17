import 'package:flutter/material.dart';
import 'db_connection.dart';

class PlanSummaryScreen extends StatefulWidget {
  const PlanSummaryScreen({super.key});

  @override
  State<PlanSummaryScreen> createState() => PlanSummaryScreenState();
}

class PlanSummaryScreenState extends State<PlanSummaryScreen> {
  final DatabaseConnection dbConnection = DatabaseConnection();
  List<Map<String, dynamic>> workoutData = [];

  @override
  void initState() {
    super.initState();
    loadWorkoutData();
  }

  Future<void> loadWorkoutData() async {
    try {
      final data = await dbConnection.fetchWorkoutPlan();
      setState(() {
        workoutData = data;
      });
    } catch (e) {
      print("Error fetching workout data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load workout data. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
     
      body: workoutData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Congratulations!\nPlan is ready",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Your Tailored Workout Plan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workoutData.length,
                      itemBuilder: (context, index) {
                        final dayData = workoutData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildDayCard(dayData),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 18),
                        backgroundColor: const Color(0xFFB30000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: const Text(
                        "Continue To Home",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDayCard(Map<String, dynamic> dayData) {
    final exercises = dayData['exercises'] as List<dynamic>? ?? [];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayData['day'] ?? "Day",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                _buildTableHeader(),
                ..._buildExerciseRows(exercises),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      children: [
        _buildTableCellHeader("Exercise"),
        _buildTableCellHeader("Sets"),
        _buildTableCellHeader("Reps"),
      ],
    );
  }

  List<TableRow> _buildExerciseRows(List<dynamic> exercises) {
    return exercises.map((exercise) {
      return TableRow(
        children: [
          _buildTableCell(exercise['exercise']?.toString() ?? "N/A"),
          _buildTableCell(exercise['sets']?.toString() ?? "0"),
          _buildTableCell(exercise['reps']?.toString() ?? "0"),
        ],
      );
    }).toList();
  }

  static Widget _buildTableCellHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        value,
        textAlign: TextAlign.center,
      ),
    );
  }
}

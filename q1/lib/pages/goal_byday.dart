import 'package:flutter/material.dart';
import 'package:q1/components/menuBar/menuBar.dart';
import 'package:q1/widgets/gradient_background.dart';
import 'db_connection.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalsByDay extends StatefulWidget {
  final int weekNumber;

  const GoalsByDay({super.key, required this.weekNumber});

  @override
  _GoalsByDayState createState() => _GoalsByDayState();
}

class _GoalsByDayState extends State<GoalsByDay> {
  int _currentIndex = 3;
  int workoutDaysPerWeek = 0;
  Map<int, int> durationPerDay = {};

  @override
  void initState() {
    super.initState();
    fetchWorkoutDays(); // Fetch the data when the page loads
  }

  void fetchWorkoutDays() async {
    try {
      final userEmail = SessionManager.getUserEmail();
      print('User email: $userEmail');
      if (userEmail != null) {
        final db = DatabaseConnection();
        final days = await db.getWorkoutDaysPerWeek(userEmail);
        final durationData = await db.getTotalDurationPerDay(userEmail, widget.weekNumber);

        setState(() {
          workoutDaysPerWeek = days;
          durationPerDay = durationData;
        });
      } else {
        print("No user is currently logged in.");
      }
    } catch (e) {
      print("Error fetching workout days: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Workout Days',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: workoutDaysPerWeek > 0
              ? ListView.builder(
                  itemCount: workoutDaysPerWeek,
                  itemBuilder: (context, index) {
                    final dayNumber = index + 1;
                    final duration = durationPerDay[dayNumber] ?? 0;
                    final hours = (duration / 60).floor();
                    final minutes = duration % 60;
                    final hoursText = hours > 0 ? "$hours hr " : "";
                    final minutesText = minutes > 0 ? "$minutes mins" : "";

                    return DayProgressCard(
                      day: "Day $dayNumber",
                      progress: duration / (workoutDaysPerWeek * 60), // Example progress
                      hours: "$hoursText$minutesText", // Display the duration
                      progressColor: Colors.green, // Example color
                    );
                  },
                )
              : Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: BottomMenuBar(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class DayProgressCard extends StatelessWidget {
  final String day;
  final double progress;
  final String hours;
  final Color progressColor;

  const DayProgressCard({
    super.key,
    required this.day,
    required this.progress,
    required this.hours,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: progress,
                center: Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: progressColor,
                backgroundColor: Colors.grey[200]!,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      hours,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

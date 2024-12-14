import 'package:flutter/material.dart';
import 'package:q1/components/menuBar/menuBar.dart';
import 'package:q1/widgets/gradient_background.dart';
import 'db_connection.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';


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
  String fitnessGoal = "";

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
        final progress = await db.getFitnessProgress(userEmail);

        setState(() {
          workoutDaysPerWeek = days;
          durationPerDay = Map.fromEntries(
            durationData.entries.where((entry) => entry.value > 0),

          );
          fitnessGoal = progress['fitnessGoal'];

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
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

       body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Fitness Goal: $fitnessGoal",
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const
            SizedBox(height: 20),
            if (durationPerDay.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add space on both sides
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}',
                                style: TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // Hide right side Y-axis
                        ),
                        
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'Day ${value.toInt()}',
                                style: TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false), // Remove background dot lines
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1), // X-axis line
                          left: BorderSide(color: Colors.black, width: 1), // Y-axis line
                        ),
                      ),
                      barGroups: durationPerDay.entries.map((entry) {
                        Color barColor;
                        if (entry.value < 40) {
                          barColor = Color(0xFFEAB804);
                        } else if (entry.value < 70) {
                          barColor = Color(0xFF01620B);
                        } else {
                          barColor = Color(0xFF21007E);
                        }
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: barColor,
                              width: 25,
                              borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  "No workout data available for this week.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),
          Expanded(
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

                    final progress = duration / (workoutDaysPerWeek * 60); // Example progress

                    return DayProgressCard(
                      day: "Day $dayNumber",
                      progress: progress,
                      hours: "$hoursText$minutesText", // Display the duration
                      progressColor: progress == 1
                      ? Color(0xFF21007E)
                      : progress >= 0.5
                        ? Color(0xFF01620B)
                        : Color(0xFFEAB804),
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
            ],
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

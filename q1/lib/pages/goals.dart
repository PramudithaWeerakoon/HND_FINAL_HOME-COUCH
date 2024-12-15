import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:q1/components/menuBar/menuBar.dart';
import 'package:q1/widgets/gradient_background.dart';
import 'db_connection.dart';
import 'goal_byday.dart';


void main() => runApp(FitnessApp());

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FitnessHomePage(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  _FitnessHomePageState createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
   int _currentIndex = 3;
  String fitnessGoal = "Loading...";
  int completedDays = 0;
  int totalDays = 0;
  int workoutDaysPerWeek = 0;
  List<Map<String, dynamic>> weeklyDurations = [];
  double totalDurationHours = 0.0;
  double fpCurrentWeight = 0.0;
  double fgTargetWeight = 0.0;
  double fpBeginningWeight = 0.0;

  @override
  void initState() {
    super.initState();
    fetchFitnessData(); // Fetch the data when the page loads
  }

  void fetchFitnessData() async {
  try {
    final userEmail = SessionManager.getUserEmail();
    print('User email: $userEmail');
    if (userEmail != null) {
      final db = DatabaseConnection();
      final progress = await db.getFitnessProgress(userEmail);
      final weeklyData = await db.getWeeklyDurations(userEmail);
      final workoutDays = await db.getWorkoutDaysPerWeek(userEmail);
      final totalDuration = await db.getTotalDuration(userEmail);
      final currentWeight = await db.getCurrentWeight(userEmail);
      final targetWeight = await db.getTargetWeight(userEmail);
      final uniqueDaysDone = await db.getUniqueDaysDone(userEmail); // Fetch unique days done
      final beginningWeight = await db.getBeginningWeight(userEmail); // Fetch beginning weight


      setState(() {
        fitnessGoal = progress['fitnessGoal'];
        completedDays = uniqueDaysDone; // Use unique days done
        totalDays = progress['totalDays'];
        weeklyDurations = weeklyData; // Save weekly durations
        workoutDaysPerWeek = workoutDays; // Save workout days per week
        totalDurationHours = totalDuration;
        fpCurrentWeight = currentWeight;
        fgTargetWeight = targetWeight;
        fpBeginningWeight = beginningWeight; // Save beginning weigh
      });
    } else {
      print("No user is currently logged in.");
    }
  } catch (e) {
    print("Error fetching fitness data: $e");
  }
}
    Widget buildWeightDetails() {
  // Calculate the weight difference between current and beginning weight
  final weightDifference = fpCurrentWeight - fpBeginningWeight;

  String displayText = weightDifference.toStringAsFixed(2);
  Color displayColor = weightDifference < 0 ? Colors.red : Colors.green;

  return Column(
    children: [
      Text(
        'Weight',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(
        displayText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: displayColor,
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        totalDays > 0 ? completedDays / totalDays : 0.0; // Calculate percentage
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                fitnessGoal,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      HalfCircleProgressBar(
                        progress: progressPercentage,
                        radius: 80.0,
                        progressColor: Color(0xFF21007E),
                        backgroundColor: Color(0xFFBDB9B9),
                        showPercentage: true,
                      ),
                      SizedBox(height: 5),
                        Text(
                         'Days done: $completedDays/$totalDays',
                        style: TextStyle(
                          color: const Color.fromARGB(137, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${totalDurationHours.toStringAsFixed(1)} hrs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                           buildWeightDetails(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: workoutDaysPerWeek > 0
                  ? ListView(
                      padding: EdgeInsets.only(bottom: 16.0),
                      children: generateWeekProgressCards(totalDays, weeklyDurations),
                    )
                  : Center(
                      child: Text("No workout days available."),
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

class WeekProgressCard extends StatelessWidget {
  final String week;
  final int weekNumber;
  final double progress;
  final String hours;
  final Color progressColor;

  const WeekProgressCard({super.key, 
    required this.week,
    required this.weekNumber,
    required this.progress,
    required this.hours,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoalsByDay(weekNumber: weekNumber)),
          );
        },
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
                        week,
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
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


List<Widget> generateWeekProgressCards(int totalDays, List<Map<String, dynamic>> weeklyDurations) {
  int totalWeeks = (totalDays / 7).ceil();
  List<Widget> weekCards = [];

  // Create a map of week numbers to durations for quick lookup, ensuring correct data types
  Map<int, double> weekDurationsMap = {
    for (var data in weeklyDurations)
      int.parse(data['week'].toString()): 
          double.tryParse(data['total_duration'].toString()) ?? 0.0
  };

  for (int i = 1; i <= totalWeeks; i++) {
    final totalDuration = weekDurationsMap[i] ?? 0.0; // Default to 0 if no data for the week
    final progress = totalDuration / (7 * 60); // Assuming 7 days a week and duration in minutes

    weekCards.add(
      WeekProgressCard(
        week: 'Week $i',
        weekNumber: i,
        progress: progress,
        hours: '${(totalDuration / 60).toStringAsFixed(1)} hrs', // Convert minutes to hours
        progressColor: progress == 1.0
            ? Color(0xFF21007E)
            : progress >= 0.5
                ? Color(0xFF01620B)
                : Color(0xFFEAB804),
      ),
    );
  }

  return weekCards;
}

class HalfCircleProgressBar extends StatelessWidget {
  final double progress; // Progress in percentage (0.0 to 1.0)
  final double radius; // Radius of the half-circle
  final Color progressColor;
  final Color backgroundColor;
  final bool showPercentage;

  const HalfCircleProgressBar({super.key, 
    required this.progress,
    required this.radius,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(radius * 2.2, radius * 1.19), // Increase height for more curve
          painter: HalfCirclePainter(
            progress: progress,
            progressColor: progressColor,
            backgroundColor: backgroundColor,
          ),
        ),
        if (showPercentage)
          Positioned(
            bottom: 1, // Adjust the position of the percentage text
            child: Text(
              "${(progress * 100).toInt()}%", // Convert progress to percentage
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final double progress; // Progress in percentage (0.0 to 1.0)
  final Color progressColor;
  final Color backgroundColor;

  HalfCirclePainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round; // Rounded ends

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round; // Rounded ends

    final double startAngle = -3.14; // Start from the left
    final double sweepAngle = 3.14 * progress; // Cover the progress as a sweep

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // Draw background half-circle
    canvas.drawArc(rect, startAngle, 3.14, false, backgroundPaint);

    // Draw progress half-circle
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}






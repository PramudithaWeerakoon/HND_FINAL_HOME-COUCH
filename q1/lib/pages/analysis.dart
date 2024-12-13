import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:q1/components/menuBar/menuBar.dart';
import 'db_connection.dart'; // Import for database methods

class WeightTrackerPage extends StatefulWidget {
  const WeightTrackerPage({super.key});

  @override
  _WeightTrackerPageState createState() => _WeightTrackerPageState();
}

class _WeightTrackerPageState extends State<WeightTrackerPage> {
  String profileName = "User";
  double beginningWeight = 0.0;
  double goalWeight = 0.0;
  double currentWeight = 0.0;
  List<double> weeklyWeights = [];
  TextEditingController weightController = TextEditingController();
  List<int> keyWeeks = [];



  @override
  void initState() {
    super.initState();
    _fetchUserName();
    fetchWeights();
  }
   String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon 👋";
    } else {
      return "Good Evening 👋";
    }
  }
 
  void _fetchUserName() async {
    try {
      DatabaseConnection db = DatabaseConnection();
      final name = await db.getUserName();
      setState(() {
        profileName = name;
      });
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }
  
  void fetchWeights() async {
    try {
      final userEmail = SessionManager.getUserEmail();
      if (userEmail != null) {
        final db = DatabaseConnection();
        final fetchedCurrentWeight = await db.getCurrentWeight(userEmail);
        final fetchedTargetWeight = await db.getTargetWeight(userEmail);
        final fitnessProgress = await db.getFitnessProgress(userEmail);


        setState(() {
          beginningWeight = fetchedCurrentWeight; // Assume beginning weight is the current weight
          goalWeight = fetchedTargetWeight;
          currentWeight = fetchedCurrentWeight;
          final totalWeeks = fitnessProgress['totalWeeks'];

          if (totalWeeks > 0) {
            keyWeeks.add(1); // Always include the first week
            for (int i = 1; i <= 3; i++) {
              int week = (totalWeeks * i / 4).ceil();
              if (!keyWeeks.contains(week)) {
                keyWeeks.add(week);
              }
            }
            keyWeeks.add(totalWeeks); // Always include the last week
          }

          _generateWeeklyWeights(keyWeeks.length);
        });

        
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error fetching weights: $e");
    }
  }

void _generateWeeklyWeights(int totalWeeks) {
  double weightChangePerWeek = (goalWeight - beginningWeight) / totalWeeks;

  weeklyWeights = List.generate(totalWeeks, (index) {
    return beginningWeight + (weightChangePerWeek * index);
  });
}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double minWeight = (beginningWeight < goalWeight ? beginningWeight : goalWeight) - 5;
    double maxWeight = (beginningWeight > goalWeight ? beginningWeight : goalWeight) + 5;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/assets/profileimage.jpg'),
              radius: screenSize.width * 0.05,
            ),
            SizedBox(width: screenSize.width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(fontSize: screenSize.width * 0.04),
                ),
                Text(
                  profileName,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "You're on Target",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Beginning : ${beginningWeight.toStringAsFixed(1)}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Goal : ${goalWeight.toStringAsFixed(1)}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Current : ${currentWeight.toStringAsFixed(1)}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB30000),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onPressed: () async {
      try {
        final userEmail = SessionManager.getUserEmail();
        if (userEmail != null) {
          final newTargetWeight = double.tryParse(weightController.text);
          if (newTargetWeight != null && newTargetWeight > 0) {
            final db = DatabaseConnection();
            await db.updateTargetWeight(userEmail, newTargetWeight);

            setState(() {
              goalWeight = newTargetWeight; // Update local state
              weightController.clear(); // Clear the text field
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Target weight updated to $newTargetWeight kg')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please enter a valid number')),
            );
          }
        } else {
          print("No user is logged in.");
        }
      } catch (e) {
        print("Error updating target weight: $e");
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: screenSize.width * 0.1,
          child: TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Weight',
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.02),
        Text('KG', style: TextStyle(fontSize: screenSize.width * 0.04)),
        SizedBox(width: screenSize.width * 0.02),
        Icon(Icons.add, size: screenSize.width * 0.05),
      ],
    ),
  ),
),
                SizedBox(height: screenSize.height * 0.03),
                SizedBox(
                  height: screenSize.height * 0.3,
                  child: LineChart(
                    LineChartData(
                      minY: minWeight,
                      maxY: maxWeight,
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              // Ensure value matches the index of keyWeeks
                              int index = value.toInt();
                              if (index >= 0 && index < keyWeeks.length) {
                                return Text(
                                  'Week ${keyWeeks[index]}',
                                  style: TextStyle(fontSize: screenSize.width * 0.035),
                                );
                              }
                              return const Text('');
                            },
                            interval: 1, // Align labels with keyWeeks
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}Kg',
                              style: TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                            reservedSize: screenSize.width * 0.12,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklyWeights
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: screenSize.width * 0.01,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(radius: screenSize.width * 0.02, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.1),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenuBar(
        currentIndex: 2,
        onTabSelected: (index) {
          // Handle bottom navigation actions here
        },
      ),
    );
  }
}

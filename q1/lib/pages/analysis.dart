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
  double goalWeight = 0.0;
  List<double> weeklyWeights = [];
  TextEditingController weightController = TextEditingController();
  List<int> keyWeeks = [];
  double fpCurrentWeight = 0.0;
  double fpBeginningWeight = 0.0;




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
        final fetchedWeights = await db.getWeightHistory(userEmail);
        final beginningWeight = await db.getBeginningWeight(userEmail); // Fetch beginning weight


        setState(() {
          fpBeginningWeight = beginningWeight; // Save beginning weigh
          goalWeight = fetchedTargetWeight;
          fpCurrentWeight = fetchedCurrentWeight;
          final totalWeeks = fitnessProgress['totalWeeks'];
           weeklyWeights = fetchedWeights.map((entry) => entry['weight'] as double).toList();
        keyWeeks = List.generate(weeklyWeights.length, (index) => index + 1); // Week labels
        if (weeklyWeights.isNotEmpty) {
          fpBeginningWeight = weeklyWeights.first;
          fpCurrentWeight = weeklyWeights.last;
        }
      });

        
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error fetching weights: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Dynamically adjust min and max weight to ensure chart boundaries are maintained
    double minWeight = (weeklyWeights.isNotEmpty ? weeklyWeights.reduce((a, b) => a < b ? a : b) : 0) - 5;
    double maxWeight = (weeklyWeights.isNotEmpty ? weeklyWeights.reduce((a, b) => a > b ? a : b) : 0) + 5;

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
                        "Beginning : ${fpBeginningWeight.toStringAsFixed(1)}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Goal : ${goalWeight.toStringAsFixed(1)}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Current : ${fpCurrentWeight.toStringAsFixed(1)}Kg",
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
          final newCurrentWeight = double.tryParse(weightController.text);
          if (newCurrentWeight != null && newCurrentWeight > 0) {
            final db = DatabaseConnection();
            await db.updateCurrentWeight(userEmail, newCurrentWeight);

            setState(() {
              fpCurrentWeight = newCurrentWeight; // Update local state
              weightController.clear(); // Clear the text field
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Current weight updated to $newCurrentWeight kg')),
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
        print("Error updating current weight: $e");
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
                      minY: minWeight, // Dynamically adjusted min weight
                      maxY: maxWeight, // Dynamically adjusted max weight
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < keyWeeks.length) {
                                return Text(
                                  'Day ${keyWeeks[index]}', // Map weeks to X-axis
                                  style: TextStyle(fontSize: screenSize.width * 0.035),
                                );
                              }
                              return const Text('');
                            },
                            interval: 1,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}Kg', // Map weights to Y-axis
                              style: TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklyWeights
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                              .toList(),
                          isCurved: true, // Smooth curve
                          color: Colors.blue,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                        spots: [
                          FlSpot(0, fpBeginningWeight),
                          FlSpot(weeklyWeights.length - 1, fpBeginningWeight),
                        ],
                        isCurved: false,
                        color: Colors.green,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                     LineChartBarData(
  spots: [
    FlSpot(0, goalWeight),
    FlSpot((weeklyWeights.length - 1).toDouble(), goalWeight),
  ],
  isCurved: false,
  color: Colors.red,
  barWidth: 2,
  belowBarData: BarAreaData(show: false),
  dotData: FlDotData(show: false),
),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: screenSize.width * 0.02,
                          height: screenSize.width * 0.02,
                          color: Colors.red,
                        ),
                        SizedBox(width: screenSize.width * 0.01),
                        Text(
                          'Target Weight',
                          style: TextStyle(fontSize: screenSize.width * 0.030),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.02), // Consistent spacing
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: screenSize.width * 0.02,
                          height: screenSize.width * 0.02,
                          color: Colors.green,
                        ),
                        SizedBox(width: screenSize.width * 0.01),
                        Text(
                          'Beginning Weight',
                          style: TextStyle(fontSize: screenSize.width * 0.030),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.02), // Consistent spacing
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: screenSize.width * 0.02,
                          height: screenSize.width * 0.02,
                          color: Colors.blue,
                        ),
                        SizedBox(width: screenSize.width * 0.01),
                        Text(
                          'Ongoing Weight',
                          style: TextStyle(fontSize: screenSize.width * 0.030),
                        ),
                      ],
                    ),
                  ),  
                ],
              ),
            ),
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

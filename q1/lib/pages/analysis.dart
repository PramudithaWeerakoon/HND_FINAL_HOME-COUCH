import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:q1/components/menuBar/menuBar.dart'; // Import the BottomMenuBar

class WeightTrackerPage extends StatefulWidget {
  const WeightTrackerPage({super.key});

  @override
  _WeightTrackerPageState createState() => _WeightTrackerPageState();
}

class _WeightTrackerPageState extends State<WeightTrackerPage> {
  // Placeholder data; these will later be fetched from a database.
  String profileName = "Pramudtha";
  double beginningWeight = 80.8;
  double goalWeight = 100.0;
  double currentWeight = 85.3;
  double newRecordWeight = 100.3;
  List<double> weeklyWeights = [];
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateWeeklyWeights();
  }

  void _generateWeeklyWeights() {
    int totalWeeks = 4;
    double weightChangePerWeek = (goalWeight - beginningWeight) / totalWeeks;

    weeklyWeights = List.generate(totalWeeks, (index) {
      return beginningWeight + (weightChangePerWeek * index);
    });
  }

  void _updateNewRecordWeight() {
    setState(() {
      double enteredWeight = double.tryParse(weightController.text) ?? newRecordWeight;
      goalWeight = enteredWeight;
      _generateWeeklyWeights();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    double minWeight = (beginningWeight < goalWeight ? beginningWeight : goalWeight) - 5;
    double maxWeight = (beginningWeight > goalWeight ? beginningWeight : goalWeight) + 5;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/assets/profileimage.jpg'),
              radius: screenSize.width * 0.05, // Adjust radius for responsiveness
            ),
            SizedBox(width: screenSize.width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning 👋',
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
                        "Beginning : ${beginningWeight}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Goal : ${goalWeight}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                      Text(
                        "Weight now : ${currentWeight}Kg",
                        style: TextStyle(fontSize: screenSize.width * 0.04),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Center(
                  child: Text(
                    'Enter new Record',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB30000),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _updateNewRecordWeight,
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
                  height: screenSize.height * 0.3, // Responsive height for the chart
                  child: LineChart(
                    LineChartData(
                      minY: minWeight,
                      maxY: maxWeight,
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              'Week ${value.toInt() + 1}',
                              style: TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                            interval: 1,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}',
                              style: TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                            reservedSize: screenSize.width * 0.12, // Extra padding
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

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class MuscleWeightProgressScreen extends StatelessWidget {
  final List<Map<String, dynamic>> mockData = [
    {'day': 'Day 1', 'minutes': 34.5, 'progress': 100},
    {'day': 'Day 2', 'minutes': 22.0, 'progress': 82},
    {'day': 'Day 3', 'minutes': 28.5, 'progress': 65},
    {'day': 'Day 4', 'minutes': 30.0, 'progress': 90},
  ];

  // Define a color map to keep consistent color assignments
  final Map<String, Color> colorMap = {};
  final Set<Color> usedColors = {}; // Set to track used colors

  // Generate a random color for each day
  Color getColorForDay(String day) {
    if (!colorMap.containsKey(day)) {
      Color newColor;
      do {
        // Generate a random color
        newColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      } while (usedColors.contains(newColor)); // Ensure it's not a used color

      colorMap[day] = newColor;
      usedColors.add(newColor); // Add the new color to the used set
    }
    return colorMap[day]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            const Text(
              'Build Muscles &\nLose Weight',
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Bar chart container
            Container(
              height: 300,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Week 1',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 40,
                        barGroups: mockData.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          var data = entry.value;
                          return BarChartGroupData(x: index, barRods: [
                            BarChartRodData(
                              toY: data['minutes'],
                              color: getColorForDay(data['day']),
                              width: 25,
                            )
                          ]);
                        }).toList(),
                        gridData: FlGridData(
                          show: false, // Hides the grid lines completely
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(color: Colors.black, width: 1),
                            bottom: BorderSide(color: Colors.black, width: 1),
                            // Hide top and right borders by not defining them
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 10,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                if (value.toInt() > 0 &&
                                    value.toInt() <= mockData.length) {
                                  return Text(
                                      mockData[value.toInt() - 1]['day']);
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Scrollable list of progress cards
            Expanded(
              child: ListView.builder(
                itemCount: mockData.length,
                itemBuilder: (context, index) {
                  final data = mockData[index];
                  return _buildProgressCard(
                    data['day'],
                    data['minutes'],
                    data['progress'],
                    getColorForDay(data['day']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progress card with circular progress indicator
  Widget _buildProgressCard(
      String day, double minutes, int progress, Color color) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator with assigned color
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[200],
                  color: color,
                  strokeWidth: 5,
                ),
                Text(
                  '$progress%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Text(
                '${minutes.toStringAsFixed(1)} Min',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

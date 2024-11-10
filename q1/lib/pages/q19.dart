import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'q20.dart';

class CustomizedPlanScreen extends StatelessWidget {
  const CustomizedPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // Reduced top padding
              Text(
                "Your Journey\nBegins Here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Your Tailored Plan Is Ready!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Stretched Line Chart
                    SizedBox(
                      height: 250, // Increased height to stretch the chart
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 3,
                          minY: 60,
                          maxY: 70,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 40, // Allocates space for titles
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                15), // Adjusted top padding to lower text
                                        child: Text("02/08/24"),
                                      );
                                    case 3:
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                15), // Adjusted top padding to lower text
                                        child: Text("02/12/24"),
                                      );
                                    default:
                                      return Text("");
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text("${value.toInt()} KG");
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 70),
                                FlSpot(1, 68),
                                FlSpot(2, 65),
                                FlSpot(3, 62),
                              ],
                              isCurved: true,
                              color: Colors.yellow,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.3),
                                    Colors.green.withOpacity(0.3),
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 30), // Increased spacing above the stats row
                    // Labels for "Start" and "End"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Start",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("End",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        _buildStatRow("BMI", "25", "-3%", "22"),
                        SizedBox(height: 10),
                        _buildStatRow("BF%", "25", "-9%", "16"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Moved this text above the button
              Text(
                "We all start at one place\nend is what matters.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 65, vertical: 22),
                    backgroundColor: Color(0xFF01620B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  // Handle button press
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlanSummaryScreen()),
                  );
                },
                child: Text(
                  "Generate Your Customized Plan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String start, String change, String end) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text(start, style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(width: 5),
        Row(
          children: [
            Text(change, style: TextStyle(fontSize: 14, color: Colors.green)),
            Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
          ],
        ),
        SizedBox(width: 5),
        Text(end, style: TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }
}


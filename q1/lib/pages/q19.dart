import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomizedPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Journey\nBegins Here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your Tailored Plan Is Ready!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
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
                  // Actual Line Chart
                  Container(
                    height: 150,
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
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text("02/08/24");
                                  case 3:
                                    return Text("02/12/24");
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
                            colors: [Colors.yellow, Colors.green],
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [
                                Colors.yellow.withOpacity(0.3),
                                Colors.green.withOpacity(0.3),
                              ],
                              gradientFrom: Offset(0, 0),
                              gradientTo: Offset(0, 1),
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn("BMI", "25", "-3%", "22"),
                      _buildStatColumn("BF%", "25", "-9%", "16"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We all start at one place\nend is what matters.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                // Handle button press
              },
              child: Text(
                "Generate Your Customized Plan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
      String title, String start, String change, String end) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Row(
          children: [
            Text(start, style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(width: 4),
            Text(
              change,
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            SizedBox(width: 4),
            Text(end, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      home: CustomizedPlanScreen(),
    ));

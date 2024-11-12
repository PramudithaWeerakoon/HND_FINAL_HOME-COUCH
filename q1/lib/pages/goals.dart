import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:q1/components/menuBar/menuBar.dart';
import 'package:q1/widgets/gradient_background.dart';

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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                'Build Muscles &\nLose Weight',
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
                      CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 15.0,
                        percent: 0.7,
                        center: Text(
                          "70%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        progressColor: Color(0xFF21007E),
                        backgroundColor: Color(0xFFBDB9B9),
                      ),
                      SizedBox(height: 10),
                        Text(
                        'Days done: 63/90',
                        style: TextStyle(
                          color: const Color.fromARGB(137, 0, 0, 0),
                          fontSize: 18,
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
                                '31.5 hrs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
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
                                '5.5 kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 16.0), // Adjust padding to prevent overflow
                  children: [
                    WeekProgressCard(
                      week: 'Week 1',
                      progress: 0.75,
                      hours: '2.6 hrs',
                        progressColor: Color(0xFF01620B),
                    ),
                    WeekProgressCard(
                      week: 'Week 2',
                      progress: 1.0,
                      hours: '3.5 hrs',
                        progressColor: Color(0xFF21007E),
                    ),
                    WeekProgressCard(
                      week: 'Week 3',
                      progress: 0.55,
                      hours: '2.1 hrs',
                        progressColor: Color(0xFFEAB804),
                    ),
                    // Add more cards if needed
                  ],
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
  final double progress;
  final String hours;
  final Color progressColor;

  const WeekProgressCard({super.key, 
    required this.week,
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
          padding: EdgeInsets.all(20.0), // Increased padding inside the card
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centers items vertically
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
              SizedBox(
                  width: 16.0), // Add some space between the indicator and text
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
                    SizedBox(height: 4.0), // Space between title and subtitle
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
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


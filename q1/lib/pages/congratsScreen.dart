import 'dart:async';
import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({super.key});

  @override
  _CongratulationsScreenState createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  bool showGif = true; // Show GIF for 3 seconds
  String selectedFeedback = '';

  @override
  void initState() {
    super.initState();
    // Timer to hide the GIF after 3 seconds
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showGif = false;
      });
    });
  }

  void _handleFeedback(String feedback) {
    setState(() {
      selectedFeedback = feedback;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: GradientBackground(
        child: Stack(
          children: [
            // GIF layer with opacity on the main layer
            if (showGif)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'lib/assets/congrats.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Day 1 Workout\nCompleted",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B3939),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 70),
                  
                  // Exercises and Time section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Color(0xFF21007E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Column(
                          children: [
                            Text(
                              "Exercises",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "6",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "34:25",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Feedback section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "How did you feel?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _handleFeedback("Too hard"),
                              child: Column(
                                children: [
                                  Icon(Icons.sentiment_very_dissatisfied,
                                      size: 36,
                                      color: selectedFeedback == "Too hard"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Too hard",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      color: selectedFeedback == "Too hard"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleFeedback("Normal"),
                              child: Column(
                                children: [
                                  Icon(Icons.sentiment_satisfied,
                                      size: 36,
                                      color: selectedFeedback == "Normal"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Normal",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      color: selectedFeedback == "Normal"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleFeedback("Too easy"),
                              child: Column(
                                children: [
                                  Icon(Icons.sentiment_very_satisfied,
                                      size: 36,
                                      color: selectedFeedback == "Too easy"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Too easy",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      color: selectedFeedback == "Too easy"
                                          ? Color(0xFF21007E)
                                          : Color(0xFF3B3939),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90),

                  // Continue to Home button with arrow icon
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home'); // Navigate to home screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB30000), // Red color
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      "Continue To Home",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

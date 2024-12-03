import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({super.key});

  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600; // Define a breakpoint for small screens

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02), // Adjust padding based on screen width
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    // Workout Name Button
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21007E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Overhead Press - 4 Sets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // GIF Placeholder
                    Container(
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('lib/assets/overheadpress.gif'), // Replace with actual gif path
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Tutorial Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(179, 175, 2, 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Tutorial",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Instructions Box
                    Center(
                      child: Container(
                        width: screenWidth * 0.85, // Adjust width to 85% of screen width
                        height: screenHeight * 0.30,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Instructions",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              ...List.generate(7, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}. Engage Core:\nTighten your core and maintain a straight back.",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Sets and Reps Info
                    Text(
                      '4 Sets x 10 Reps',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Back Button
            Positioned(
              left: screenWidth * 0.04,
              bottom: screenHeight * 0.05,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the previous screen
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: screenWidth * 0.05,
                ),
                label: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAB804),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            // Start Button
            Positioned(
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.05,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Start workout action here
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: screenWidth * 0.05,
                ),
                label: Text(
                  "Start",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21007E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

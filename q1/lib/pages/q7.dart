import 'package:flutter/material.dart';
import 'q8.dart'; // Import Q8Screen

class Q7Screen extends StatefulWidget {
  const Q7Screen({super.key});

  @override
  _Q7ScreenState createState() => _Q7ScreenState();
}

class _Q7ScreenState extends State<Q7Screen> {
  int _waistCircumference = 85; // Initial waist circumference
  bool isCm = true; // Variable to track if in cm (true) or inches (false)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Let's get to know you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "What's the circumference of your waist?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),
              
              // Display the waist circumference
              Text(
                '$_waistCircumference',
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              
              // Horizontal line
              Container(
                height: 2, // Changed thickness to 2
                width: 130,
                color: Colors.black,
              ),
              const SizedBox(height: 16),

              // Toggle between cm and inches
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnitButton("cm", isCm), // cm button
                  const SizedBox(width: 10),
                  _buildUnitButton("in", !isCm), // inch button
                ],
              ),
              const Spacer(),

              // Page Indicator
              const Text(
                "9/12",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16, // Position the back button on the left
            bottom: 32, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'back_to_q6', // Unique tag for the left FAB
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to previous question (Q6)
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: 16, // Position the next button on the right
            bottom: 32, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'next_to_q8', // Unique tag for the right FAB
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Navigate to Q8Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Q8Screen(), // Navigate to Q8Screen
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the cm/in buttons
  Widget _buildUnitButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCm = (label == "cm");
          _waistCircumference = isCm ? 85 : (85 / 2.54).round(); // Convert to inches or cm
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

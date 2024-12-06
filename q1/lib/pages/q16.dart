import 'package:flutter/material.dart';
import 'q17.dart';
import 'db_connection.dart';

class Q16Screen extends StatefulWidget {
  const Q16Screen({super.key});

  @override
  _Q16ScreenState createState() => _Q16ScreenState();
}

class _Q16ScreenState extends State<Q16Screen> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Let's Set Your \nFitness Goal!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50), // Adjusted to control spacing
                  const Text(
                    'How many days per week \nwould you like to work out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 80), // Adjusted to reduce gap

                  // Center options without Expanded
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildOption("2 Days / Week", 2),
                      const SizedBox(height: 25),
                      _buildOption("4 Days / Week", 4),
                      const SizedBox(height: 25),
                      _buildOption("5 Days / Week", 5),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            left: 16,
            bottom: 32,
            child: FloatingActionButton(
              heroTag: 'back_button',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back to Q15
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // Next Button (appears only if an option is selected)
          if (_selectedOption != null)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next_button',
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                // Inside the onPressed callback for the "Next" button
                onPressed: () async {
                  if (_selectedOption != null) {
                    // Call the saveFitnessGoal method to store the selected number of workout days
                    await DatabaseConnection()
                        .saveFitnessGoaldays(_selectedOption!);

                    // Navigate to Q17Screen after saving the fitness goal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Q17Screen()),
                    );
                  }
                },

                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Widget to build each option box
  Widget _buildOption(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: _selectedOption == index
                ? const Color(0xFFB30000)
              : const Color.fromARGB(255, 223, 222, 222),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _selectedOption == index
                ? const Color.fromARGB(255, 255, 255, 255)
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

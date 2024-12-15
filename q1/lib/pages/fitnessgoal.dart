import 'package:flutter/material.dart';
import 'q15.dart'; // Import q15.dart
import 'db_connection.dart'; // Import db_connection.dart

class FitnessGoalSelectionScreen extends StatefulWidget {
  const FitnessGoalSelectionScreen({super.key});

  @override
  _FitnessGoalSelectionScreen createState() => _FitnessGoalSelectionScreen();
}

class _FitnessGoalSelectionScreen extends State<FitnessGoalSelectionScreen> {
  int? _selectedGoal; // Nullable to track selected fitness goal

  // Define image paths (adjust these as needed)
  final String loseWeightImagePath = 'lib/assets/Heavy.png';
  final String buildMuscleImagePath = 'lib/assets/Heavy.png';
  final String bothImagePath = 'lib/assets/Heavy.png';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  const Text(
                    "Let's Set Your \nFitness Goal!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                 SizedBox(height: screenHeight * 0.1),
                  const Text(
                    'Choose one of the goals to help us tailor your workout plan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                 SizedBox(height: screenHeight * 0.1),// Space between question and options

                  // Images with fitness goal options
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGoalOption('Lose Weight', loseWeightImagePath, 0, screenWidth),
                        _buildGoalOption('Build Muscle\n& Lose Weight', bothImagePath, 1, screenWidth),
                        _buildGoalOption('Build Muscle', buildMuscleImagePath, 2, screenWidth),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1), // Space before progress text
                ],
              ),
            ),
          ),
          if (_selectedGoal != null)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next_to_q15', // Unique tag for the FAB
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () async {
                  final goalMapping = {
                    0: 'Lose Weight',
                    1: 'Build Muscle & Lose Weight',
                    2: 'Build Muscle',
                  };

                  if (_selectedGoal != null) {
                    final selectedGoal = goalMapping[_selectedGoal];
                    final db = DatabaseConnection();

                    try {
                      await db.saveFitnessGoal(
                          selectedGoal!); // Save goal to the database
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Q15Screen(), // Navigate to Q15Screen
                        ),
                      );
                    } catch (e) {
                      print("Error saving goal: $e");
                    }
                  }
                },

                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Widget for building each fitness goal option with an image and label
  Widget _buildGoalOption(String label, String imagePath, int index, double screenWidth) {
    // Calculate size based on selection state
       double boxSize = _selectedGoal == index
        ? screenWidth * 0.35
        : (_selectedGoal == null ? screenWidth * 0.3 : screenWidth * 0.2);

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection: if already selected, deselect; otherwise, select
          _selectedGoal = _selectedGoal == index ? null : index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: _selectedGoal == index
                  ? Colors.blueAccent.withOpacity(0.2)
                  : Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _selectedGoal == index ? Colors.blueAccent : Colors.transparent,
                width: 3.0, // Highlight selected image
              ),
            ),
            child: Image.asset(
              imagePath,
              width: boxSize,
              height: boxSize,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _selectedGoal == index ? Colors.blueAccent : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

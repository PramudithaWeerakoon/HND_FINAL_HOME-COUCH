import 'package:flutter/material.dart';
import 'q15.dart'; // Import q15.dart

class FitnessGoalSelectionScreen extends StatefulWidget {
  const FitnessGoalSelectionScreen({super.key});

  @override
  _FitnessGoalSelectionScreen createState() => _FitnessGoalSelectionScreen();
}

class _FitnessGoalSelectionScreen extends State<FitnessGoalSelectionScreen> {
  int? _selectedGoal; // Nullable to track selected fitness goal

  // Define image paths (adjust these as needed)
  final String loseWeightImagePath = 'lib/assets/h.png';
  final String buildMuscleImagePath = 'lib/assets/h.png';
  final String bothImagePath = 'lib/assets/h.png';

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 90),
                  const Text(
                    'Choose one of the goals to help us tailor your workout plan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 90), // Space between question and options

                  // Images with fitness goal options
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGoalOption('Lose Weight', loseWeightImagePath, 0),
                        _buildGoalOption('Build Muscle\n& Lose Weight', bothImagePath, 1),
                        _buildGoalOption('Build Muscle', buildMuscleImagePath, 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Space before progress text
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
                onPressed: () {
                  // Navigate to q15.dart when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Q15Screen(), // Navigate to Q15Screen
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

  // Widget for building each fitness goal option with an image and label
  Widget _buildGoalOption(String label, String imagePath, int index) {
  // Calculate size based on selection state
  double boxSize = _selectedGoal == index ? 140 : (_selectedGoal == null ? 125 : 90);

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
              color: _selectedGoal == index
                  ? const Color.fromARGB(255, 31, 10, 80)
                  : Colors.transparent,
              width: 3.0, // Highlight selected image
            ),
          ),
          child: Image.asset(
            imagePath,
            width: boxSize,
            height: boxSize,
            fit: BoxFit.cover, // Ensures the image fits within the box
            alignment: _selectedGoal != null ? const Alignment(0.0, -0.9) : const Alignment(0.0, -0.6), // Aligns the image to the top for all boxes when any box is selected
          ),
        ),
        const SizedBox(height: 8.0), // Space between image and label
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _selectedGoal == index
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.black,
          ),
        ),
      ],
    ),
  );
}
}

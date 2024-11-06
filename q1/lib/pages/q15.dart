import 'package:flutter/material.dart';
import 'q16.dart'; // Import q16.dart

class Q15Screen extends StatefulWidget {
  const Q15Screen({super.key});

  @override
  _Q15ScreenState createState() => _Q15ScreenState();
}

class _Q15ScreenState extends State<Q15Screen> {
  // List to hold the selected muscle group indices
  List<int> _selectedGroups = [];

  // Define image paths for each muscle group (update paths as necessary)
  final String chestImagePath = 'lib/assets/Skinny.png';
  final String shouldersImagePath = 'lib/assets/Skinny.png';
  final String absImagePath = 'lib/assets/Skinny.png';
  final String bicepImagePath = 'lib/assets/Skinny-Fat.png';

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
                  const SizedBox(height: 50),
                  const Text(
                    'Which muscle groups \nwould you like to focus on?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40), // Space between question and options

                  // Images with muscle group options
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildMuscleGroupOption('Chest', chestImagePath, 0),
                        _buildMuscleGroupOption('Shoulders', shouldersImagePath, 1),
                        _buildMuscleGroupOption('Abs', absImagePath, 2),
                        _buildMuscleGroupOption('Bicep', bicepImagePath, 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Space before buttons
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
                Navigator.pop(context); // Navigate back when pressed
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // Next Button (appears only if at least one muscle group is selected)
          if (_selectedGroups.isNotEmpty)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next_button',
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  // Navigate to Q16 when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Q16Screen(), // Navigate to Q16Screen
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

  // Widget for each muscle group option with specified box size (159x148)
  Widget _buildMuscleGroupOption(String label, String imagePath, int index) {
    double boxWidth = 159;
    double boxHeight = 148;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedGroups.contains(index)) {
            _selectedGroups.remove(index); // Remove if already selected
          } else {
            _selectedGroups.add(index); // Add to selection if not selected
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color: _selectedGroups.contains(index)
                  ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2)
                  : const Color.fromARGB(255, 255, 255, 255), // Placeholder color
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _selectedGroups.contains(index)
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : Colors.transparent,
                width: 2.0, // Highlight selected box
              ),
            ),
            child: Stack(
              alignment: Alignment.topRight, // Position checkmark at top-right
              children: [
                Image.asset(
                  imagePath,
                  width: boxWidth,
                  height: boxHeight,
                  fit: BoxFit.cover,
                ),
                // Checkmark in the top-right corner when selected
                if (_selectedGroups.contains(index))
                  const Positioned(
                    top: 5,
                    right: 7,
                    child: Icon(
                      Icons.check_circle,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30, // Adjust size as needed
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _selectedGroups.contains(index)
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'q16.dart'; // Import q16.dart
import 'db_connection.dart'; // Import db_connection.dart

class Q15Screen extends StatefulWidget {
  const Q15Screen({super.key});

  @override
  _Q15ScreenState createState() => _Q15ScreenState();
}

class _Q15ScreenState extends State<Q15Screen> {
  // List to hold the selected muscle group names
  final List<String> _selectedGroups = [];

  // Define image paths for each muscle group (update paths as necessary)
  final String chestImagePath = 'lib/assets/chest.png';
  final String shouldersImagePath = 'lib/assets/shoulders.png';
  final String absImagePath = 'lib/assets/absplan.png';
  final String bicepImagePath = 'lib/assets/bicep.png';

  // Map index to muscle group names
  final List<String> muscleGroups = ['Chest', 'Shoulders', 'Abs', 'Bicep'];

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
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Which muscle groups \nwould you like to focus on?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.04), // Space between question and options

                  // Images with muscle group options
                  Expanded(
                    flex: 1,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: screenWidth / (screenHeight * 0.55), // Dynamic aspect ratio
                      children: [
                        _buildMuscleGroupOption('Chest', chestImagePath, 0, screenWidth, screenHeight),
                        _buildMuscleGroupOption('Shoulders', shouldersImagePath, 1, screenWidth, screenHeight),
                        _buildMuscleGroupOption('Abs', absImagePath, 2, screenWidth, screenHeight),
                        _buildMuscleGroupOption('Bicep', bicepImagePath, 3, screenWidth, screenHeight),
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
                onPressed: () async {
                  if (_selectedGroups.isNotEmpty) {
                    final db = DatabaseConnection();

                    try {
                      await db.saveSelectedMuscleGroups(
                          _selectedGroups); // Save selected muscle groups
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Q16Screen(), // Navigate to Q16Screen
                        ),
                      );
                    } catch (e) {
                      print("Error saving selected muscle groups: $e");
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

  // Widget for each muscle group option with specified box size (159x148)
  Widget _buildMuscleGroupOption(String label, String imagePath, int index, double screenWidth, double screenHeight) {
    double boxWidth = screenWidth * 0.4; // Adjust width based on screen width
    double boxHeight = screenHeight * 0.17; // Adjust height based on screen height

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedGroups.contains(muscleGroups[index])) {
            _selectedGroups
                .remove(muscleGroups[index]); // Remove if already selected
          } else {
            _selectedGroups
                .add(muscleGroups[index]); // Add to selection if not selected
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
              color: _selectedGroups.contains(muscleGroups[index])
                  ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2)
                  : const Color.fromARGB(
                      255, 255, 255, 255), // Placeholder color
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _selectedGroups.contains(muscleGroups[index])
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
                if (_selectedGroups.contains(muscleGroups[index]))
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
          SizedBox(height: screenHeight * 0.01),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _selectedGroups.contains(muscleGroups[index])
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

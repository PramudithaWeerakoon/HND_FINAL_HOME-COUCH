import 'package:flutter/material.dart';
import 'q7.dart'; // Import q7.dart
import 'db_connection.dart'; // Import the DatabaseConnection class

class FitnessBackgroundSelectionScreen extends StatefulWidget {
  const FitnessBackgroundSelectionScreen({super.key});

  @override
  _FitnessBackgroundSelectionScreen createState() =>
      _FitnessBackgroundSelectionScreen();
}

class _FitnessBackgroundSelectionScreen
    extends State<FitnessBackgroundSelectionScreen> {
  int? _selectedFitnessLevel; // Nullable to track selected fitness background
  final DatabaseConnection _dbConnection = DatabaseConnection();

  // Define image paths (You can change these if necessary)
  final String newbieImagePath = 'lib/assets/newbie.png';
  final String competentImagePath = 'lib/assets/competent.png';
  final String expertImagePath = 'lib/assets/expert.jpg';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "Let's get to know \n you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.1), // Space between title and question
              const Text(
                'What is your fitness background?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.1), // Space between question and options

              // Images with fitness background options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align at top
                  children: [
                    _buildFitnessLevelOption('Newbie', newbieImagePath, 0, screenWidth),
                    _buildFitnessLevelOption('Competent', competentImagePath, 1, screenWidth),
                    _buildFitnessLevelOption('Expert', expertImagePath, 2, screenWidth),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Add space between body types and progress text
              const Text(
                "6/12",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Add a small gap between the text and FAB
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
              heroTag: 'back_to_q5', // Unique tag for the left FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to Q5
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          if (_selectedFitnessLevel != null)
            Positioned(
              right: 16, // Position the next button on the right
              bottom: 32, // Adjust bottom position as needed
              child: FloatingActionButton(
                heroTag: 'next_to_q7', // Unique tag for the right FAB
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () async {
                  // Update the selected fitness background
                  String fitnessBackground;
                  switch (_selectedFitnessLevel) {
                    case 0:
                      fitnessBackground = 'Newbie';
                      break;
                    case 1:
                      fitnessBackground = 'Competent';
                      break;
                    case 2:
                      fitnessBackground = 'Expert';
                      break;
                    default:
                      fitnessBackground = '';
                      break;
                  }

                  // Save the selected fitness background in the database
                  try {
                    await _dbConnection
                        .updateFitnessBackground(fitnessBackground);
                    // Navigate to q7.dart when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Q7Screen(), // Navigate to Q7Screen
                      ),
                    );
                  } catch (e) {
                    print('Error updating fitness background: $e');
                  }
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Widget for building each fitness background option with an image and label
  Widget _buildFitnessLevelOption(String label, String imagePath, int index, double screenWidth) {
    // Calculate size based on selection state
    double boxSize = _selectedFitnessLevel == index
        ? screenWidth * 0.35
        : (_selectedFitnessLevel == null ? screenWidth * 0.3 : screenWidth * 0.2);

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection: if already selected, deselect; otherwise, select
          _selectedFitnessLevel = _selectedFitnessLevel == index ? null : index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust to min size of contents
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: _selectedFitnessLevel == index
                  ? Colors.blueAccent.withOpacity(0.2)
                  : Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _selectedFitnessLevel == index
                    ? Colors.blueAccent
                    : Colors.transparent,
                width: 3.0, // Highlight selected image
              ),
            ),
            child: Image.asset(
              imagePath,
              width: boxSize,
              height: boxSize,
              fit: BoxFit.cover, // Ensures the image fits within the box
            ),
          ),
          const SizedBox(height: 8.0), // Space between image and label
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _selectedFitnessLevel == index
                  ? Colors.blueAccent
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

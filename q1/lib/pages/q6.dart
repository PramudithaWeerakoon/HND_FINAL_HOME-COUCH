import 'package:flutter/material.dart';
import 'q7.dart'; // Import q7.dart

class FitnessBackgroundSelectionScreen extends StatefulWidget {
  const FitnessBackgroundSelectionScreen({super.key});

  @override
  _FitnessBackgroundSelectionScreen createState() =>
      _FitnessBackgroundSelectionScreen();
}

class _FitnessBackgroundSelectionScreen extends State<FitnessBackgroundSelectionScreen> {
  int? _selectedFitnessLevel; // Nullable to track selected fitness background

  // Define image paths (You can change these if necessary)
  final String newbieImagePath = 'lib/assets/newbie.png';
  final String competentImagePath = 'lib/assets/competent.png';
  final String expertImagePath = 'lib/assets/expert.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
             const SizedBox(height: 50),
              const Text(
                "Let's get to know \n you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 90), // Space between title and question
              const Text(
                'What is your fitness background?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 90), // Space between question and options

              // Images with fitness background options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFitnessLevelOption('Newbie', newbieImagePath, 0), // Use Newbie image
                    _buildFitnessLevelOption('Competent', competentImagePath, 1), // Use Competent image
                    _buildFitnessLevelOption('Expert', expertImagePath, 2), // Use Expert image
                  ],
                ),
              ),
              const SizedBox(height: 20), // Add space between body types and progress text
              const Text(
                "6/12",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold, // Make "5/12" bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20), // Add a small gap between the text and FAB
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
          // Conditionally show the "Next to Q7" button
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
                onPressed: () {
                  // Navigate to q7.dart when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Q7Screen(), // Navigate to Q7Screen
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

  // Widget for building each fitness background option with an image and label
  Widget _buildFitnessLevelOption(String label, String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection: if already selected, deselect; otherwise, select
          _selectedFitnessLevel = _selectedFitnessLevel == index ? null : index;
        });
      },
      child: Column(
        children: [
          // Image box itself is selectable
          Container(
            width: 125, // Fixed size for the image box (customizable)
            height: 125,
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
              width: 125,
              height: 125,
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

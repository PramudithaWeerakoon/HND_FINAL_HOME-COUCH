import 'package:flutter/material.dart';
import 'q6.dart'; 

class BodyTypeSelectionScreen extends StatefulWidget {
  const BodyTypeSelectionScreen({super.key});

  @override
  _BodyTypeSelectionScreenState createState() =>
      _BodyTypeSelectionScreenState();
}

class _BodyTypeSelectionScreenState extends State<BodyTypeSelectionScreen> {
  int? _selectedBodyType; // Nullable to track selected body type index

  // Define image paths
  final String skinnyImagePath = 'lib/assets/Skinny.png';
  final String skinnyFatImagePath = 'lib/assets/Skinny-Fat.png';
  final String heavyImagePath = 'lib/assets/Heavy.png';

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
                'How would you describe your body type?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 90), // Space between question and options

              // Images with body type options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBodyTypeOption('Skinny', skinnyImagePath, 0), // Use skinny image path
                    _buildBodyTypeOption('Skinny-Fat', skinnyFatImagePath, 1), // Use skinny-fat image path
                    _buildBodyTypeOption('Heavy', heavyImagePath, 2), // Use heavy image path
                  ],
                ),
              ),
              const SizedBox(height: 20), // Add space between body types and progress text
              const Text(
                "5/12",
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
              heroTag: 'back_to_q4', // Unique tag for the left FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to Q4
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          // Conditionally show the "Next to Q8" button
          if (_selectedBodyType != null)
            Positioned(
              right: 16, // Position the next button on the right
              bottom: 32, // Adjust bottom position as needed
              child: FloatingActionButton(
                heroTag: 'next_to_q6', // Unique tag for the right FAB
                 backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  // Navigate to q7.dart when clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FitnessBackgroundSelectionScreen()
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

  // Widget for building each body type option with an image and label
  Widget _buildBodyTypeOption(String label, String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection: if already selected, deselect; otherwise, select
          _selectedBodyType = _selectedBodyType == index ? null : index;
        });
      },
      child: Column(
        children: [
          // Image box itself is selectable
          Container(
            width: 125, // Fixed size for the image box (customizable)
            height: 125,
            decoration: BoxDecoration(
              color: _selectedBodyType == index
                  ? Colors.blueAccent.withOpacity(0.2)
                  : Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _selectedBodyType == index
                    ? const Color.fromARGB(255, 31, 10, 80)
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
              color: _selectedBodyType == index
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

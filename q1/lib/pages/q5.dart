import 'package:flutter/material.dart';
import 'q6.dart';
import 'db_connection.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
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
                'How would you describe your body type?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.1), // Space between question and options

              // Images with body type options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBodyTypeOption('Skinny', skinnyImagePath, 0, screenWidth), // Use skinny image path
                    _buildBodyTypeOption('Skinny-Fat', skinnyFatImagePath, 1, screenWidth), // Use skinny-fat image path
                    _buildBodyTypeOption('Heavy', heavyImagePath, 2, screenWidth), // Use heavy image path
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Add space between body types and progress text
              const Text(
                "5/12",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold, // Make "5/12" bold
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
                onPressed: () async {
                  try {
                    // Map the selected index to the corresponding body type
                    String bodyType = '';
                    if (_selectedBodyType == 0) {
                      bodyType = 'Skinny';
                    } else if (_selectedBodyType == 1) {
                      bodyType = 'Skinny-Fat';
                    } else if (_selectedBodyType == 2) {
                      bodyType = 'Heavy';
                    }

                    // Save the body type to the database
                    final dbConnection = DatabaseConnection();
                    await dbConnection.upsertBodyType(bodyType);

                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FitnessBackgroundSelectionScreen(),
                      ),
                    );
                  } catch (e) {
                    // Handle errors (e.g., show a snackbar or toast)
                    print("Error saving body type: $e");
                  }
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Widget for building each body type option with an image and label
  Widget _buildBodyTypeOption(String label, String imagePath, int index, double screenWidth) {
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
            width: screenWidth * 0.3, // Adjust size based on screen width
            height: screenWidth * 0.3,
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
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
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

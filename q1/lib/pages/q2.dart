import 'package:flutter/material.dart';
import 'q3.dart';

enum Gender { male, female }

class Q2Page extends StatefulWidget {
  const Q2Page({super.key});

  @override
  _Q2PageState createState() => _Q2PageState();
}

class _Q2PageState extends State<Q2Page> {
  Gender? selectedGender; // Track the selected gender

  void toggleGender(Gender gender) {
    setState(() {
      // Toggle the selected gender
      if (selectedGender == gender) {
        selectedGender = null; // Deselect if already selected
      } else {
        selectedGender = gender; // Select the new gender
      }
    });
  }

  void goBackToQ1() {
    // Handle the action to go back to Q1
    Navigator.pop(context);
  }

  void goToNextQuestion() {
    // Handle the action for going to the next question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center everything horizontally
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
              const SizedBox(height: 60), // Space between title and question
              const Text(
                'What is your gender?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600, // Bold the question
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Space between question and buttons

              // Gender buttons container
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderOptionButton(
                    imagePath: 'lib/assets/male.png',
                    label: 'Male',
                    isSelected: selectedGender == Gender.male,
                    onPressed: () => toggleGender(Gender.male), // Toggle male selection
                  ),
                  const SizedBox(height: 20), // Space between the buttons
                  GenderOptionButton(
                    imagePath: 'lib/assets/female.png',
                    label: 'Female',
                    isSelected: selectedGender == Gender.female,
                    onPressed: () => toggleGender(Gender.female), // Toggle female selection
                  ),
                ],
              ),
              const Spacer(), // This spacer will push the 2/12 text to the bottom
              const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the "2/12" text
                children: [
                  Text(
                    "2/12",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold, // Make "2/12" bold
                      color: Colors.black,
                    ),
                  ),
                ],
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
              heroTag: 'back_to_q1', // Unique tag for the left FAB
               backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: goBackToQ1,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          if (selectedGender != null) // Only show if a gender is selected
            Positioned(
              right: 16, // Position the next button on the right
              bottom: 32, // Adjust bottom position as needed
              child: FloatingActionButton(
                heroTag: 'next_question', // Unique tag for the right FAB
                 backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
            // Navigate to q2.dart when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeightInputScreen()),
            );
          },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
class GenderOptionButton extends StatelessWidget {
  final String imagePath; // New parameter for image path
  final String label;
  final bool isSelected; // Parameter to track selection
  final VoidCallback onPressed;

  const GenderOptionButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: label == 'Male'
              ? LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFE7EAFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFE7FE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(30), // Set curve to 30
          border: isSelected
              ? Border.all(color: label == 'Male' ? Color(0xFF21007E) : Color(0xFFD00A6A), width: 5)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: label == 'Male' ? Color(0xFF68A4FF).withOpacity(0.4) : Color(0xFFF263E9).withOpacity(0.4),
                    offset: Offset(0, 0), // Position x=0, y=0
                    blurRadius: 44, // Blur effect
                    spreadRadius: 4, // Spread effect
                  ),
                ]
              : [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.25), // Black with 25% opacity
                    offset: Offset(0, 0), // Position x=0, y=0
                    blurRadius: 4, // Blur effect for unselected state
                    spreadRadius: 0, // No spread effect for unselected state
                  ),
                ],
        ),
        child: SizedBox(
          width: 160, // Box width
          height: 160, // Box height
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 85, // Adjust image size as needed
                  height: 85,
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

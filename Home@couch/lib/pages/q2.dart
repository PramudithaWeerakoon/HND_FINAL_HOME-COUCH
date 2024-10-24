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
                    icon: Icons.male,
                    label: 'Male',
                    isSelected: selectedGender == Gender.male,
                    onPressed: () => toggleGender(Gender.male), // Toggle male selection
                  ),
                  const SizedBox(height: 20), // Space between the buttons
                  GenderOptionButton(
                    icon: Icons.female,
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
              backgroundColor: Colors.deepPurple,
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
                backgroundColor: Colors.deepPurple,
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
  final IconData icon;
  final String label;
  final bool isSelected; // New parameter to track selection
  final VoidCallback onPressed;

  const GenderOptionButton({super.key, 
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueAccent : Colors.blue, // Highlight if selected
        minimumSize: const Size(180, 180), // Set button size to 180x180
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected // Add border if selected
              ? const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2)
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

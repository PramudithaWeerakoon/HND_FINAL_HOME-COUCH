import 'package:flutter/material.dart';
import 'q3.dart'; // Assuming this is the next page after gender selection
import 'database_helper.dart'; // Import your DatabaseHelper for DB operations

enum Gender { male, female }

class Q2Page extends StatefulWidget {
  final String currentUserEmail; // Expect email as a named parameter

  const Q2Page({super.key, required this.currentUserEmail});

  @override
  _Q2PageState createState() => _Q2PageState();
}


class _Q2PageState extends State<Q2Page> {
  Gender? selectedGender; // Track the selected gender
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Function to toggle the gender selection
  void toggleGender(Gender gender) {
    setState(() {
      if (selectedGender == gender) {
        selectedGender = null; // Deselect if already selected
      } else {
        selectedGender = gender; // Select the new gender
      }
    });
  }

  // Go back to the previous page (Q1)
  void goBackToQ1() {
    Navigator.pop(context);
  }

  // Function to navigate to the next question page
  void goToNextQuestion() async {
    if (selectedGender != null) {
      String genderStr = selectedGender == Gender.male ? 'Male' : 'Female';

      try {
        // Save the selected gender to the database
        await dbHelper.saveUserGender(
            widget.currentUserEmail, genderStr); // Pass the email and gender

        // Navigate to the next question
        
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const WeightInputScreen()), // Replace with actual next screen
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save gender: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a gender")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(height: 60),
              const Text(
                'What is your gender?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // Gender buttons container
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderOptionButton(
                    imagePath: 'lib/assets/male.png',
                    label: 'Male',
                    isSelected: selectedGender == Gender.male,
                    onPressed: () => toggleGender(Gender.male),
                  ),
                  const SizedBox(height: 20),
                  GenderOptionButton(
                    imagePath: 'lib/assets/female.png',
                    label: 'Female',
                    isSelected: selectedGender == Gender.female,
                    onPressed: () => toggleGender(Gender.female),
                  ),
                ],
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2/12",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 32,
            child: FloatingActionButton(
              heroTag: 'back_to_q1',
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
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next_question',
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: goToNextQuestion,
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
          borderRadius: BorderRadius.circular(30),
          border: isSelected
              ? Border.all(
                  color:
                      label == 'Male' ? Color(0xFF21007E) : Color(0xFFD00A6A),
                  width: 5)
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: label == 'Male'
                        ? Color(0xFF68A4FF).withOpacity(0.4)
                        : Color(0xFFF263E9).withOpacity(0.4),
                    offset: Offset(0, 0),
                    blurRadius: 44,
                    spreadRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.25),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: SizedBox(
          width: 160,
          height: 160,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 85,
                  height: 85,
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

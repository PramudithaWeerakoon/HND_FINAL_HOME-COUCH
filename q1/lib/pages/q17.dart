import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q18.dart'; // Import Q18Screen
import 'db_connection.dart';

class Q17Screen extends StatefulWidget {
  const Q17Screen({super.key});

  @override
  _Q17ScreenState createState() => _Q17ScreenState();
}

class _Q17ScreenState extends State<Q17Screen> {
  final TextEditingController _weightController = TextEditingController();
  bool isKgSelected = true; // Track the unit selection
  bool hasNoTargetWeight = false; // Track if checkbox is selected

  @override
  void initState() {
    super.initState();
    _weightController.text = '62'; // Default value
    // Automatically update as the user types
    _weightController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill horizontally
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
              const SizedBox(height: 50), // Space between title and question
              const Center( // Centering the question text
                child: Text(
                  'Have you got a target weight\n  going to achieve?',
                    textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500, // Bold the question
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 80), // Space between question and input field
              
              // Weight Input with editable Text
              Center(
                child: Column(
                  children: [
                    // Editable weight input
                    SizedBox(
                      width: 150, // Control the width for the input
                      child: TextField(
                        controller: _weightController,
                        enabled: !hasNoTargetWeight, // Disable when checkbox is selected
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none, // No visible border
                        ),
                      ),
                    ),
                    // Smaller black line under the input
                    const SizedBox(
                      width: 190, // Set a smaller width for the black line
                      child: Divider(
                        color: Colors.black,
                        thickness: 2, // Thickness of the black line
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10), // Space between weight and unit toggle

              // Unit selection: KG or LB
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isKgSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isKgSelected ? const Color(0xFFEAB804) : Colors.white,
                        foregroundColor: isKgSelected ? Colors.black : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('KG'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isKgSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isKgSelected ? Colors.white : const Color(0xFFB30000),
                        foregroundColor: isKgSelected ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('LB'),
                    ),
                  ],
                ),
              ),

              const Spacer(), // Push the checkbox to the bottom

              // Checkbox with text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: hasNoTargetWeight,
                    onChanged: (bool? value) {
                      setState(() {
                        hasNoTargetWeight = value ?? false;
                        if (hasNoTargetWeight) {
                          _weightController.clear(); // Clear weight input when unchecked
                        }
                      });
                    },
                  ),
                  const Text(
                    "I don't have a specific target weight",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
                const SizedBox(height: 90), // Space between checkbox and buttons
              
            ],
          ),
        ),
      ),
      
      // Floating action buttons for navigation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          // Back button
          Positioned(
            left: 16, // Left position for the back button
            bottom: 32, // Bottom position for alignment
            child: FloatingActionButton(
              heroTag: 'back_to_q15', // Unique tag for FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          
          // Next button
          Positioned(
            right: 16, // Right position for the next button
            bottom: 32, // Bottom position for alignment
            child: FloatingActionButton(
              heroTag: 'next_to_q4', // Unique tag for FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () async {
                double targetWeightInKg = double.parse(
                    _weightController.text); // Get the target weight from input

                if (!hasNoTargetWeight) {
                  // Save the target weight to the database
                  DatabaseConnection db = DatabaseConnection();
                  await db.saveTargetWeightToDatabase(targetWeightInKg);
                }

                // Navigate to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectDate(), // Navigate to Q18
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
}

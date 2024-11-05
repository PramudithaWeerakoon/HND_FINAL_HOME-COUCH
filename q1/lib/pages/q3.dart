import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q4.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  _WeightInputScreenState createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  bool isKgSelected = true; // Track the unit selection

  @override
  void initState() {
    super.initState();
    _weightController.text = '70.8'; // Default value
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
                "Let's get to know \n you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Space between title and question
              const Center( // Centering the question text
                child: Text(
                  'What is your weight?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600, // Bold the question
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
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          fontSize: 70,
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
                      width: 130, // Set a smaller width for the black line
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
                        backgroundColor: isKgSelected ? const Color(0xFFB30000) : Colors.white,
                        foregroundColor: isKgSelected ? Colors.white : Colors.black,
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

              const Spacer(), // Push the 3/12 text to the bottom

              const Center(
                child: Text(
                  "3/12",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Small gap between text and FAB
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
              heroTag: 'back_to_q2', // Unique tag for FAB
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
              onPressed: () {
                // Navigate to q4.dart when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (consds3text) => const Q4Page()),
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

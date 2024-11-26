import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q5.dart';
import 'db_connection.dart';

class Q4Page extends StatefulWidget {
  const Q4Page({super.key});

  @override
  _Q4PageState createState() => _Q4PageState();
}

class _Q4PageState extends State<Q4Page> {
  final TextEditingController _heightController = TextEditingController();
  bool isMSelected = true; // Track the unit selection for height

  @override
  void initState() {
    super.initState();
    _heightController.text = '1.75'; // Default height in meters
    // Automatically update as the user types
    _heightController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

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
            mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill horizontally
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
              SizedBox(height: screenHeight * 0.04), // Space between title and question
              const Center( // Centering the question text
                child: Text(
                  'What is your height?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600, // Bold the question
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08), // Space between question and input field
              
              // Height Input with editable Text
              Center(
                child: Column(
                  children: [
                    // Editable height input
                    SizedBox(
                      width: screenWidth * 0.4, // Control the width for the input
                      child: TextField(
                        controller: _heightController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimals
                        style: TextStyle(
                          fontSize: screenWidth * 0.15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none, // No visible border
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')), // Only allow numbers and decimal
                        ],
                      ),
                    ),
                    // Smaller black line under the input
                    SizedBox(
                      width: screenWidth * 0.35, // Set a smaller width for the black line
                      child: const Divider(
                        color: Colors.black,
                        thickness: 2, // Thickness of the black line
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.01), // Space between height and unit toggle

              // Unit selection: Meters (M) or Feet (FT)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isMSelected = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMSelected ? const Color(0xFFB30000) : Colors.white, // Use #B30000 for selected red
                        foregroundColor: isMSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('M'),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isMSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMSelected ? Colors.white : const Color(0xFFB30000),
                        foregroundColor: isMSelected ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('FT'),
                    ),
                  ],
                ),
              ),

              const Spacer(), // Push the 4/12 text to the bottom

              const Center(
                child: Text(
                  "4/12",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Small gap between text and FAB
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
              heroTag: 'back_to_q3', // Unique tag for FAB
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
              heroTag: 'next_to_q5', // Unique tag for FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
             onPressed: () async {
                try {
                  // Ensure the current user is logged in
                  final email = SessionManager.getUserEmail();
                  if (email == null) {
                    throw Exception("No user is currently logged in.");
                  }

                  // Parse the height input
                  final String heightText = _heightController.text;
                  final double height = double.parse(heightText);

                  // Save the height to the database
                  final dbConnection = DatabaseConnection();
                  await dbConnection.updateHeight(
                      height, !isMSelected); // Convert only if not in meters

                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BodyTypeSelectionScreen()),
                  );
                } catch (e) {
                  // Handle errors (e.g., show a toast or snackbar)
                  print("Error saving height: $e");
                }
              },


              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for FilteringTextInputFormatter
import 'q9.dart'; // Import the Q9 screen
import 'db_connection.dart'; // Import the database connection

class Q8Screen extends StatefulWidget {
  const Q8Screen({super.key});

  @override
  _Q8ScreenState createState() => _Q8ScreenState();
}

class _Q8ScreenState extends State<Q8Screen> {
  final TextEditingController _neckController = TextEditingController();
  bool isCm = true; // Variable to track if in cm (true) or inches (false)

  @override
  void initState() {
    super.initState();
    _neckController.text = '37'; // Default value for neck circumference
    // Add listener to update the value as the user types
    _neckController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _neckController.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  // Method to handle saving neck circumference and navigating to Q9Screen
  void saveAndNavigate() async {
    double currentNeck = double.tryParse(_neckController.text) ?? 37.0;

    // Convert neck circumference to inches if the unit is in cm
    if (isCm) {
      currentNeck = currentNeck / 2.54; // Convert cm to inches
    }

    // Save neck circumference to the database
    final dbConnection = DatabaseConnection();
    await dbConnection.saveNeckCircumferenceToDB(currentNeck);

    // Navigate to the next screen (Q9Screen)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Q9Screen(), // Navigate to Q9Screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Let's get to know \n you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                "What's the circumference of your neck?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.08),

              // Display and allow user to input the neck circumference
              TextField(
                controller: _neckController, // Use the controller
                keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.175,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow only numbers and decimal points
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none, // No border around input
                ),
              ),
              SizedBox(height: screenHeight * 0.014),

              // Horizontal line
              Container(
                height: 2, // Changed thickness to 2
                width: screenWidth * 0.33,
                color: Colors.black,
              ),
              SizedBox(height: screenHeight * 0.016),

              // Toggle between cm and inches
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnitButton("cm", isCm, screenWidth), // cm button
                  SizedBox(width: screenWidth * 0.025),
                  _buildUnitButton("in", !isCm, screenWidth), // inch button
                ],
              ),
              const Spacer(),

              // Page Indicator
              Text(
                "8/12",
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: screenWidth * 0.04, // Position the back button on the left
            bottom: screenHeight * 0.04, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'back_to_q7', // Unique tag for the left FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to previous question (Q7)
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: screenWidth * 0.04, // Position the next button on the right
            bottom: screenHeight * 0.04, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'next_to_q9', // Unique tag for the right FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                saveAndNavigate(); // Call the method to save and navigate
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the cm/in buttons
  Widget _buildUnitButton(String label, bool isActive, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCm = (label == "cm");
          _neckController.text = isCm
              ? '37'
              : (37 / 2.54).toStringAsFixed(2); // Convert to inches or cm
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEAB804) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

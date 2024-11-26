import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package for input formatters
import 'q8.dart'; // Import Q8Screen
import 'db_connection.dart'; // Import the DatabaseConnection class

class Q7Screen extends StatefulWidget {
  const Q7Screen({super.key});

  @override
  _Q7ScreenState createState() => _Q7ScreenState();
}

class _Q7ScreenState extends State<Q7Screen> {
  final TextEditingController _waistController = TextEditingController();
  bool isCm = true; // Variable to track if in cm (true) or inches (false)

  @override
  void initState() {
    super.initState();
    _waistController.text = '85'; // Default value
    // Automatically update as the user types
    _waistController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _waistController.dispose();
    super.dispose();
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
                "What's the circumference of your waist?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.08),

              // Editable waist input field
              TextField(
                controller: _waistController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow numbers and one decimal
                ],
                style: TextStyle(
                  fontSize: screenWidth * 0.15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none, // No visible border
                ),
              ),
              SizedBox(height: screenHeight * 0.014),

              // Horizontal line
              Container(
                height: 2, // Thickness of the line
                width: screenWidth * 0.35,
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
                "7/12",
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
              heroTag: 'back_to_q6', // Unique tag for the left FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to previous question (Q6)
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: screenWidth * 0.04, // Position the next button on the right
            bottom: screenHeight * 0.04, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'next_to_q8', // Unique tag for the right FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () async {
                double currentWaist =
                    double.tryParse(_waistController.text) ?? 85.0;

                // Convert waist circumference to inches if the unit is in cm
                if (isCm) {
                  currentWaist = currentWaist / 2.54; // Convert cm to inches
                }

                // Save waist circumference to the database
                final dbConnection = DatabaseConnection();
                await dbConnection.saveWaistCircumferenceToDB(currentWaist);

                // Navigate to the next screen (Q8Screen)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Q8Screen(), // Navigate to Q8Screen
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

  // Helper method to create the cm/in buttons
  Widget _buildUnitButton(String label, bool isActive, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCm = (label == "cm");
          double currentWaist = double.tryParse(_waistController.text) ?? 85.0;
          // Convert to inches or cm based on selection
          _waistController.text = isCm
              ? (currentWaist * 2.54).toStringAsFixed(1)
              : (currentWaist / 2.54).toStringAsFixed(1);
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

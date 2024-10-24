import 'package:flutter/material.dart';
import 'q9.dart'; // Import the Q9 screen

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
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
              const SizedBox(height: 40),
              const Text(
                "What's the circumference of your neck?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),

              // Display and allow user to input the neck circumference
              TextField(
                controller: _neckController, // Use the controller
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none, // No border around input
                ),
              ),
              const SizedBox(height: 14),

              // Horizontal line
              Container(
                height: 2, // Changed thickness to 2
                width: 130,
                color: Colors.black,
              ),
              const SizedBox(height: 16),

              // Toggle between cm and inches
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnitButton("cm", isCm), // cm button
                  const SizedBox(width: 10),
                  _buildUnitButton("in", !isCm), // inch button
                ],
              ),
              const Spacer(),

              // Page Indicator
              const Text(
                "8/12",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
            left: 16, // Position the back button on the left
            bottom: 32, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'back_to_q7', // Unique tag for the left FAB
              backgroundColor: Colors.deepPurple,
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
            right: 16, // Position the next button on the right
            bottom: 32, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'next_to_q9', // Unique tag for the right FAB
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle next screen navigation (Q9)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Q9Screen()),
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
  Widget _buildUnitButton(String label, bool isActive) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

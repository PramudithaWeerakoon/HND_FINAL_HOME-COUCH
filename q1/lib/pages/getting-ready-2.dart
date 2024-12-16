import 'package:flutter/material.dart';
import 'package:q1/pages/getting-ready-1.dart';
import 'package:q1/pages/getting-ready-3.dart';
import 'package:q1/widgets/gradient_background.dart'; // Import the gradient background component

class GettingReadyPage2 extends StatelessWidget {
  const GettingReadyPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color

      // Floating action buttons for navigation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          // Back button
          Positioned(
            left: 16, // Position on the left
            bottom: 32, // Position at the bottom
            child: FloatingActionButton(
              heroTag: 'back_button', // Unique tag for FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GettingReadyPage()),
                );
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          
          // Next button
          Positioned(
            right: 16, // Position on the right
            bottom: 32, // Position at the bottom
            child: FloatingActionButton(
              heroTag: 'next_button', // Unique tag for FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GettingReadyPage3()), // Replace NextPage with your next screen
                );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
      
      body:GradientBackground(
        child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with Inter font
              const Text(
                "Getting Ready!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              
              const SizedBox(height: 50), // Gap between title and label

              // Stack for overlaying the label on the image
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // Image container with rounded corners
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('lib/assets/step2.jpeg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // "Position The Phone" label
                  Positioned(
                    top: -25, // Adjust this value to control overlap
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 179, 0, 0), // Change to red background
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Position The Phone',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20), // Space between image and instruction text

              // Instruction text with Inter font and italic style
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Place your phone facing towards you, ensuring nothing is blocking the camera's view.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      )
      )
    );
  }
}

    
        
 
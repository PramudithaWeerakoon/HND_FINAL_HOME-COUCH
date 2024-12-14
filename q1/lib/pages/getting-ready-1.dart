import 'package:flutter/material.dart';
import 'package:q1/pages/getting-ready-2.dart';
import 'package:q1/widgets/gradient_background.dart'; // Import the gradient background component


class GettingReadyPage extends StatelessWidget {
  const GettingReadyPage({super.key});

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
                Navigator.pop(context);
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
                  MaterialPageRoute(builder: (context) => const GettingReadyPage2()), // Replace NextPage with your next screen
                );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
      
      body: GradientBackground( // Use the gradient background component
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
                
                const SizedBox(height: 60), // Gap between title and label

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
                          image: AssetImage('lib/assets/gettingready.jpeg'), // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // "Find a clear space" label
                    Positioned(
                      top: -25, // Adjust this value to control overlap
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21007E),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Find a clear space',
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
                    "Make sure you have enough room to move freely for your workout.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

     
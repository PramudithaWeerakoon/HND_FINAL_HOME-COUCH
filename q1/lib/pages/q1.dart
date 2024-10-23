import 'package:flutter/material.dart';
import 'q2.dart'; // Import the q2.dart page

class Q1Page extends StatefulWidget {
  const Q1Page({super.key});

  @override
  _Q1PageState createState() => _Q1PageState();
}

class _Q1PageState extends State<Q1Page> {
  int selectedItemIndex = 0; // Start with the initial index for age 10

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
              const Text(
                "Let's get to know you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 60), // Space between title and question
              const Text(
                "How old are you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600, // Bold "How old are you?"
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40), // Space between question and picker
              Stack(
                alignment: Alignment.center,
                children: [
                  // The horizontal lines
                  const Positioned(
                    top: 45,
                    left: 100,
                    right: 100,
                    child: Divider(
                      thickness: 2,
                      color: Colors.black, // Color of the top line
                    ),
                  ),
                  const Positioned(
                    bottom: 45,
                    left: 100,
                    right: 100,
                    child: Divider(
                      thickness: 2,
                      color: Colors.black, // Color of the bottom line
                    ),
                  ),
                  // Blue rectangle highlight for the selected item
                  Positioned(
                    top: 55, // Adjust to align with the selected number
                    left: 100,
                    right: 100,
                    child: Container(
                      height: 40, // Should fit exactly the selected item
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 152, 201, 241),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // The scrollable picker
                  Center(
                    child: SizedBox(
                      height: 150, // Set height to show 3 numbers
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50, // Height of each item
                        physics: const FixedExtentScrollPhysics(),
                        perspective: 0.005, // Slight 3D effect
                        onSelectedItemChanged: (index) {
                          // Dynamically change the selected item
                          setState(() {
                            selectedItemIndex = index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            // Limit the scroll to values between 10 and 80
                            if (index < 0 || index > (80 - 10)) return null;
                            return Center(
                              child: Text(
                                (10 + index).toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: selectedItemIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(), // This spacer will take up space, pushing the following content to the bottom
              const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the "1/12" text
                children: [
                  Text(
                    "1/12",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold, // Make "1/12" bold
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
            // Navigate using named route to q2 page
            Navigator.pushNamed(context, '/question2');
          },
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'db_connection.dart';

class Q1Page extends StatefulWidget {
  const Q1Page({super.key});

  @override
  _Q1PageState createState() => _Q1PageState();
}

class _Q1PageState extends State<Q1Page> {
  int selectedItemIndex = 0; // Start with the initial index for age 10
  final DatabaseConnection _dbConnection = DatabaseConnection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center everything vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center everything horizontally
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the "1/12" text
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
              const SizedBox(
                  height: 20), // Add a small gap between the text and FAB
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: const Color(0xFF21007E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            final age = 10 + selectedItemIndex; // Get the selected age
            final email = SessionManager.getUserEmail(); // Get the logged-in email

            if (email != null) {
              try {
                // Save age to database
                await _dbConnection.updateAge(age);
                // Navigate to the next page
                Navigator.pushNamed(context, '/question2');
              } catch (e) {
                // Handle database errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error saving age: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
              // Show error if no user is logged in
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No logged-in user found.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}

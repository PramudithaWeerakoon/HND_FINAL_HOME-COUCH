import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper
import 'user.dart'; // Import the User model if you have one
import 'q2.dart'; // Import the Q2Page class

class Q1Page extends StatefulWidget {
  final String
      userEmail; // Declare a field to accept email passed from the previous page

  const Q1Page({Key? key, required this.userEmail}) : super(key: key);

  @override
  _Q1PageState createState() => _Q1PageState();
}

class _Q1PageState extends State<Q1Page> {
  int selectedItemIndex = 0; // Start with the initial index for age 10
  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Instance of the database helper
  late String currentUserEmail; // Local variable for the email

  @override
  void initState() {
    super.initState();
    // Initialize the current user's email by passing the value from the widget
    currentUserEmail = widget.userEmail;
    // Print the email to the terminal when the page is initialized
    print("User Email: $currentUserEmail");
  }

  // Save the selected age to the database
  Future<void> _saveUserAge() async {
    int selectedAge = 10 +
        selectedItemIndex; // Convert index to actual age (starting from 10)
    try {
      await dbHelper.updateUserAge(
          currentUserEmail, selectedAge); // Update the age in the database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Age saved successfully: $selectedAge")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save age: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.05;
    final double titleFontSize = size.width * 0.1;
    final double questionFontSize = size.width * 0.075;
    final double numberFontSize = size.width * 0.075;
    final double stepFontSize = size.width * 0.07;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center everything vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center everything horizontally
            children: [
              SizedBox(height: size.height * 0.05),
              Text(
                "Let's get to know \n you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                  height:
                      size.height * 0.06), // Space between title and question
              Text(
                "How old are you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: questionFontSize,
                  fontWeight: FontWeight.w600, // Bold "How old are you?"
                  color: Colors.black,
                ),
              ),
              SizedBox(
                  height:
                      size.height * 0.04), // Space between question and picker
              Stack(
                alignment: Alignment.center,
                children: [
                  // The horizontal lines
                  Positioned(
                    top: size.height * 0.045,
                    left: size.width * 0.25,
                    right: size.width * 0.25,
                    child: Divider(
                      thickness: 2,
                      color: Colors.black, // Color of the top line
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.045,
                    left: size.width * 0.25,
                    right: size.width * 0.25,
                    child: Divider(
                      thickness: 2,
                      color: Colors.black, // Color of the bottom line
                    ),
                  ),
                  // Blue rectangle highlight for the selected item
                  Positioned(
                    top: size.height *
                        0.055, // Adjust to align with the selected number
                    left: size.width * 0.25,
                    right: size.width * 0.25,
                    child: Container(
                      height: size.height *
                          0.04, // Should fit exactly the selected item
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 152, 201, 241),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // The scrollable picker
                  Center(
                    child: SizedBox(
                      height:
                          size.height * 0.15, // Set height to show 3 numbers
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: size.height * 0.05, // Height of each item
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
                                (10 + index)
                                    .toString(), // Convert int to String
                                style: TextStyle(
                                  fontSize: numberFontSize,
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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the "1/12" text
                children: [
                  Text(
                    "1/12",
                    style: TextStyle(
                      fontSize: stepFontSize,
                      fontWeight: FontWeight.bold, // Make "1/12" bold
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: size.height *
                      0.02), // Add a small gap between the text and FAB
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
            await _saveUserAge(); // Save age to database

            // Print current user's information to the terminal
            await dbHelper.printUserInfo(currentUserEmail);

           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Q2Page(
                  currentUserEmail:
                      currentUserEmail, // Passing email correctly as named parameter
                ),
              ),
            );

          },
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'q10.dart'; // Import q10.dart

class Q9Screen extends StatefulWidget {
  const Q9Screen({super.key});

  @override
  _Q9ScreenState createState() => _Q9ScreenState();
}

class _Q9ScreenState extends State<Q9Screen> {
  String selectedInjury = 'None'; // Default selected injury option

  final List<String> injuryOptions = [
    'Minor Knee Injury',
    'Recovered from Injury',
    'Lower Back Pain',
    'Past Shoulder Injury',
    'Other',
    'None',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                "Do you have any injuries?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // List of Injury Options
              Expanded(
                child: ListView.builder(
                  itemCount: injuryOptions.length,
                  itemBuilder: (context, index) {
                    final injury = injuryOptions[index];
                    final bool isSelected = selectedInjury == injury;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedInjury = injury;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                                ? const Color(0xFFB30000)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          injury,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator
              const Text(
                "9/12",
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
              heroTag: 'back_to_q8', // Unique tag for the left FAB
               backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to previous question (Q8)
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: 16, // Position the next button on the right
            bottom: 32, // Adjust bottom position as needed
            child: FloatingActionButton(
              heroTag: 'next_to_q10', // Unique tag for the right FAB
               backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle next screen navigation (Q10)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Q10Screen()),
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

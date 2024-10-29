import 'package:flutter/material.dart';
import 'q11.dart'; // Import q11.dart

class Q10Screen extends StatefulWidget {
  const Q10Screen({super.key});

  @override
  _Q10ScreenState createState() => _Q10ScreenState();
}

class _Q10ScreenState extends State<Q10Screen> {
  List<String> equipment = ['Dumbbell', 'Barbell', 'Kettlebell', 'Fitness Bench', 'Skipping Rope'];
  String selectedEquipment = '';

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
                "What equipment have you got?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // Displaying equipment options
              Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: equipment.length,
                  itemBuilder: (context, index) {
                    String currentItem = equipment[index];
                    bool isSelected = selectedEquipment == currentItem; // Check if the item is selected

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedEquipment = ''; // Unselect if already selected
                          } else {
                            selectedEquipment = currentItem; // Select the current item
                          }
                        });
                      },
                      child: Stack( // Use Stack to position the tick icon
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.grey[300] : Colors.white,
                              border: Border.all(
                                color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Placeholder for blank image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200], // Grey placeholder
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    currentItem,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Add tick icon if selected
                          if (isSelected) // Show tick icon only if selected
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),

              // Page Indicator
              const Text(
                "10/12",
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
              heroTag: 'back_to_q9', // Unique tag for the left FAB
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to the previous question (Q9)
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: 16, // Position the next button on the right
            bottom: 32, // Adjust bottom position as needed

            // Using Visibility to show/hide the next button based on whether an item is selected
            child: Visibility(
              visible: selectedEquipment.isNotEmpty, // Show only if an item is selected
              child: FloatingActionButton(
                heroTag: 'next_to_q11', // Unique tag for the right FAB
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  // Handle moving to the next question (Q11)
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const DumbbellSelectionScreen()));
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'q11.dart'; // Import Q11
import 'q12.dart'; // Import Q12

class Q10Screen extends StatefulWidget {
  const Q10Screen({super.key});

  @override
  _Q10ScreenState createState() => _Q10ScreenState();
}

class _Q10ScreenState extends State<Q10Screen> {
  List<String> equipment = ['Dumbbell', 'Barbell', 'Kettlebell', 'Fitness Bench', 'Skipping Rope', 'No Equipment'];
  Set<String> selectedEquipment = {}; // Use a Set for multiple selections

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
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: equipment.length,
                  itemBuilder: (context, index) {
                    String currentItem = equipment[index];
                    bool isSelected = selectedEquipment.contains(currentItem);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentItem == 'No Equipment') {
                            // Clear all selected equipment and select "No Equipment"
                            selectedEquipment.clear();
                            selectedEquipment.add(currentItem);
                          } else {
                            if (selectedEquipment.contains('No Equipment')) {
                              // Remove "No Equipment" if any other item is selected
                              selectedEquipment.remove('No Equipment');
                            }
                            if (isSelected) {
                              selectedEquipment.remove(currentItem); // Unselect if already selected
                            } else {
                              selectedEquipment.add(currentItem); // Select the current item
                            }
                          }
                        });
                      },
                      child: Stack(
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
                                  Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: currentItem == 'No Equipment'
                                        ? const Icon(
                                            Icons.close,
                                            size: 50,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    currentItem,
                                    textAlign: TextAlign.center,
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
                          if (isSelected)
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
            left: 16,
            bottom: 32,
            child: FloatingActionButton(
              heroTag: 'back_to_q9',
              backgroundColor: const Color(0xFF21007E),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 32,
            child: Visibility(
              visible: selectedEquipment.isNotEmpty,
              child: FloatingActionButton(
                heroTag: 'next_to_next',
                backgroundColor: const Color(0xFF21007E),
                onPressed: () {
                  if (selectedEquipment.contains('No Equipment')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Q12Screen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DumbbellSelectionScreen()),
                    );
                  }
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

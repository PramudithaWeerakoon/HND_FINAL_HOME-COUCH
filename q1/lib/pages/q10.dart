import 'package:flutter/material.dart';
import 'package:q1/pages/db_connection.dart';
import 'q11.dart'; // Import Q11
import 'q12.dart'; // Import Q12

class Q10Screen extends StatefulWidget {
  const Q10Screen({super.key});

  @override
  _Q10ScreenState createState() => _Q10ScreenState();
}

class _Q10ScreenState extends State<Q10Screen> {
  final List<String> equipment = [
    'Dumbbell',
    'Barbell',
    'Kettlebell',
    'Fitness Bench',
    'Skipping Rope',
    'No Equipment'
  ];

  // Map linking equipment to their image paths
  final Map<String, String> equipmentImages = {
    'Dumbbell': 'assets/dumbbell.png', // Replace with your asset path
    'Barbell': 'assets/barbell.png',
    'Kettlebell': 'assets/kettlebell.png',
    'Fitness Bench': 'assets/fitness_bench.png',
    'Skipping Rope': 'assets/skipping_rope.png',
    'No Equipment': 'assets/no_equipment.png', // Or use an icon if needed
  };

  Set<String> selectedEquipment = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    const SizedBox(height: 30),
                    const Text(
                      "What equipment have you got?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: equipment.length,
                      itemBuilder: (context, index) {
                        final currentItem = equipment[index];
                        final isSelected =
                            selectedEquipment.contains(currentItem);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (currentItem == 'No Equipment') {
                                selectedEquipment.clear();
                                selectedEquipment.add(currentItem);
                              } else {
                                selectedEquipment.remove('No Equipment');
                                isSelected
                                    ? selectedEquipment.remove(currentItem)
                                    : selectedEquipment.add(currentItem);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey[300]
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Add the image instead of the icon
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      equipmentImages[currentItem] ??
                                          'assets/images/placeholder.png', // Fallback image
                                      fit: BoxFit.contain,
                                    ),
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
                        );
                      },
                    ),
                    const SizedBox(height: 80), // Added space to avoid overlap
                  ],
                ),
              ),
            ),
            // Page Number Positioned at the Bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: const Text(
                  "10/12",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
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
                heroTag: 'next_to_q11',
                backgroundColor: const Color(0xFF21007E),
                onPressed: () async {
                  if (isLoading) return;
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    final db = DatabaseConnection();

                    if (selectedEquipment.contains('No Equipment')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Q12Screen()),
                      );
                    } else if (selectedEquipment.any((item) =>
                        item == 'Dumbbell' ||
                        item == 'Barbell' ||
                        item == 'Kettlebell')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DumbbellSelectionScreen(
                              selectedEquipment: selectedEquipment),
                        ),
                      );
                    } else {
                      await db.insertMultipleOtherEquipmentFixed(
                          selectedEquipment);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Q12Screen()),
                      );
                    }
                  } catch (e) {
                    print("Error: $e");
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

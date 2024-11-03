import 'package:flutter/material.dart';
import 'q12.dart';

class DumbbellSelectionScreen extends StatefulWidget {
  const DumbbellSelectionScreen({super.key});

  @override
  _DumbbellSelectionScreenState createState() =>
      _DumbbellSelectionScreenState();
}

class _DumbbellSelectionScreenState extends State<DumbbellSelectionScreen> {
  String selectedDumbbellType = 'Fixed'; // Default selected dumbbell type
  double? _selectedFixedDumbbell; // Selected fixed dumbbell
  final Map<double, int> _platedDumbbellCount = {}; // Plated dumbbell map

  final List<double> fixedDumbbellOptions = [
    1, 3, 5, 7, 10, 12, 15, 20
  ]; // Fixed dumbbell options
  final List<double> _selectedFixedDumbbells = [];


  final List<double> platedDumbbellOptions = [
    1, 2.5, 5, 10, 20
  ]; // Plated dumbbell plate options

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
                "Which type of dumbbell do you have?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Toggle between Fixed and Plated dumbbells
              Container(
            margin: const EdgeInsets.symmetric(horizontal: 10), // Adds horizontal margin
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDumbbellType = 'Fixed';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: selectedDumbbellType == 'Fixed'
                                ? const Color(0xFFB30000) // Red for selected
                                : Colors.grey[200], // Light grey for unselected
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.zero, // No radius on the right for Fixed
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Fixed',
                              style: TextStyle(
                                fontSize: 20,
                                color: selectedDumbbellType == 'Fixed'
                                    ? Colors.white // White text on red background
                                    : Colors.black, // Black text on light grey
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDumbbellType = 'Plated';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: selectedDumbbellType == 'Plated'
                                ? const Color(0xFFB30000) // Red for selected
                                : Colors.grey[200], // Light grey for unselected
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.zero, // No radius on the left for Plated
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Plated',
                              style: TextStyle(
                                fontSize: 20,
                                color: selectedDumbbellType == 'Plated'
                                    ? Colors.white // White text on red background
                                    : Colors.black, // Black text on light grey
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Underline Divider
                Container(
                  height: 2,
                  color: Colors.black,
                ),
              ],
            ),
          ),


              const SizedBox(height: 20),

              // Render based on selected dumbbell type
              if (selectedDumbbellType == 'Fixed') _buildFixedDumbbellOptions(),
              if (selectedDumbbellType == 'Plated') _buildPlatedDumbbellOptions(),

              const Spacer(),

              // Page Indicator
              const Text(
                "11/12",
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
              heroTag: 'back_to_q10',
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
          Positioned(
            right: 16,
            bottom: 32,
            child: FloatingActionButton(
              heroTag: 'next_to_q12',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                  // Handle moving to the next question (Q12)
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Q12Screen()));
                },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Fixed Dumbbell Selection
  // Widget for Fixed Dumbbell Selection (now allows multiple selections)
// Widget for Fixed Dumbbell Selection (single selection)
Widget _buildFixedDumbbellOptions() {
  return Expanded(
    child: GridView.builder(
      itemCount: fixedDumbbellOptions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 5,
      ),
      itemBuilder: (context, index) {
        final dumbbell = fixedDumbbellOptions[index];
        final bool isSelected = _selectedFixedDumbbell == dumbbell; // Single selection

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFixedDumbbell = dumbbell; // Update the selected weight
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 231, 216, 4) : Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              '${dumbbell.toInt()} kg', // Display as integer (e.g., "5 kg")
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: isSelected ? Colors.black : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
  );
}

// Widget for Plated Dumbbell Selection
// Widget for Plated Dumbbell Selection
// Widget for Plated Dumbbell Selection
// Widget for Plated Dumbbell Selection
Widget _buildPlatedDumbbellOptions() {
  return Expanded(
    child: ListView.builder(
      itemCount: platedDumbbellOptions.length,
      itemBuilder: (context, index) {
        final plateWeight = platedDumbbellOptions[index];
        final plateCount = _platedDumbbellCount[plateWeight] ?? 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Plate Weight Text with a fixed width
              SizedBox(
                width: 130, // Adjusted width to fit all options
                child: Text(
                  '${plateWeight.toInt()} Kg Plates',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Space between weight text and 'x'
              const SizedBox(width: 30),  // Adjust space as needed
              
              // Multiplier 'x' with fixed width
              const SizedBox(
                width: 80, // Consistent width for alignment
                child: Text(
                  'x',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              // Space between 'x' and quantity box
              const SizedBox(width: 30), // Adjust space as needed

              // Move the quantity box to the end using Expanded widget
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 160,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        plateCount.toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}




}

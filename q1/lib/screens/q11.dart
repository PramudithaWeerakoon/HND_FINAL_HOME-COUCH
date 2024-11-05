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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDumbbellType = 'Fixed';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectedDumbbellType == 'Fixed'
                            ? const Color(0xFFB30000)
                            : Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Fixed',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDumbbellType = 'Plated';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectedDumbbellType == 'Plated'
                            ? const Color(0xFFB30000)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Plated',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const Q12Screen()));
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
Widget _buildFixedDumbbellOptions() {
  return Expanded(
    child: GridView.builder(
      itemCount: fixedDumbbellOptions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display dumbbells in two columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 5, // Adjust the height to make them look like buttons
      ),
      itemBuilder: (context, index) {
        final dumbbell = fixedDumbbellOptions[index];
        final bool isSelected = _selectedFixedDumbbells.contains(dumbbell); // Change this to check if the dumbbell is selected

        return GestureDetector(
          onTap: () {
            setState(() {
              // Toggle selection for multiple dumbbells
              if (isSelected) {
                _selectedFixedDumbbells.remove(dumbbell);
              } else {
                _selectedFixedDumbbells.add(dumbbell);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 231, 216, 4) : Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              '$dumbbell kg',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
  );
}


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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Plate Weight Text
              Text(
                '$plateWeight Kg Plates',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              
              // Multiplier 'x'
              const Text(
                'x',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // Quantity Input Box
              Container(
                width: 120,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 196, 194, 194),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: plateCount.toString(),
                  ),
                  onChanged: (value) {
                    // Validate input and update count
                    int? newCount = int.tryParse(value);
                    if (newCount != null && newCount >= 0) {
                      setState(() {
                        _platedDumbbellCount[plateWeight] = newCount;
                      });
                    } else {
                      // Reset to 0 if the input is invalid
                      setState(() {
                        _platedDumbbellCount[plateWeight] = 0;
                      });
                    }
                  },
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

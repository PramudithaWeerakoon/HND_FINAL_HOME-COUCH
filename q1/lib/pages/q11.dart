import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q12.dart';
import 'db_connection.dart'; // Adjust the path as necessary

class DumbbellSelectionScreen extends StatefulWidget {
  final Set<String> selectedEquipment;

  const DumbbellSelectionScreen({super.key, required this.selectedEquipment});

  @override
  _DumbbellSelectionScreenState createState() =>
      _DumbbellSelectionScreenState();
}

class _DumbbellSelectionScreenState extends State<DumbbellSelectionScreen> {
  // Types for Dumbbell and Barbell
  String selectedDumbbellType = 'Fixed'; // Default Dumbbell Type
  String selectedBarbellType = 'Fixed'; // Default Barbell Type

  // Fixed and Adjustable Data
  final List<double> fixedWeightOptions = [1, 3, 5, 7, 10, 12, 15, 20];
  final List<double> platedWeightOptions = [1, 2.5, 5, 10, 20];

  // Selected Data for Each Equipment
  final List<double> selectedDumbbellFixedWeights = [];
  final Map<double, int> selectedDumbbellPlatedWeights = {};
  final List<double> selectedBarbellFixedWeights = [];
  final Map<double, int> selectedBarbellPlatedWeights = {};
  final List<double> selectedKettlebellWeights = [];

  @override
  Widget build(BuildContext context) {
    bool isNextButtonEnabled = _checkIfAnyWeightSelected();

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
                "Which type of equipment do you have?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Render equipment sections based on selection
              if (widget.selectedEquipment.contains('Dumbbell')) ...[
                _buildEquipmentSection(
                  'Dumbbell',
                  selectedDumbbellType,
                  (type) => setState(() => selectedDumbbellType = type),
                  selectedDumbbellFixedWeights,
                  selectedDumbbellPlatedWeights,
                ),
              ],
              if (widget.selectedEquipment.contains('Barbell')) ...[
                _buildEquipmentSection(
                  'Barbell',
                  selectedBarbellType,
                  (type) => setState(() => selectedBarbellType = type),
                  selectedBarbellFixedWeights,
                  selectedBarbellPlatedWeights,
                ),
              ],
              if (widget.selectedEquipment.contains('Kettlebell')) ...[
                _buildKettlebellSection(),
              ],

              const Spacer(),

              // Page Indicator and Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: 'back',
                    backgroundColor: const Color(0xFF21007E),
                    onPressed: () {
                      Navigator.pop(context); // Navigate to the previous screen
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    "11/12",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'next',
                    backgroundColor:
                        isNextButtonEnabled ? const Color(0xFF21007E) : Colors.grey,
                    onPressed: isNextButtonEnabled
                              ? () async {
                                  Map<String, dynamic> userSelections = {
                                    'Dumbbell': {
                                      'Fixed': selectedDumbbellFixedWeights,
                                      'Plated': selectedDumbbellPlatedWeights,
                                    },
                                    'Barbell': {
                                      'Fixed': selectedBarbellFixedWeights,
                                      'Plated': selectedBarbellPlatedWeights,
                                    },
                                    'Kettlebell': selectedKettlebellWeights,
                                    'equipments': widget.selectedEquipment,
                                  };
                                  print("Collected User Selections: $userSelections");

                                  // Get current user email from SessionManager
                                  final userEmail = SessionManager.getUserEmail();
                                  if (userEmail != null) {
                                    // Store selections in the database
                                    await storeUserSelections(userEmail, userSelections);

                                    // Navigate to Q12
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Q12Screen()),
                                    );
                                  } else {
                                    print("No user is logged in.");
                                  }
                                }
                              : null,

                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Space below buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentSection(
    String label,
    String selectedType,
    Function(String) onTypeChanged,
    List<double> selectedFixedWeights,
    Map<double, int> selectedPlatedWeights,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToggleButton(
              '$label Fixed',
              selectedType == 'Fixed',
              () => onTypeChanged('Fixed'),
            ),
            _buildToggleButton(
              '$label Adjustable',
              selectedType == 'Plated',
              () => onTypeChanged('Plated'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (selectedType == 'Fixed')
          _buildFixedWeightOptions(selectedFixedWeights),
        if (selectedType == 'Plated')
          _buildPlatedWeightOptions(selectedPlatedWeights),
      ],
    );
  }

  Widget _buildKettlebellSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Kettlebell Weights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildFixedWeightOptions(selectedKettlebellWeights),
      ],
    );
  }

  Widget _buildToggleButton(
      String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB30000) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFixedWeightOptions(List<double> selectedWeights) {
    return Wrap(
      spacing: 10,
      children: fixedWeightOptions.map((weight) {
        return ChoiceChip(
          label: Text('${weight}kg'),
          selected: selectedWeights.contains(weight),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                selectedWeights.add(weight);
              } else {
                selectedWeights.remove(weight);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPlatedWeightOptions(Map<double, int> selectedWeights) {
  return Column(
    children: platedWeightOptions.map((weight) {
      final plateCount = selectedWeights[weight] ?? 0;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
        child: Row(
          children: [
            SizedBox(
              width: 120, // Consistent width for the weight label
              child: Text(
                '${weight.toInt()} Kg Plates',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 20), // Spacing between the weight label and 'x'
            const Text(
              'x',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 20), // Spacing between 'x' and the input field
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: TextEditingController(
                      text: plateCount > 0 ? plateCount.toString() : ""),
                  onChanged: (value) {
                    setState(() {
                      selectedWeights[weight] = int.tryParse(value) ?? 0;
                    });
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}


  bool _checkIfAnyWeightSelected() {
    return selectedDumbbellFixedWeights.isNotEmpty ||
        selectedDumbbellPlatedWeights.values.any((count) => count > 0) ||
        selectedBarbellFixedWeights.isNotEmpty ||
        selectedBarbellPlatedWeights.values.any((count) => count > 0) ||
        selectedKettlebellWeights.isNotEmpty;
  }

 Future<void> storeUserSelections(String userID, Map<String, dynamic> userSelections) async {
  final db = DatabaseConnection();

  try {
    // Handle Dumbbells
    if (userSelections['Dumbbell'] != null) {
      // Handle Fixed Dumbbells
      if (userSelections['Dumbbell']['Fixed'] is List<double>) {
        final fixedWeights = userSelections['Dumbbell']['Fixed'] as List<double>;
        if (fixedWeights.isNotEmpty) {
          final dumbbellFixedID = await db.fetchPredefinedEquipmentID("Dumbbell", "Fixed");
          await db.bulkInsertFixedWeights(userID, fixedWeights, dumbbellFixedID, 1);
          print("Dumbbell fixed weights inserted successfully.");
        }
      }

      // Handle Adjustable Dumbbells
     if (userSelections['Dumbbell']['Plated'] is Map<double, int>) {
  final platedWeights = userSelections['Dumbbell']['Plated'] as Map<double, int>;
  if (platedWeights.isNotEmpty) {
    // Sort the keys to determine min and max weights
    final sortedWeights = platedWeights.keys.toList()..sort();

    final minWeight = sortedWeights.first; // Minimum weight
    final maxWeight = sortedWeights.last;  // Maximum weight

    // Fetch the equipment ID for Dumbbell Adjustable
    final dumbbellAdjustableID = await db.fetchPredefinedEquipmentID("Dumbbell", "Adjustable");

    // Insert the adjustable equipment
    final adjustableID = await db.insertUserEquipmentAdjustable(
      dumbbellAdjustableID,
      userID,
      minWeight,
      maxWeight,
      1, // Number of pairs
    );

    // Insert the plates for the adjustable equipment
    await db.bulkInsertAdjustablePlates(adjustableID, platedWeights);
    print("Dumbbell adjustable plates inserted successfully.");
  }
}

    }

    // Handle Barbells
    if (userSelections['Barbell'] != null) {
      // Handle Fixed Barbells
      if (userSelections['Barbell']['Fixed'] is List<double>) {
        final fixedWeights = userSelections['Barbell']['Fixed'] as List<double>;
        if (fixedWeights.isNotEmpty) {
          final barbellFixedID = await db.fetchPredefinedEquipmentID("Barbell", "Fixed");
          await db.bulkInsertFixedWeights(userID, fixedWeights, barbellFixedID, 1);
          print("Barbell fixed weights inserted successfully.");
        }
      }

      // Handle Adjustable Barbells
          if (userSelections['Barbell']['Plated'] is Map<double, int>) {
            final platedWeights = userSelections['Barbell']['Plated'] as Map<double, int>;
            if (platedWeights.isNotEmpty) {
              // Sort the keys to determine min and max weights
              final sortedWeights = platedWeights.keys.toList()..sort();

              final minWeight = sortedWeights.first; // Minimum weight
              final maxWeight = sortedWeights.last;  // Maximum weight

              // Fetch the equipment ID for Barbell Adjustable
              final barbellAdjustableID = await db.fetchPredefinedEquipmentID("Barbell", "Adjustable");

              // Insert the adjustable equipment
              final adjustableID = await db.insertUserEquipmentAdjustable(
                barbellAdjustableID,
                userID,
                minWeight,
                maxWeight,
                1, // Number of pairs
              );

              // Insert the plates for the adjustable equipment
              await db.bulkInsertAdjustablePlates(adjustableID, platedWeights);
              print("Barbell adjustable plates inserted successfully.");
            }
          }

    }

    // Handle Kettlebells
    if (userSelections['Kettlebell'] != null) {
      final kettlebellWeights = userSelections['Kettlebell'] as List<double>;
      if (kettlebellWeights.isNotEmpty) {
        final kettlebellID = await db.fetchPredefinedEquipmentID("Kettlebell", "Fixed");
        await db.bulkInsertFixedWeights(userID, kettlebellWeights, kettlebellID, 1);
        print("Kettlebell fixed weights inserted successfully.");
      }
    }
       // Handle Other Equipment (e.g., Skipping Rope, Fitness Bench, etc.)
    if (userSelections['equipments'] != null) {
  final otherEquipment = userSelections['equipments'] as Set<String>;

  // Define weighted and non-weighted equipment explicitly
  final nonWeightedEquipment = {"Skipping Rope", "Fitness Bench", "Resistance Band"};
  
  for (final equipment in otherEquipment) {
    if (equipment != "Dumbbell" && equipment != "Barbell" && equipment != "Kettlebell") {
      try {
        // Fetch predefined Equipment ID
        final equipmentID = await db.fetchPredefinedEquipmentID(equipment, "General");

        // Determine if equipment is weighted
        final isWeighted = !nonWeightedEquipment.contains(equipment);

        // Insert into the database
        await db.insertOtherEquipmentFixed(userID, equipmentID, isWeighted ? 1.0 : 0.0, 1); // Weight 1.0 for weighted, 0.0 for non-weighted
        print("$equipment (${isWeighted ? "weighted" : "non-weighted"}) inserted successfully.");
      } catch (e) {
        print("Error inserting other equipment ($equipment): $e");
      }
    }
  }
}



    print("User selections stored successfully.");
  } catch (e) {
    print("Error storing user selections: $e");
  }
}

}



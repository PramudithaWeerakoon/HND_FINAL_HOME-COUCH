import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'q4.dart';
import 'db_connection.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  _WeightInputScreenState createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  bool isKgSelected = true;

  @override
  void initState() {
    super.initState();
    _weightController.text = '70.8'; // Default value
    _weightController.addListener(() {
      setState(() {}); // Updates the UI when the weight input changes
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Avoids overflow when keyboard pops up
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight * 0.95, // Ensures layout doesn't break
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40),
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
                      'What is your weight?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Weight input field
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.4,
                            child: TextField(
                              controller: _weightController,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(
                                fontSize: screenWidth * 0.15,
                                fontWeight: FontWeight.bold,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.35,
                            child: const Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Unit toggle buttons
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isKgSelected = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isKgSelected
                                  ? const Color(0xFFB30000)
                                  : Colors.white,
                              foregroundColor: isKgSelected
                                  ? Colors.white
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('KG'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isKgSelected = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isKgSelected
                                  ? Colors.white
                                  : const Color(0xFFB30000),
                              foregroundColor: isKgSelected
                                  ? Colors.black
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('LB'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Page number at the bottom
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "3/12",
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
        ),
      ),

      // Floating Buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Padding(
            padding: const EdgeInsets.only(left: 16),
            child: FloatingActionButton(
              heroTag: 'back',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Q4Page()),
              );
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FloatingActionButton(
              heroTag: 'next',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () async {
                final bodyWeight = double.tryParse(_weightController.text);
                if (bodyWeight == null || bodyWeight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid weight.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final weightInKg =
                    isKgSelected ? bodyWeight : bodyWeight * 0.453592;

                try {
                  final db = DatabaseConnection();
                  await db.updateBodyWeight(weightInKg);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Q4Page()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Failed to update body weight. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
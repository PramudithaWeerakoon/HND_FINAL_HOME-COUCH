import 'package:flutter/material.dart';
import 'q13.dart';
import 'db_connection.dart';

class Q12Screen extends StatefulWidget {
  const Q12Screen({super.key});

  @override
  Q12ScreenState createState() => Q12ScreenState();
}

class Q12ScreenState extends State<Q12Screen> {
  List<String> conditions = ['Diabetes', 'High Blood Pressure', 'Heart Surgery', 'Gastric', 'Other', 'None'];
  String selectedCondition = '';

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
                "Do you have any medical conditions?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              
              // Displaying medical conditions options
              Expanded(
                child: ListView.builder(
                  itemCount: conditions.length,
                  itemBuilder: (context, index) {
                    String currentCondition = conditions[index];
                    bool isSelected = selectedCondition == currentCondition;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCondition = currentCondition;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: isSelected
                                ? (currentCondition == 'None' ? const Color(0xFFB30000) : const Color(0xFFB30000))
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            currentCondition,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isSelected && currentCondition == 'None' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Page Indicator
              const Text(
                "12/12",
                style: TextStyle(
                  fontSize: 24,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton(
              heroTag: 'back_to_q11',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                // Handle going back to the previous question
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32),
            child: FloatingActionButton(
              heroTag: 'confirm',
              backgroundColor: const Color(0xFF01620B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: selectedCondition.isNotEmpty
                  ? () async {
                      // Update the medical condition in the database
                      DatabaseConnection db = DatabaseConnection();
                      await db.updateMedicalCondition(selectedCondition);

                      // Navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Q13Screen()),
                      );
                    } : null, // Disable if no condition is selected
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

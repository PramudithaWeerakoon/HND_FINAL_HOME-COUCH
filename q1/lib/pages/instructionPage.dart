import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({super.key});

  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Workout Name Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21007E),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Overhead Press - 4 Sets',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // GIF Placeholder
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('lib/assets/overheadpress.gif'), // Replace with actual gif path
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tutorial Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(179, 175, 2, 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Tutorial",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8), // Add some space between the text and the icon
                          Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Instructions Box with narrower width
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8, // Adjust width to 80% of screen width
                        height: 280,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text(
                                "1. Starting Position:\n"
                                "Stand feet shoulder-width apart, holding the barbell with an overhand grip slightly wider than your shoulders.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "2. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "3. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "4. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "5. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "6. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              SizedBox(height: 10),
                              Text(
                                "7. Engage Core:\n"
                                "Tighten your core and maintain a straight back.",
                              ),
                              // Add more instructions here if needed
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Sets and Reps Info
                    const Text(
                      '4 Sets x 10 Reps',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Back Button
            Positioned(
              left: 16,
              bottom: 32,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to previous screen
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Back",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB804),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
            // Start Button
            Positioned(
              right: 16,
              bottom: 32,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Start workout action here
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21007E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

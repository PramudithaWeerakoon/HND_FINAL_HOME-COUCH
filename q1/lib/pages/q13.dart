import 'package:flutter/material.dart';

class Q13Screen extends StatelessWidget {
  const Q13Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100), // Add some space from the top
            // Title
            const Text(
              "Your Fitness Profile is ready!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 90),

            // Profile Card
            Center(
              child: Container(
                width: 420, // Adjust width for exact placement
                height: 450,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('lib/assets/profileimage.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Profile Details
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pramuditha",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Height : 5 ' 7 ft",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            "Weight : 70 kg",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(height: 45),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("BMI : 23.5   Normal", style: TextStyle(fontSize: 21)),
                              Text("Body Fat : 21%", style: TextStyle(fontSize: 21)),
                              Text("Daily Cal Intake : 2110 cal", style: TextStyle(fontSize: 21)),
                              Text("Fitness Level : Newbie", style: TextStyle(fontSize: 21)),
                              Text("Body Type : Skinny-Fat", style: TextStyle(fontSize: 21)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Fine-Tune Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF21007E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Handle fine-tune goals action
                  },
                  child: const Text(
                    "Let’s Fine-Tune Your Goals",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Page Indicator and Back Button
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFB30000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: () {
              // Handle back navigation
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

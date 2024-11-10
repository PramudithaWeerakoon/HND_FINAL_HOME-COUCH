import 'package:flutter/material.dart';

class WorkoutPlanScreen extends StatelessWidget {
  final String title;

  const WorkoutPlanScreen({Key? key, required this.title}) : super(key: key);

  // Add your images for each exercise here
  final String overheadPressImage = 'lib/assets/dumbell.jpg';
  final String dumbbellFlyImage = 'lib/assets/dumbell.jpg';
  final String lateralRaisesImage = 'lib/assets/dumbell.jpg';
  final String hammerCurlsImage = 'lib/assets/dumbell.jpg';
  final String pushUpsImage = 'lib/assets/push-ups.png';
  final String bicepCurlsImage = 'lib/assets/dumbell.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/profileimage.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 76,
                        child: Text(
                          'Body\nRe-composition Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rounded container for "Day 1" section and exercise list
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day title and description
                        const Text(
                          'Day 1',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your 3-month body recomposition plan is tailored to build muscle and lose fat. With strength training, cardio, and nutrition, you\'ll achieve a leaner, stronger you!',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),

                        // Divider line
                        Divider(color: Color(0xFFB6B6B6), thickness: 1.5),

                        // Scrollable list of exercises
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildExerciseCard('Overhead Press',
                                '4 Sets | 8 Reps', '8 min', overheadPressImage),
                            _buildExerciseCard('Dumbbell Fly',
                                '3 Sets | 10 Reps', '8 min', dumbbellFlyImage),
                            _buildExerciseCard('Lateral Raises',
                                '4 Sets | 8 Reps', '6 min', lateralRaisesImage),
                            _buildExerciseCard('Hammer Curls',
                                '4 Sets | 8 Reps', '5 min', hammerCurlsImage),
                            _buildExerciseCard('Push-Ups', '4 Sets | 8 Reps',
                                '6 min', pushUpsImage),
                            _buildExerciseCard('Bicep Curls', '4 Sets | 8 Reps',
                                '6 min', bicepCurlsImage),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Start button fixed at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Add start action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each exercise card
  Widget _buildExerciseCard(
      String title, String setsReps, String duration, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Display exercise image
            Image.asset(
              imageUrl,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            // Exercise details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    setsReps,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // Duration text
            Text(
              duration,
              style: const TextStyle(fontSize: 14, color: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }

}

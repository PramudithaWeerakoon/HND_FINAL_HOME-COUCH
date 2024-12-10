import 'package:flutter/material.dart';

class MealPlanScreen extends StatelessWidget {
  final String oatmealImage = 'lib/assets/sweet-breakfast-omelette.jpg';
  final String omeletImage = 'lib/assets/egg.jpeg';
  final String shakeImage = 'lib/assets/Mixed-Berry-Banana-Smoothie.jpg';
  final String yogurtImage = 'lib/assets/blueberry-almond-yogurt.jpeg';

  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title Section at the top
            Center(
              child: Text(
                'Breakfast\nSuggestions',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight
                      .w900, // Increased font weight to make it bolder
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Explore Breakfast Options',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List of meal options
            _buildMealOptionCard(
              'Oatmeal with Nuts',
              '6g Protein | 150 cal | 27g carbs',
              oatmealImage,
            ),
            _buildMealOptionCard(
              'Egg White Omelet',
              '20g Protein | 250 cal | 10g carbs',
              omeletImage,
            ),
            _buildMealOptionCard(
              'Banana Shake with Berries',
              '25g Protein | 300 cal | 30g carbs',
              shakeImage,
            ),
            _buildMealOptionCard(
              'Greek Yogurt with Almonds',
              '15g Protein | 240 cal | 25g carbs',
              yogurtImage,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each meal option card
  Widget _buildMealOptionCard(String title, String details, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4, // Add shadow by setting elevation
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: AssetImage(imageUrl),
          radius: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          details,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            color: const Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}

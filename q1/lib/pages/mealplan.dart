import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:q1/components/menuBar/menuBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyMealPlan(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DailyMealPlan extends StatefulWidget {
  const DailyMealPlan({super.key});

  @override
  _DailyMealPlanState createState() => _DailyMealPlanState();
}

class _DailyMealPlanState extends State<DailyMealPlan> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'Daily Meal Plan',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            PieChartWidget(),
            SizedBox(height: 20),
            Text(
              '240g Carbs | 100g Fiber & Fats | 140g Protein',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            MealCard(
              mealType: 'Breakfast',
              calories: '400 - 450 cal',
              details: '80 carbs | 10 Fat | 7 Fiber | 45 Protein',
              icon: Icons.breakfast_dining,
              onTap: () {
                // Handle tap for Breakfast card
                print('Breakfast card tapped');
              },
            ),
            MealCard(
              mealType: 'Lunch',
              calories: '500 - 600 cal',
              details: '80 carbs | 15 Fat | 10 Fiber | 50 Protein',
              icon: Icons.lunch_dining,
              onTap: () {
                // Handle tap for Lunch card
                print('Lunch card tapped');
              },
            ),
            MealCard(
              mealType: 'Dinner',
              calories: '500 - 600 cal',
              details: '80 carbs | 10 Fat | 7 Fiber | 45 Protein',
              icon: Icons.dinner_dining,
              onTap: () {
                // Handle tap for Dinner card
                print('Dinner card tapped');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Increased height for a larger pie chart
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 40,
                color: Color(0xFFE40202),
                title: 'Carbohydrate',
                radius: 100, // Increased radius for each slice
                titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                borderSide: BorderSide(
                    color: Colors.black,
                    width: 2), // Black border for each slice
              ),
              PieChartSectionData(
                value: 30,
                color: Color(0xFF21007E),
                title: 'Protein',
                radius: 100,
                titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              PieChartSectionData(
                value: 20,
                color: Color(0xFFEAB804),
                title: 'Fat',
                radius: 100,
                titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              PieChartSectionData(
                value: 10,
                color: Color(0xFF01620B),
                title: 'Fiber',
                radius: 100,
                titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 0,
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealType;
  final String calories;
  final String details;
  final IconData icon;
  final VoidCallback onTap; // Add onTap callback

  const MealCard({super.key, 
    required this.mealType,
    required this.calories,
    required this.details,
    required this.icon,
    required this.onTap, // Required callback for tap action
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger onTap when the card is tapped
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Colors.orange),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    calories,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    details,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'db_connection.dart'; // Import your database connection
import 'package:q1/components/menuBar/menuBar.dart';
import 'breakfastmealoptions.dart';
import 'lunchmealoptions.dart';
import 'dinnermealoptions.dart';

class DailyMealPlan extends StatefulWidget {
  const DailyMealPlan({super.key});

  @override
  _DailyMealPlanState createState() => _DailyMealPlanState();
}

class _DailyMealPlanState extends State<DailyMealPlan> {
  int _currentIndex = 1;
  Map<String, dynamic> _mealPlanData = {};

  @override
  void initState() {
    super.initState();
    _fetchMealPlanData();
  }

  Future<void> _fetchMealPlanData() async {
    final userEmail = SessionManager.getUserEmail();
    print('User email: $userEmail');
    if (userEmail != null) {
      final db = DatabaseConnection();
      final data = await db.getMealPlanData(userEmail);
      setState(() {
        _mealPlanData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Daily Meal Plan',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  PieChartWidget(data: _mealPlanData),
                  SizedBox(height: 20),
                  Text(
                    _mealPlanData.isNotEmpty
                        ? '${_mealPlanData['carbs']}g Carbs | ${_mealPlanData['fat']}g Fat | ${_mealPlanData['fiber']}g Fiber | ${_mealPlanData['protein']}g Protein'
                        : 'Loading...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Add MealCard widgets for different meals
                  MealCard(
                    mealType: 'Breakfast',
                    icon: Icons.breakfast_dining,
                    onTap: () {
                      // Handle tap for Breakfast card
                      print('Breakfast card tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const breakfastMealPlanScreen(),
                        ),
                      );
                    },
                  ),
                  MealCard(
                    mealType: 'Lunch',
                    icon: Icons.lunch_dining,
                    onTap: () {
                      // Handle tap for Lunch card
                      print('Lunch card tapped');
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const lunchMealPlanScreen(),
                        ),
                      );
                    },
                  ),
                  MealCard(
                    mealType: 'Dinner',
                    icon: Icons.dinner_dining,
                    onTap: () {
                      // Handle tap for Dinner card
                      print('Dinner card tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const dinnerMealPlanScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
  final Map<String, dynamic> data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: parseDouble(data['carbs']),
                    color: const Color(0xFFE40202),
                    title: 'Carbs',
                    radius: constraints.maxWidth * 0.3,
                    titleStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  PieChartSectionData(
                    value: parseDouble(data['protein']),
                    color: const Color(0xFF21007E),
                    title: 'Protein',
                    radius: constraints.maxWidth * 0.3,
                    titleStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  PieChartSectionData(
                    value: parseDouble(data['fat']),
                    color: const Color(0xFFEAB804),
                    title: 'Fat',
                    radius: constraints.maxWidth * 0.3,
                    titleStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  PieChartSectionData(
                    value: parseDouble(data['fiber']),
                    color: const Color(0xFF01620B),
                    title: 'Fiber',
                    radius: constraints.maxWidth * 0.3,
                    titleStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealType;
  final IconData icon;
  final VoidCallback onTap; // Add onTap callback

  const MealCard({
    super.key,
    required this.mealType,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

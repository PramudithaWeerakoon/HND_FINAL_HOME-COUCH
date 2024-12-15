import 'package:flutter/material.dart';
import 'db_connection.dart';

class BreakfastMealPlanScreen extends StatefulWidget {
  const BreakfastMealPlanScreen({Key? key}) : super(key: key);

  @override
  _BreakfastMealPlanScreenState createState() => _BreakfastMealPlanScreenState();
}

class _BreakfastMealPlanScreenState extends State<BreakfastMealPlanScreen> {
  final DatabaseConnection dbConnection = DatabaseConnection();
  late Future<List<Map<String, dynamic>>> BreakfastMealsFuture;

  @override
  void initState() {
    super.initState();
    BreakfastMealsFuture = _fetchBreakfastMeals();
  }

  Future<List<Map<String, dynamic>>> _fetchBreakfastMeals() async {
    final email = SessionManager.getUserEmail();
    if (email == null) {
      throw Exception("User email not found");
    }
    return await dbConnection.getbreakfastMeals(email);
  }

  Widget _buildMealOptionCard(Map<String, dynamic> meal) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          child: Text(meal['ms_name'][0]), // Placeholder for meal image
          radius: 30,
        ),
        title: Text(
          meal['ms_name'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${meal['ms_protein']}g Protein | ${meal['ms_calories']} cal | ${meal['ms_carbs']}g Carbs',
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: BreakfastMealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Breakfast meals found"));
            }

            final meals = snapshot.data!;

            return ListView(
              children: [
                const Center(
                  child: Text(
                    'Breakfast Suggestions',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Explore Breakfast Options',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...meals.map((meal) => _buildMealOptionCard(meal)).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

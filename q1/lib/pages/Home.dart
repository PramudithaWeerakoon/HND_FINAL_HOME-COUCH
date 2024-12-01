import 'package:flutter/material.dart';
import 'package:q1/components/menuBar/menuBar.dart'; // Adjust path if needed
import 'workoutsummary.dart';
import 'db_connection.dart';
import 'tandc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String propic = 'lib/assets/profileimage.jpg';
  final String backplan = 'lib/assets/backplan.jpg';
  final String absplan = 'lib/assets/absplan.jpg';

  // Add the image paths for each goal
  final String planksImage = 'lib/assets/planks.png';
  final String pushupsImage = 'lib/assets/push-ups.png';
  final String situpsImage = 'lib/assets/sit-up.png';

  int _currentIndex = 0;
  String userName = "User"; // Default value

   @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon 👋";
    } else {
      return "Good Evening 👋";
    }
  }


  void _fetchUserName() async {
    try {
      DatabaseConnection db = DatabaseConnection();
      final name = await db.getUserName();
      setState(() {
        userName = name;
      });
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
        
        // Wrap the entire body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Greeting Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(propic),
                  radius: 24,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(fontSize: 16),
                    ),

                     Text(
                      userName, // Dynamic user name
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Start Workout Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Color(0xFF21007E),Color(0xFF3C00E4),
                ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Start Your \nWorkout Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '0 / 6 Done',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      '0%', // Dynamic progress value
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Special Plans Section
            const Center(
              child: Text(
              'Daily Special Plans',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPlanCard('Back Plan', '20 min', '0 / 5 Done', backplan),
                  const SizedBox(width: 15),
                  _buildPlanCard('ABS Plan', '20 min', '0 / 6 Done', absplan),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recommended By Goal Section
            const Center(
              child: Text(
              'Recommended By Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Scrollable vertical goal items
            SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enable vertical scrolling
              child: Column(
                children: [
                  _buildGoalItem('Planks', '0 / 2 Done', '3 min', planksImage),
                  _buildGoalItem(
                      'Push-ups', '0 / 20 Done', '6 min', pushupsImage),
                  _buildGoalItem(
                      'Sit-ups', '0 / 20 Done', '6 min', situpsImage),
                  _buildGoalItem('Planks', '0 / 2 Done', '3 min', planksImage),
                  _buildGoalItem(
                      'Push-ups', '0 / 20 Done', '6 min', pushupsImage),
                  _buildGoalItem(
                      'Sit-ups', '0 / 20 Done', '6 min', situpsImage),
                  // Add more goal items here if needed
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  // Helper method for creating plan cards
  Widget _buildPlanCard(
      String title, String time, String progress, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutPlanScreen(title: title)),
        );
      },
      child: Container(
        width: 250, // Increased width for better visibility
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              progress,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }


  // Helper method for creating goal items with images
  Widget _buildGoalItem(
      String title, String progress, String duration, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(imageUrl,
                  height: 55, width: 55), // Image instead of Icon
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    progress,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text(
            duration,
            style: const TextStyle(fontSize: 14, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart'; // Make sure to adjust the path based on your folder structure
import 'package:q1/components/menuBar/menuBar.dart'; // Import the BottomMenuBar
import 'editprofile.dart'; // Import the EditProfilePage
import 'payment.dart'; // Import the PaymentPage
import 'db_connection.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false; // State to manage notifications toggle
  int _currentIndex = 4; // Default to Settings tab in the bottom menu
  String userName = "User"; // Default value
  String userEmail = "user@example.com"; // Default value

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchUserEmail();
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

  void _fetchUserEmail() async {
    try {
      DatabaseConnection db = DatabaseConnection();
      final email = await db.getUserEmail(); // Use a separate method for email
      setState(() {
        userEmail = email;
      });
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  Future<void> _handleLogout() async {
    try {
      DatabaseConnection db = DatabaseConnection();
      await db.logout(); // Call the logout method to clear session
      Navigator.pushReplacementNamed(
          context, '/login'); // Redirect to the login page
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                const Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundImage: AssetImage('lib/assets/profileimage.jpg'), // Placeholder profile image
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          userName, // Dynamic user name
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userEmail, // Display the fetched user email
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                _buildSettingsOption(
                  context,
                  label: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  iconPath: 'lib/assets/user.png',
                ),
                _buildSettingsOption(
                  context,
                  label: 'Payments & Subscription',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubscriptionPage()),
                    );
                  },
                  iconPath: 'lib/assets/p&s.png',
                ),
                _buildSettingsToggle(
                  label: 'Notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildSettingsOption(
                  context,
                  label: 'Terms & Conditions',
                  onTap: () {},
                ),
                _buildSettingsOption(
                  context,
                  label: 'Privacy Policy',
                  onTap: _handleLogout,
                ),
                _buildSettingsOption(
                  context,
                  label: 'Log Out',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomMenuBar(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Handle the navigation logic here if needed
          },
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    String? iconPath,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.06),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: iconPath != null
              ? Image.asset(
                  iconPath,
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                )
              : null,
          title: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          trailing: label == 'Log Out'
              ? const Icon(Icons.logout, color: Color.fromARGB(255, 177, 21, 10)) // Show logout icon for "Log Out" label
              : const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSettingsToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.06),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFEAB804),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color.fromARGB(255, 133, 133, 133),
          ),
        ),
      ),
    );
  }
}

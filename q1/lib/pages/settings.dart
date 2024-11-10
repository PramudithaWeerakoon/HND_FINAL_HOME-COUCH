import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart'; // Make sure to adjust the path based on your folder structure
import 'package:q1/components/menuBar/menuBar.dart'; // Import the BottomMenuBar
import 'editprofile.dart'; // Import the EditProfilePage
import 'payment.dart'; // Import the PaymentPage

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false; // State to manage notifications toggle
  int _currentIndex = 4; // Default to Settings tab in the bottom menu

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('lib/assets/profileimage.jpg'), // Placeholder profile image
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pramuditha',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'user@pramuditha2002@gmail.com',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
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
                onTap: () {},
              ),
              _buildSettingsOption(
                context,
                label: 'Log Out',
                onTap: () {},
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 26),
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
                  width: 35,
                  height: 35,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 26),
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
            inactiveTrackColor: const Color(0xFFEAB804),
          ),
        ),
      ),
    );
  }
}

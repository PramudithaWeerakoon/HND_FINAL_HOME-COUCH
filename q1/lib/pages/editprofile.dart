import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart'; // Use your gradient background widget
// Import your database connection file

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: FutureBuilder<User>(
            future: User.getUserData(), // Fetch user data from database
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available.'));
              }

              User user = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileRow(
                            label: 'Name',
                            initialValue: user.name,
                            maxWidth: screenWidth * 0.8,
                          ),
                          ProfileRow(
                            label: 'Email',
                            initialValue: user.email,
                            maxWidth: screenWidth * 0.8,
                          ),
                          ProfileRow(
                            label: 'Password',
                            initialValue:
                                '********', // You might want to use an actual field here for password change
                            isPassword: true,
                            maxWidth: screenWidth * 0.8,
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Linked Accounts',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          LinkedAccountRow(
                              platform: 'Google', initialStatus: 'Un-Link'),
                          LinkedAccountRow(
                              platform: 'Meta', initialStatus: 'Link'),
                          LinkedAccountRow(
                              platform: 'Apple ID', initialStatus: 'Link'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Add your database fetching logic here
  static Future<User> getUserData() async {
    // Simulating database fetch with a delay
    await Future.delayed(const Duration(seconds: 2));

    // Replace this with actual database fetch logic
    return User(name: 'Pramuditha Weerakoon', email: 'pramud2002@gmail.com');
  }
}

class LinkedAccountRow extends StatefulWidget {
  final String platform;
  final String initialStatus;

  const LinkedAccountRow({
    super.key,
    required this.platform,
    required this.initialStatus,
  });

  @override
  _LinkedAccountRowState createState() => _LinkedAccountRowState();
}

class _LinkedAccountRowState extends State<LinkedAccountRow> {
  late String linkStatus;

  @override
  void initState() {
    super.initState();
    linkStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _getPlatformIcon(widget.platform),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.platform,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _toggleLinkStatus,
            style: TextButton.styleFrom(
              backgroundColor: linkStatus == 'Link'
                  ? const Color(0xFF21007E)
                  : const Color(0xFFB30000),
              foregroundColor: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(linkStatus),
          ),
        ],
      ),
    );
  }

  Widget _getPlatformIcon(String platform) {
    switch (platform) {
      case 'Google':
        return Image.asset('lib/assets/google.png', width: 24, height: 24);
      case 'Meta':
        return Image.asset('lib/assets/meta.png', width: 24, height: 24);
      case 'Apple ID':
        return Image.asset('lib/assets/apple.png', width: 24, height: 24);
      default:
        return const Icon(Icons.link);
    }
  }

  void _toggleLinkStatus() {
    setState(() {
      linkStatus = linkStatus == 'Link' ? 'Un-Link' : 'Link';
    });
    linkAccount(widget.platform, linkStatus == 'Un-Link');
  }

  Future<void> linkAccount(String platform, bool isLinked) async {
    // Replace this with your backend logic
    print('$platform account ${isLinked ? 'linked' : 'unlinked'}');
  }
}

class ProfileRow extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool isPassword;
  final double maxWidth;

  const ProfileRow({
    super.key,
    required this.label,
    required this.initialValue,
    this.isPassword = false,
    required this.maxWidth,
  });

  @override
  _ProfileRowState createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: widget.maxWidth,
                  child: TextField(
                    controller: controller,
                    obscureText: widget.isPassword,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  // Save the edited value
                }
                isEditing = !isEditing;
              });
            },
            child: Text(isEditing ? 'Save' : 'Change'),
          ),
        ],
      ),
    );
  }
}

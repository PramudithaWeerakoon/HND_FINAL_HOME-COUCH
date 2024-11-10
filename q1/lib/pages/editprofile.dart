import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart'; // Use your gradient background widget

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
                  children: [
                    ProfileRow(label: 'Name', initialValue: 'Pramuditha Weerakoon'),
                    ProfileRow(label: 'Email', initialValue: 'pramud2002@gmail.com'),
                    ProfileRow(label: 'Password', initialValue: '********', isPassword: true),
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
                    LinkedAccountRow(platform: 'Google', initialStatus: 'Un-Link'),
                    LinkedAccountRow(platform: 'Meta', initialStatus: 'Link'),
                    LinkedAccountRow(platform: 'Apple ID', initialStatus: 'Link'),
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

class LinkedAccountRow extends StatefulWidget {
  final String platform;
  final String initialStatus;

  const LinkedAccountRow({
    Key? key,
    required this.platform,
    required this.initialStatus,
  }) : super(key: key);

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
          Row(
            children: [
              _getPlatformIcon(widget.platform), // Use the widget returned by _getPlatformIcon
              const SizedBox(width: 8),
              Text(
                widget.platform,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          TextButton(
            onPressed: _toggleLinkStatus,
            style: TextButton.styleFrom(
              backgroundColor: linkStatus == 'Link' ? const Color(0xFF21007E) : const Color(0xFFB30000),
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

  const ProfileRow({
    Key? key,
    required this.label,
    required this.initialValue,
    this.isPassword = false,
  }) : super(key: key);

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
          Column(
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
                width: 270,
                child: TextField(
                  controller: controller,
                  obscureText: widget.isPassword,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Darker border for inactive state
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Solid border for focused state
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
          TextButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  // Save the edited value
                  // In a real app, this is where you would update the backend
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

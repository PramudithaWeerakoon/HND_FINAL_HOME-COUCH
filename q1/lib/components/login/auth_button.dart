import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String imagePath;

  // Constructor to accept the image path
  const AuthButton({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,  // Adjust the size as needed
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 3), // Offset to control the shadow position
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 29, // Adjust the icon size as needed
          height: 29,
        ),
      ),
    );
  }
}

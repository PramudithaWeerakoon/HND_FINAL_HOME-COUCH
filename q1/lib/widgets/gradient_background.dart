import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF), // White at the top
            Color(0xFFEEF4FF), // Light blue at the bottom
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}

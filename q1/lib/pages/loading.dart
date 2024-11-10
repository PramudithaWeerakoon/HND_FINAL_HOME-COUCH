import 'dart:math';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image positioned higher
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0), // Increased bottom padding for more space
              child: Image.asset(
                'lib/assets/logo.png', // Replace with your logo path
                height: 100, // Adjust the height as needed
              ),
            ),
            // Circular loading animation with additional top padding
            Padding(
              padding: const EdgeInsets.only(top: 40.0), // Adjust padding to move the circle down
              child: SizedBox(
                height: 60, // Reduced height for the animation
                width: 60,  // Reduced width for the animation
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: DotLoadingPainter(_controller.value),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotLoadingPainter extends CustomPainter {
  final double progress;

  DotLoadingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 54, 7, 182); // Blue color for the dots
    const dotCount = 12;
    final dotRadius = size.width * 0.06;  // Smaller dot radius
    final radius = size.width * 0.35;     // Smaller overall radius

    for (int i = 0; i < dotCount; i++) {
      // Rotate each dot around the circle, with offset based on progress
      final angle = 2 * pi * (i / dotCount) + 2 * pi * progress;
      final x = size.width / 2 + radius * cos(angle);
      final y = size.height / 2 + radius * sin(angle);
      
      // Control opacity to create a fade in and out effect as they rotate
      final opacity = (0.6 + 0.4 * sin(2 * pi * (i / dotCount) - 2 * pi * progress)).clamp(0.2, 1.0);

      canvas.drawCircle(
        Offset(x, y),
        dotRadius,
        paint..color = paint.color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

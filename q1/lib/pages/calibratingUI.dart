import 'dart:async';
import 'package:flutter/material.dart';
import 'instructionPage.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  _CalibrationScreenState createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for continuous rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Speed of rotation
    )..repeat();

    // Start a timer to navigate to the next screen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InstructionPage()),  // Replace with your next screen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular animated indicator with "Calibrating" text in the center
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Gradient rotating arc
                  RotationTransition(
                    turns: _controller,
                    child: CustomPaint(
                      size: const Size(150, 150),
                      painter: GradientArcPainter(),
                    ),
                  ),
                  // Centered "Calibrating" text
                  const Text(
                    "Calibrating",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // Instruction text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Ensure your entire body is visible on camera during workout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define gradient for the arc
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 3.14 * 2,
      colors: [
        Color(0xFFD1C4E9), // Light purple start
        Color(0xFF21007E), // Deep purple end
      ],
      stops: [0.0, 1.0],
    );

    // Paint setup for the gradient arc
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Draw the arc with a gap to create a spinner effect
    double startAngle = -3.14 / 2;
    double sweepAngle = 3.14 * 2; // 270 degrees for an incomplete circle
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: const Center(child: Text('Next screen content')),
    );
  }
}

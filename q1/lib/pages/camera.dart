import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'instructionPage.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late CameraDescription _camera;
  late Future<void> _initializeControllerFuture;

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
        MaterialPageRoute(
            builder: (context) =>
                const InstructionPage()), // Replace with your next screen
      );
    });

    // Initialize camera and start capturing frames
    _initializeCamera();
  }

  Future<void> sendFrameToApi(Uint8List frameBytes) async {
    var uri = Uri.parse('http://127.0.0.1:8000/process_frame');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('file', frameBytes,
          filename: 'frame.jpg'));

    var client = http.Client();
    client.send(request).timeout(Duration(seconds: 10)).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('API Response: $responseBody');
      } else {
        print('Failed to send frame: ${response.statusCode}');
      }
    }).catchError((e) {
      print('Error sending frame: $e');
    }).whenComplete(() => client.close());

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('API Response: $responseBody');
      } else {
        print('Failed to send frame: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending frame: $e');
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _camera = _cameras.first; // Use the first available camera
    _cameraController = CameraController(_camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();

    // Start sending frames to the API periodically
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await _initializeControllerFuture;

      // Capture a frame
      final frame = await _cameraController.takePicture();
      final imageBytes = await frame.readAsBytes();

      // Send the captured frame to the API
      await sendFrameToApi(imageBytes);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraController.dispose();
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
      ..shader = gradient.createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
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

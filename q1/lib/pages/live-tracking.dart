import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Q14Screen extends StatefulWidget {
  const Q14Screen({super.key});

  @override
  _Q14ScreenState createState() => _Q14ScreenState();
}

class _Q14ScreenState extends State<Q14Screen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  int frameCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    // Check if platform is Android or iOS, and not web or other platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final cameras = await availableCameras();
        _cameraController = CameraController(cameras[0], ResolutionPreset.low);
        await _cameraController!.initialize();
        _cameraController!.startImageStream((CameraImage image) {
          List<double> input = preprocessImage(image);

          // Print the preprocessed image data every 10 frames
          if (frameCounter % 10 == 0) {
            print(
                "Preprocessed input (first 100 values): ${input.sublist(0, 100)}");
          }
          frameCounter++;
        });

        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      // For unsupported platforms, mark the camera as initialized and log a message
      setState(() {
        _isCameraInitialized = true;
      });
      print("Camera functionality is not supported on this platform.");
    }
  }

  Future<void> _loadModel() async {
    // Load your model here (e.g., MoveNet model)
    print('Model loaded successfully');
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  List<double> preprocessImage(CameraImage image) {
    var img = image.planes[0].bytes;
    int width = image.width;
    int height = image.height;

    List<double> input = List.filled(224 * 224 * 3, 0.0);

    // Resize and normalize
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int pixelIndex = (y * width + x) * 3;

        int r = img[pixelIndex];
        int g = img[pixelIndex + 1];
        int b = img[pixelIndex + 2];

        // Normalizing values between 0 and 1
        int newIndex = (y * 224 + x) * 3;
        input[newIndex] = r / 255.0;
        input[newIndex + 1] = g / 255.0;
        input[newIndex + 2] = b / 255.0;
      }
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overhead Press - Set 1')),
      body: Column(
        children: [
          _isCameraInitialized
              ? AspectRatio(
                  aspectRatio: _cameraController?.value.aspectRatio ?? 1.0,
                  child: _cameraController != null
                      ? CameraPreview(_cameraController!)
                      : const Center(child: Text("Camera not supported")),
                )
              : const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.refresh, color: Colors.orange),
                  label: const Text("Reset",
                      style: TextStyle(color: Colors.orange)),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: const Icon(Icons.help, color: Colors.blue),
                  label: const Text("Help"),
                  onPressed: () {},
                ),
                const Text("0 / 10 Reps", style: TextStyle(fontSize: 20)),
                TextButton.icon(
                  icon: const Icon(Icons.skip_next, color: Colors.red),
                  label:
                      const Text("Skip", style: TextStyle(color: Colors.red)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

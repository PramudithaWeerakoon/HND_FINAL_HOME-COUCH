import 'dart:convert';
import 'dart:async';
import 'dart:typed_data'; // For handling image data
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Dependency to process the image

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int repCount = 0; // Repetition counter

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high,
      );
      await _cameraController?.initialize();
      setState(() {});

      // Start the camera stream to continuously capture frames
      _cameraController?.startImageStream((CameraImage image) {
        // Process the image frames here
        captureFrame(image); // Send image to API
      });
    } else {
      print('No cameras found');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void resetReps() {
    setState(() {
      repCount = 0; // Reset the repetition counter
    });
  }

  Future<void> captureFrame(CameraImage image) async {
    try {
      // Convert the CameraImage to bytes (JPEG format)
      final bytes = await _convertImageToBytes(image);

      // Send the captured frame to the API
      sendToAPI(Uint8List.fromList(bytes));
    } catch (e) {
      print('Error capturing frame: $e');
    }
  }

  // Convert CameraImage to bytes (JPEG format)
  Future<List<int>> _convertImageToBytes(CameraImage image) async {
    // Convert YUV420 image to RGB, then encode to JPEG
    final img.Image imgFrame = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: Uint8List.fromList(_yuv420toRgb(image)).buffer,
    );

    // Encode the image as JPEG
    final List<int> jpegBytes = img.encodeJpg(imgFrame);
    return jpegBytes;
  }

 // Convert YUV420 to RGB
  List<int> _yuv420toRgb(CameraImage image) {
    int width = image.width;
    int height = image.height;
    List<int> output = List.filled(width * height * 3, 0);

    // Get Y, U, and V planes
    Plane yPlane = image.planes[0];
    Plane uPlane = image.planes[1];
    Plane vPlane = image.planes[2];

    // Debug prints to check plane sizes
    print('Y plane length: ${yPlane.bytes.length}');
    print('U plane length: ${uPlane.bytes.length}');
    print('V plane length: ${vPlane.bytes.length}');

    int yIndex = 0, uvIndex = 0;
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        int y = yPlane.bytes[yIndex];
        int u = uPlane.bytes[uvIndex];
        int v = vPlane.bytes[uvIndex];

        // YUV to RGB conversion
        int r = (y + (1.402 * (v - 128))).clamp(0, 255).toInt();
        int g = (y - (0.344136 * (u - 128)) - (0.714136 * (v - 128)))
            .clamp(0, 255)
            .toInt();
        int b = (y + (1.772 * (u - 128))).clamp(0, 255).toInt();

        int pixelIndex = (row * width + col) * 3;
        output[pixelIndex] = r;
        output[pixelIndex + 1] = g;
        output[pixelIndex + 2] = b;

        yIndex++; // Move to the next Y pixel

        if (yIndex >= yPlane.bytes.length)
          break; // Prevent overflows in Y-plane
        if (uvIndex >= uPlane.bytes.length || uvIndex >= vPlane.bytes.length)
          break; // Prevent overflow in UV-planes
        if (col % 2 == 0 && row % 2 == 0)
          uvIndex++; // Increment UV index every 2x2 pixels
      }
      if (yIndex >= yPlane.bytes.length) break;
    }
    return output;
  }


  Future<void> sendToAPI(Uint8List bytes) async {
    print('Sending frame to API...');
    final url = Uri.parse(
        'http://112.134.145.207:8000/process-image/'); // Ensure the correct API endpoint

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(
            http.MultipartFile.fromBytes('file', bytes, filename: 'frame.jpg'));

      var response = await request.send(); // Send the request

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody); // Decode the response to JSON
        print("Response from API: $data");

        // Process the response and update the UI
        if (data['counted'] == true) {
          setState(() {
            repCount++; // Increment repetition count
          });
        }
      } else {
        print('Failed to send frame to API');
      }
    } catch (e) {
      print('Error sending to API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Exercise Title
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Overhead Press - Set 1',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF21007E),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Camera Feed or Loading Indicator
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          // Reps Counter
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$repCount / 10',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF21007E),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Reps',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Buttons (Help, Reset, Skip)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Help Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your help functionality here
                  },
                  icon: Icon(Icons.help_outline),
                  label: Text('Help'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21007E),
                  ),
                ),
                // Reset Button
                ElevatedButton.icon(
                  onPressed: resetReps, // Reset button functionality
                  icon: Icon(Icons.refresh, color: const Color(0xFFEAB804)),
                  label: Text('Reset', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB804),
                  ),
                ),
                // Skip Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your skip functionality here
                  },
                  icon: Icon(Icons.skip_next),
                  label: Text('Skip'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(179, 175, 2, 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

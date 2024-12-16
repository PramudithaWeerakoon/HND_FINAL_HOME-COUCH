import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int repCount = 0; // Repetition counter
  List<PixelLocation> pixelLocations = []; // Store pixel locations with color

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
    final img.Image imgFrame = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: Uint8List.fromList(_yuv420toRgb(image)).buffer,
    );
    final List<int> jpegBytes = img.encodeJpg(imgFrame);
    return jpegBytes;
  }

  // Convert YUV420 to RGB
  List<int> _yuv420toRgb(CameraImage image) {
    int width = image.width;
    int height = image.height;
    List<int> output = List.filled(width * height * 3, 0);

    Plane yPlane = image.planes[0];
    Plane uPlane = image.planes[1];
    Plane vPlane = image.planes[2];

    int yIndex = 0, uvIndex = 0;
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        int y = yPlane.bytes[yIndex];
        int u = uPlane.bytes[uvIndex];
        int v = vPlane.bytes[uvIndex];

        int r = (y + (1.402 * (v - 128))).clamp(0, 255).toInt();
        int g = (y - (0.344136 * (u - 128)) - (0.714136 * (v - 128)))
            .clamp(0, 255)
            .toInt();
        int b = (y + (1.772 * (u - 128))).clamp(0, 255).toInt();

        int pixelIndex = (row * width + col) * 3;
        output[pixelIndex] = r;
        output[pixelIndex + 1] = g;
        output[pixelIndex + 2] = b;

        yIndex++;
        if (yIndex >= yPlane.bytes.length) break;
        if (uvIndex >= uPlane.bytes.length || uvIndex >= vPlane.bytes.length) break;
        if (col % 2 == 0 && row % 2 == 0) uvIndex++;
      }
      if (yIndex >= yPlane.bytes.length) break;
    }
    return output;
  }

  Future<void> sendToAPI(Uint8List bytes) async {
    print('Sending frame to API...');
    final url = Uri.parse('http://172.16.101.51:8080/process_frame');

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'frame.jpg'));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        print("Response from API: $data");

        if (data['counted'] == true) {
          setState(() {
            // Extract pixel locations and form quality
            pixelLocations = _extractPixelLocations(data);
            
            // Check if both right and left shoulder are green
            bool bothAreGreen = _checkBothShouldersGreen(data);
            
            // If both are green, increment the repetition count
            if (bothAreGreen) {
              repCount++;
            }
          });

          // Clear pixel locations after a short delay
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              pixelLocations = [];
            });
          });
        }
      } else {
        print('Failed to send frame to API');
      }
    } catch (e) {
      print('Error sending to API: $e');
    }
  }

  bool _checkBothShouldersGreen(Map<String, dynamic> data) {
    // Check the status of both shoulders from the form_quality data
    var rightShoulder = data['form_quality']['right_shoulder_to_elbow_to_wrist'];
    var leftShoulder = data['form_quality']['left_shoulder_to_elbow_to_wrist'];

    // Check if both statuses are "green"
    return rightShoulder != null && rightShoulder['status'] == 'green' &&
           leftShoulder != null && leftShoulder['status'] == 'green';
  }

  List<PixelLocation> _extractPixelLocations(Map<String, dynamic> data) {
    List<PixelLocation> locations = [];
    if (data['form_quality'] != null) {
      var rightShoulder = data['form_quality']['right_shoulder_to_elbow_to_wrist'];
      if (rightShoulder != null && rightShoulder['pixel_loc_right_shoulder'] != null) {
        var loc = rightShoulder['pixel_loc_right_shoulder'];
        locations.add(PixelLocation(Offset(loc[0].toDouble(), loc[1].toDouble()), rightShoulder['status']));
      }
      var leftShoulder = data['form_quality']['left_shoulder_to_elbow_to_wrist'];
      if (leftShoulder != null && leftShoulder['pixel_loc_left_shoulder'] != null) {
        var loc = leftShoulder['pixel_loc_left_shoulder'];
        locations.add(PixelLocation(Offset(loc[0].toDouble(), loc[1].toDouble()), leftShoulder['status']));
      }
    }
    return locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? Stack(
                      children: [
                        CameraPreview(_cameraController!), // Camera feed
                        CustomPaint(
                          painter: OverlayPainter(pixelLocations, _cameraController!), // CustomPainter for overlay
                          size: Size(double.infinity, double.infinity), // Ensure size matches the container
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
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
        ],
      ),
    );
  }
}

// CustomPainter to overlay pixel locations on the camera feed
class OverlayPainter extends CustomPainter {
  final List<PixelLocation> pixelLocations;
  final CameraController cameraController;

  OverlayPainter(this.pixelLocations, this.cameraController);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintGreen = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final Paint paintRed = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final double scaleX = size.width / cameraController.value.previewSize!.width;
    final double scaleY = size.height / cameraController.value.previewSize!.height;

    for (var location in pixelLocations) {
      var position = location.offset;
      var color = location.status == 'green' ? paintGreen : paintRed;

      // Scale the pixel location
      var scaledX = position.dx * scaleX;
      var scaledY = position.dy * scaleY;

      // Draw a circle at the position
      canvas.drawCircle(Offset(scaledX, scaledY), 10, color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PixelLocation {
  final Offset offset;
  final String status;

  PixelLocation(this.offset, this.status);
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'db_connection.dart'; // Import the database connection
import 'congratsScreen.dart';

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

      _cameraController?.startImageStream((CameraImage image) {
        captureFrame(image);
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
      repCount = 0; // Reset repetition counter
    });
  }

  Future<void> captureFrame(CameraImage image) async {
    try {
      final bytes = await _convertImageToBytes(image);
      sendToAPI(Uint8List.fromList(bytes));
    } catch (e) {
      print('Error capturing frame: $e');
    }
  }

  Future<List<int>> _convertImageToBytes(CameraImage image) async {
    final img.Image imgFrame = img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: Uint8List.fromList(_yuv420toRgb(image)).buffer,
    );
    final List<int> jpegBytes = img.encodeJpg(imgFrame);
    return jpegBytes;
  }

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
        if (col % 2 == 0 && row % 2 == 0) uvIndex++;
      }
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
            pixelLocations = _extractPixelLocations(data);
            if (_checkBothShouldersGreen(data)) {
              repCount++;
              handleRepCompletion(); // Call database save when repCount reaches 10
            }
          });

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
    var rightShoulder = data['form_quality']['right_shoulder_to_elbow_to_wrist'];
    var leftShoulder = data['form_quality']['left_shoulder_to_elbow_to_wrist'];

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

  Future<void> handleRepCompletion() async {
    if (repCount == 10) {
      final db = DatabaseConnection();
      try {
        await db.saveExerciseData(
          ueSets: 1,
          ueReps: 10,
          ueDuration: 60, // Example duration
          dayNumber: DateTime.now().day,
          weekNumber: DateTime.now().toIso8601String(), // Save raw date
        );
        print("Exercise data saved successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CongratulationsScreen()),
        );
      } catch (e) {
        print("Error saving exercise data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
              color: const Color(0xFF21007E),
              borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
              'Bicep Curls - Set 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              ),
            ),
            ),
          Expanded(
  child: Container(
    width: double.infinity, // Ensure the container takes the full width
    margin: EdgeInsets.symmetric(horizontal:23.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: _cameraController != null && _cameraController!.value.isInitialized
        ? Stack(
            children: [
              CameraPreview(_cameraController!),
              CustomPaint(
                painter: OverlayPainter(pixelLocations, _cameraController!),
                size: Size(double.infinity, double.infinity),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator()),
  ),
),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$repCount / 10',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF21007E))),
              SizedBox(width: 8),
              Text('Reps', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: resetReps,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB804)),
                  icon: Icon(Icons.refresh, color: const Color.fromARGB(255, 255, 255, 255)),
                  label: Text('Reset', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF21007E)),
                  icon: Icon(Icons.help_outline, color: Colors.white),
                  label: Text('Help', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB30000)),
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  label: Text('Skip', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
    ..color = const Color.fromARGB(255, 206, 203, 8)
    ..style = PaintingStyle.fill;

  final Paint paintOuterCircle = Paint()
    ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(1) // Semi-transparent black for outer circle
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0; // Thickness of the outer circle

  final double previewWidth = cameraController.value.previewSize!.height;
  final double previewHeight = cameraController.value.previewSize!.width;

  final double scaleX = size.width / previewWidth;
  final double scaleY = size.height / previewHeight;

  for (var location in pixelLocations) {
    // Swap scaledX and scaledY to align dots along the x-axis
    var scaledX = location.offset.dy * scaleX; // Use y-coordinate for x-axis
    var scaledY = location.offset.dx * scaleY; // Use x-coordinate for y-axis

    // Draw the outer circle first
    canvas.drawCircle(Offset(scaledX, scaledY), 20, paintOuterCircle);

    // Draw the inner dot
    canvas.drawCircle(Offset(scaledX, scaledY), 10, location.status == 'green' ? paintGreen : paintRed);
  }
}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PixelLocation {
  final Offset offset;
  final String status;

  PixelLocation(this.offset, this.status);
}
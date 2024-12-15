import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart';
import 'cameraset2.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key});

  @override
  _RestScreenState createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  late Timer _timer;
  int _remainingTime = 180; // Mock initial rest time in seconds
  bool showGif = false;

  // Mock data from database
  final nextExercise = {
    'name': 'Bicep Curls',
    'sets': 2,
    'reps': 10,
    'duration': 8,
    'gifUrl': 'lib/assets/bicepcurls.gif', // Adjusted asset path
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

void _startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_remainingTime > 0) {
      setState(() {
        _remainingTime--;
      });
    } else {
      _timer.cancel();
      // Navigate to CameraScreenSet2
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CameraScreenSet2()),
      );
    }
  });
}


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _add20Seconds() {
    setState(() {
      _remainingTime += 20;
    });
  }

  void _skipRest() {
    setState(() {
      _remainingTime = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Congratulations! Bicep Curls \nset 1 Completed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Color(0xFF000000), // Black
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Rest",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Color(0xFF000000), // Black
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "$minutes : $seconds",
                style: const TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Color(0xFF000000), // Black
                ),
              ),
              const SizedBox(height: 20),
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton.icon(
      onPressed: _add20Seconds,
      icon: const Icon(Icons.add, color: Colors.white), // White icon
      label: const Text("+20s", style: TextStyle(color: Colors.white)), // White text
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF21007E), // Purple color from Figma
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        textStyle: const TextStyle(fontFamily: 'Inter'),
      ),
    ),
    const SizedBox(width: 20),
    ElevatedButton.icon(
      onPressed: _skipRest,
      icon: const Icon(Icons.skip_next, color: Colors.white), // White icon
      label: const Text("Skip", style: TextStyle(color: Colors.white)), // White text
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB30000), // Red color from Figma
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        textStyle: const TextStyle(fontFamily: 'Inter'),
      ),
    ),
  ],
),

              const SizedBox(height: 40),
              const Text(
                "Next up",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Color(0xFF000000), // Black
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showGif = !showGif; // Toggle GIF visibility
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF), // White
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, size: 30, color: Color(0xFF000000)),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nextExercise['name'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF000000), // Black
                                ),
                              ),
                              Text(
                                "${nextExercise['sets']} Sets | ${nextExercise['reps']} Reps",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFF626060), // Grey
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            "${nextExercise['duration']} min",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF626060), // Grey
                            ),
                          ),
                        ],
                      ),
                      if (showGif) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(nextExercise['gifUrl'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

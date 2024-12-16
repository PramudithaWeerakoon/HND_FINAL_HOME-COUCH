import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'db_connection.dart';

// Placeholder for Gemini API Key
const String apiKey = 'AIzaSyCdyu5kUDnS-Igl4ZoSzMgiz4umASepWJg';

// Full dataset as a string
const String dataSet = '''
DATA-SET
[
  {
    "exercise_id": "ex001",
    "name": "Dumbbell Bench Press",
    "description": "Lie on your back on a bench, dumbbells in each hand, and press them up until your arms are fully extended.",
    "target_muscles": ["Chest", "Triceps"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex002",
    "name": "Dumbbell Shoulder Press",
    "description": "Sit on a bench with back support, hold the dumbbells at shoulder height, and press them upward until arms are extended.",
    "target_muscles": ["Shoulders"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex003",
    "name": "Dumbbell Rows",
    "description": "Stand with feet shoulder-width apart, lean forward and pull a dumbbell towards your hip.",
    "target_muscles": ["Back", "Biceps"],
    "equipment_needed": ["Dumbbells"]
  },
  {
    "exercise_id": "ex004",
    "name": "Goblet Squats",
    "description": "Hold a dumbbell vertically at chest height, squat down and back up.",
    "target_muscles": ["Quadriceps", "Glutes"],
    "equipment_needed": ["Dumbbell"]
  },
  {
    "exercise_id": "ex005",
    "name": "Push-ups",
    "description": "Perform a push-up by lowering your chest to the ground and pushing back up.",
    "target_muscles": ["Chest", "Shoulders", "Triceps"],
    "equipment_needed": ["Bodyweight"]
  },
  {
    "exercise_id": "ex006",
    "name": "Plank",
    "description": "Hold a plank position by balancing on your forearms and toes, keeping your body straight.",
    "target_muscles": ["Core"],
    "equipment_needed": ["Bodyweight"]
  }
  {
    "exercise_id": "ex006",
    "name": "Plank",
    "description": "Hold a plank position by balancing on your forearms and toes, keeping your body straight.",
    "target_muscles": ["Core"],
    "equipment_needed": ["Bodyweight"]
  },
  {
    "exercise_id": "ex007",
    "name": "Kettlebell Swings",
    "description": "Swing a kettlebell between your legs and up to shoulder height by driving your hips forward.",
    "target_muscles": ["Glutes", "Hamstrings", "Core"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex008",
    "name": "Kettlebell Clean and Press",
    "description": "Clean a kettlebell from the floor to your shoulder, then press it overhead.",
    "target_muscles": ["Shoulders", "Arms", "Core"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex009",
    "name": "Barbell Squat",
    "description": "With a barbell on your shoulders, squat down while keeping your back straight.",
    "target_muscles": ["Quadriceps", "Glutes", "Hamstrings"],
    "equipment_needed": ["Barbell"]
  },
  {
    "exercise_id": "ex010",
    "name": "Barbell Deadlift",
    "description": "Lift a barbell from the ground by extending your hips and knees, keeping the back straight.",
    "target_muscles": ["Hamstrings", "Glutes", "Lower Back"],
    "equipment_needed": ["Barbell"]
  },
  {
    "exercise_id": "ex011",
    "name": "Barbell Overhead Press",
    "description": "Press a barbell overhead from shoulder height to full extension.",
    "target_muscles": ["Shoulders", "Triceps"],
    "equipment_needed": ["Barbell"]
  },
  {
    "exercise_id": "ex012",
    "name": "Barbell Bench Press",
    "description": "Lie on a bench and press a barbell upward from chest level.",
    "target_muscles": ["Chest", "Triceps"],
    "equipment_needed": ["Barbell", "Bench"]
  },
  {
    "exercise_id": "ex013",
    "name": "Incline Dumbbell Press",
    "description": "Set a bench to an incline and press the dumbbells upward from shoulder height.",
    "target_muscles": ["Chest", "Shoulders", "Triceps"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex014",
    "name": "Dumbbell Chest Press",
    "description": "Lie flat on a bench and press the dumbbells from chest level upward until arms are extended.",
    "target_muscles": ["Chest", "Triceps"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex015",
    "name": "Dumbbell Flyes",
    "description": "Lie on a bench and extend your arms to the sides with a slight bend in the elbows, then bring them together above your chest.",
    "target_muscles": ["Chest"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex016",
    "name": "Shoulder Taps",
    "description": "In a plank position, tap your shoulder with the opposite hand while keeping your body stable.",
    "target_muscles": ["Core", "Shoulders"],
    "equipment_needed": ["Bodyweight"]
  },
  {
    "exercise_id": "ex017",
    "name": "Bicep Curls",
    "description": "Stand with a dumbbell in each hand, arms at your sides, curl the weights up to shoulder level.",
    "target_muscles": ["Biceps"],
    "equipment_needed": ["Dumbbells"]
  },
  {
    "exercise_id": "ex018",
    "name": "Dumbbell Skull Crushers",
    "description": "Lie on a bench and hold a dumbbell above your head, lower it behind your head, then extend it back up.",
    "target_muscles": ["Triceps", "Chest"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex019",
    "name": "Hanging Leg Raises",
    "description": "Hang from a pull-up bar and raise your legs towards your chest.",
    "target_muscles": ["Abs", "Hip Flexors"],
    "equipment_needed": ["Bodyweight"]
  },
  {
    "exercise_id": "ex020",
    "name": "Dumbbell Side Plank",
    "description": "Hold a dumbbell in one hand and perform a side plank, maintaining balance on one arm.",
    "target_muscles": ["Core", "Shoulders"],
    "equipment_needed": ["Dumbbell"]
  },
  {
    "exercise_id": "ex021",
    "name": "Kettlebell Windmill",
    "description": "Hold a kettlebell overhead and rotate your body, reaching down towards your opposite foot.",
    "target_muscles": ["Core", "Shoulders"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex022",
    "name": "Dumbbell Russian Twists",
    "description": "Sit on the floor with knees bent, lean back slightly and twist your torso side to side while holding a dumbbell.",
    "target_muscles": ["Abs", "Obliques"],
    "equipment_needed": ["Dumbbell"]
  },
  {
    "exercise_id": "ex023",
    "name": "Lateral Raises",
    "description": "Hold a dumbbell in each hand and raise them to the side until they are shoulder height.",
    "target_muscles": ["Shoulders"],
    "equipment_needed": ["Dumbbells"]
  },
  {
    "exercise_id": "ex024",
    "name": "Barbell Bent-over Row",
    "description": "Bend over at the waist and pull a barbell towards your stomach, keeping your back straight.",
    "target_muscles": ["Back", "Biceps"],
    "equipment_needed": ["Barbell"]
  },
  {
    "exercise_id": "ex025",
    "name": "Kettlebell Goblet Squat",
    "description": "Hold a kettlebell at chest level and squat down, keeping your chest up.",
    "target_muscles": ["Quadriceps", "Glutes"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex026",
    "name": "Kettlebell Shoulder Press",
    "description": "Hold a kettlebell at shoulder height and press it overhead until your arm is fully extended.",
    "target_muscles": ["Shoulders", "Triceps"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex027",
    "name": "Kettlebell Deadlift",
    "description": "Stand with a kettlebell in front of you, bend at the hips, and lift the kettlebell by extending your hips and knees.",
    "target_muscles": ["Hamstrings", "Glutes"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex028",
    "name": "Kettlebell Sumo Deadlift",
    "description": "Stand with feet wide apart and grip the kettlebell between your legs, then stand up by extending your hips and knees.",
    "target_muscles": ["Hamstrings", "Glutes"],
    "equipment_needed": ["Kettlebell"]
  },
  {
    "exercise_id": "ex029",
    "name": "Dumbbell Front Raises",
    "description": "Stand with a dumbbell in each hand at your sides and raise the weights to shoulder height in front of you.",
    "target_muscles": ["Shoulders"],
    "equipment_needed": ["Dumbbells"]
  },
  {
    "exercise_id": "ex030",
    "name": "Barbell Front Squats",
    "description": "Hold a barbell across your chest and squat down, keeping your elbows up and back straight.",
    "target_muscles": ["Quadriceps", "Glutes"],
    "equipment_needed": ["Barbell"]
  },
  {
    "exercise_id": "ex031",
    "name": "Incline Dumbbell Press",
    "description": "Set a bench to an incline and press the dumbbells upward from shoulder height.",
    "target_muscles": ["Chest", "Shoulders", "Triceps"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex032",
    "name": "Dumbbell Chest Press",
    "description": "Lie flat on a bench and press the dumbbells from chest level upward until arms are extended.",
    "target_muscles": ["Chest", "Triceps"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex033",
    "name": "Dumbbell Flyes",
    "description": "Lie on a bench and extend your arms to the sides with a slight bend in the elbows, then bring them together above your chest.",
    "target_muscles": ["Chest"],
    "equipment_needed": ["Dumbbells", "Bench"]
  },
  {
    "exercise_id": "ex034",
    "name": "Shoulder Taps",
    "description": "In a plank position, tap your shoulder with the opposite hand while keeping your body stable.",
    "target_muscles": ["Core", "Shoulders"],
    "equipment_needed": ["Bodyweight"]
  },
  {
    "exercise_id": "ex035",
    "name": "Bicep Curls",
    "description": "Stand with a dumbbell in each hand, arms at your sides, curl the weights up to shoulder level.",
    "target_muscles": ["Biceps"],
    "equipment_needed": ["Dumbbells"]
  }

]
''';

// Desired output structure
const String outputStructure = '''
Provide a workout plan tailored to the user metrics strictly following this JSON format:
{
  "workout_plan": [
    {
      "day": "Day 1",
      "workout": [
        {"id":"ex001","exercise": "Dumbbell Bench Press", "sets": 3, "reps": "8", "rest": "60 seconds"},
        {"id":"ex002","exercise": "Dumbbell Shoulder Press", "sets": 3, "reps": "8", "rest": "60 seconds"},
        {"id":"ex003","exercise": "Dumbbell Rows", "sets": 3, "reps": "12", "rest": "60 seconds"}
      ]
    },
    {
      "day": "Day 2",
      "workout": [
        // ... exercises for Day 2 ...
      ]
    },
    {
      "day": "Day 3",
      "workout": [
        // ... exercises for Day 3 ... 
      ]
    }
  ]
}
Make sure to output the JSON file only, no additional text.
''';

// Save the JSON response to a file
Future<void> saveJsonToFile(String jsonContent) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/workout_plan.json';
    final file = File(filePath);

    await file.writeAsString(jsonContent);
    print("Workout plan saved successfully to: $filePath");
  } catch (e) {
    print("Error saving JSON file: $e");
  }
}

// Generate a workout plan
Future<Map<String, dynamic>> generateWorkoutPlan() async {
  print("Generating workout plan...");
  final db = DatabaseConnection();
  final userMetrics = await db.fetchUserFitnessDetails();

  // Build the complete prompt
  final prompt = '''
$dataSet
Based on this dataset and the given user input metrics:
${jsonEncode(userMetrics)}
$outputStructure
''';

  print("Prompt generated successfully.");
  print("Prompt: $prompt");

  try {
    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {"parts": [{"text": prompt}]}
        ]
      }),
    );

    if (response.statusCode == 200) {
      print("Workout plan generated successfully.");
      final result = jsonDecode(response.body);

      // Extract and clean the content
      String content = result['candidates'][0]['content']['parts'][0]['text'];
      content = content.replaceAll("```json", "").replaceAll("```", "").trim();

      print("Cleaned Content: $content");
      final List<Map<String, dynamic>> workoutPlanList = List<Map<String, dynamic>>.from(jsonDecode(content)['workout_plan']);
      db.insertWorkoutPlan(workoutPlanList);

      // Save the JSON response to a file
      await saveJsonToFile(content);

      // Decode and return the cleaned JSON
      return jsonDecode(content);
       // Insert workout plan into the database
      
} else {
      print("Error in Gemini API Response: ${response.body}");
      throw Exception("Failed to fetch workout plan from Gemini API");
    }
  } catch (e) {
    print("Error generating workout plan: $e");
    throw Exception("Failed to generate workout plan");
  }
}

// CustomizedPlanScreen to display the chart and generated workout plan
class CustomizedPlanScreen extends StatefulWidget {
  const CustomizedPlanScreen({super.key});

  @override
  State<CustomizedPlanScreen> createState() => _CustomizedPlanScreenState();
}

class _CustomizedPlanScreenState extends State<CustomizedPlanScreen> {
  Map<String, dynamic>? workoutPlan;

  @override
  void initState() {
    super.initState();
    loadWorkoutPlan();
  }

  Future<void> loadWorkoutPlan() async {
    print("Loading workout plan...");
    try {
      final plan = await generateWorkoutPlan();
      setState(() {
        workoutPlan = plan;
      });
      print("Workout plan loaded successfully.");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Your Journey\nBegins Here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Your Tailored Plan Is Ready!",
                style: TextStyle(fontSize: 25, color: Colors.grey[700]),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 3,
                          minY: 60,
                          maxY: 70,
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 70),
                                FlSpot(1, 68),
                                FlSpot(2, 65),
                                FlSpot(3, 62),
                              ],
                              isCurved: true,
                              color: Colors.yellow,
                              barWidth: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Generated Plan:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    workoutPlan == null
                        ? CircularProgressIndicator()
                        : Text(
                            const JsonEncoder.withIndent("  ")
                                .convert(workoutPlan),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: "Customized Workout Plan",
    home: CustomizedPlanScreen(),
  ));
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:q1/widgets/gradient_background.dart';
import 'q19.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({super.key});

  @override
  _FitnessGoalPageState createState() => _FitnessGoalPageState();
}

class _FitnessGoalPageState extends State<SelectDate> {
  DateTime? selectedDate;
  String duration = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        final today = DateTime.now();
        final diffMonths = (pickedDate.year - today.year) * 12 + pickedDate.month - today.month;
        duration = 'Duration : ${diffMonths.toString().padLeft(2, '0')} Months';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Lets Set Your\nFitness Goal!",
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,fontFamily: 'Inter' ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Choose your target date",
                  style: TextStyle(fontSize: 23, color: Colors.black,fontFamily: 'Inter',fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Select Date"
                              : DateFormat('dd/MM/yyyy').format(selectedDate!),
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
                if (selectedDate != null) ...[
                  const SizedBox(height: 90),
                  Text(
                    duration,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      // Floating action buttons for navigation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 32,
            child: FloatingActionButton(
              heroTag: 'back_button',
              backgroundColor: const Color(0xFF21007E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          if (selectedDate != null)
            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                heroTag: 'next_button',
                backgroundColor: const Color(0xFF21007E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomizedPlanScreen()),
                  );
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
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

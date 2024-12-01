import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final terms = [
      "1. The app is designed to provide general fitness guidance and not medical advice.",
      "2. Always consult a physician or healthcare provider before starting a new fitness routine.",
      "3. Users are responsible for determining their own fitness levels and limitations.",
      "4. Exercise data provided by the app is based on general recommendations and may vary for individuals.",
      "5. The app requires an internet connection for certain features to function.",
      "6. Users must ensure they have proper equipment and safe space for exercises.",
      "7. Do not perform exercises if you experience pain, dizziness, or discomfort.",
      "8. The app is not liable for injuries sustained during workouts.",
      "9. Progress data is stored locally or on the user's device; backup responsibility lies with the user.",
      "10. The app is optimized for general fitness goals, not specific medical conditions.",
      "11. Rest and hydration are essential parts of any workout routine.",
      "12. Users are advised to wear proper attire and footwear during exercises.",
      "13. Warm-up and cool-down exercises are critical for safety and performance.",
      "14. Overtraining can lead to injuries; follow the app’s recommended rest periods.",
      "15. Do not share your account or data with others.",
      "16. The app offers suggestions but cannot guarantee fitness results.",
      "17. Customization of workout plans requires accurate user inputs.",
      "18. Users should regularly update their fitness progress in the app for accurate recommendations.",
      "19. The app may send notifications and reminders to encourage consistency.",
      "20. The app does not monitor users in real-time; use features like AI coaching responsibly.",
      "21. Equipment details provided in the app must match what the user possesses.",
      "22. Ensure a stable internet connection for syncing progress with the server.",
      "23. Parental consent is required for users under 18 years of age.",
      "24. Community challenges and leaderboards are for motivation, not competition.",
      "25. Users must respect community guidelines in social features of the app.",
      "26. Modifying exercises outside the app’s guidance is at the user’s risk.",
      "27. The app may include premium features requiring in-app purchases.",
      "28. Refund policies for premium features are subject to app store guidelines.",
      "29. The app collects anonymized data to improve features and user experience.",
      "30. Users must update the app regularly to access new features and security patches.",
      "31. The app assumes no responsibility for incorrect data input by the user.",
      "32. Exercise animations and instructions are for reference; verify posture with a professional if unsure.",
      "33. The app does not store sensitive personal health data without user consent.",
      "34. Third-party integrations like fitness trackers are supported but may require separate agreements.",
      "35. The app’s AI-based coaching depends on the quality of the user’s device camera.",
      "36. Users are responsible for keeping their devices charged during workouts.",
      "37. Avoid distractions such as messaging or calls during app-guided exercises.",
      "38. The app supports general goals like strength, endurance, or weight loss but may not cover all niche goals.",
      "39. Users must comply with their local laws when using the app outdoors or in gyms.",
      "40. Breach of these terms may lead to restricted access to app features."
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: terms
                .map((term) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        term,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

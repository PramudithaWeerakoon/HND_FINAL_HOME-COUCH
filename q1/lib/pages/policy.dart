import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Effective Date: [Insert Date]',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                '''
At [Your App Name], we are committed to protecting your privacy. This Privacy Policy outlines the types of information we collect and how we use, store, and protect that information.

1. Information We Collect:
We collect information to provide better services to our users. The types of information we may collect include:
- Personal Information (e.g., name, email address)
- Health and Fitness Data (e.g., workout routines, meal plans)
- Device Information
- Location Data (if you opt-in)
- Usage Data
  
2. How We Use Your Information:
We use the information we collect to:
- Provide and improve our services
- Communicate with you
- Personalize user experience

3. How We Store Your Information:
Your data is securely stored. We take reasonable measures to protect your information.

4. Third-Party Services:
We may use third-party services such as Google Analytics and Firebase.

5. Sharing Your Information:
We do not share your personal data with third parties for marketing purposes unless required by law.

6. Your Rights:
You have the right to access, correct, or delete your data.

7. Changes to This Privacy Policy:
We may update this Privacy Policy from time to time. We will notify you of any significant changes.

8. Contact Us:
If you have any questions, please contact us at [Your Contact Information].
                ''',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

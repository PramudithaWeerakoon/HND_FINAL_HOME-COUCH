import 'package:flutter/material.dart';
import 'package:q1/widgets/gradient_background.dart'; // Make sure to adjust the path based on your folder structure
import 'carddetails.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = 'AI Coach PRO';
  String price = '\$9.99 / month';
  bool isReoccurring = true;
  String cardNumber = '**** **** **** 289'; // Initial masked card number

  void _removeSubscription() {
    setState(() {
      selectedPlan = 'Basic';
      price = 'Free';
    });
  }

  void _selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
      price = plan == 'Basic' ? 'Free' : '\$9.99 / month';
    });
  }

  void _toggleReoccurring() {
    setState(() {
      isReoccurring = !isReoccurring;
    });
  }

  void _updateCardNumber(String newCardNumber) {
    setState(() {
      // Mask all but the last four digits of the card number
      cardNumber = '**** **** **** ${newCardNumber.substring(newCardNumber.length - 4)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Subscriptions \n& Payments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildPaymentMethodCard(),
            const SizedBox(height: 30),
            const Text(
              'Subscription Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlanCard(
                    'AI Coach PRO',
                    '\$9.99 / month',
                    'Ai Driven Tailored Coaching, Real-Time Workout Feedback, Real-Time Coaching, Meal Plans etc.',
                    selectedPlan == 'AI Coach PRO',
                    'lib/assets/premium.png',
                  ),
                  const SizedBox(width: 16),
                  _buildPlanCard(
                    'Basic',
                    'Free',
                    'Limited Features. Free Workout Plan, Exercise Tutorials',
                    selectedPlan == 'Basic',
                    'lib/assets/basic.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.credit_card, color: Colors.blue[700]),
                ],
              ),
              TextButton(
                onPressed: () async {
                  final updatedCard = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetailsPage(),
                    ),
                  );
                  if (updatedCard != null) {
                    _updateCardNumber(updatedCard);
                  }
                },
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cardNumber, // Display the masked card number
            style: const TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Subscription Plan',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedPlan,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: selectedPlan != 'Basic' ? _removeSubscription : null,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFB30000),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 119, 119, 119),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Re-occurring',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Switch(
                value: isReoccurring,
                onChanged: (bool value) {
                  _toggleReoccurring();
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF21007E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, String description, bool isSelected, String imagePath) {
    return GestureDetector(
      onTap: () => _selectPlan(title),
      child: Container(
        width: 198,
        height: 125,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.black : const Color.fromARGB(255, 194, 193, 193),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF626060),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

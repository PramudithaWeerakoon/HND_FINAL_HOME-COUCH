import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:q1/widgets/gradient_background.dart'; // Make sure to adjust the path based on your folder structure

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({super.key});

  @override
  _CardDetailsPageState createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  String selectedCountry = 'United States';

  final _formKey = GlobalKey<FormState>();

  void _saveCardDetails() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _cardNumberController.text);
    }
  }

  final RegExp _cardNumberRegExp = RegExp(r'^[0-9]{16}$');
  final RegExp _cvcRegExp = RegExp(r'^[0-9]{3}$');
  final RegExp _postalCodeRegExp = RegExp(r'^[0-9]+$');

  bool _isExpiryValid(String expiry) {
    if (expiry.length != 5 || expiry[2] != '/') return false;

    final month = int.tryParse(expiry.substring(0, 2));
    final year = int.tryParse('20${expiry.substring(3)}');

    if (month == null || year == null) return false;

    final now = DateTime.now();
    return month >= 1 &&
        month <= 12 &&
        (year > now.year || (year == now.year && month >= now.month));
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Center(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Replace with subscription page background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabeledTextField(
                        label: 'Card number',
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        placeholder: '1234 1234 1234 1234',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Card number is required';
                          } else if (!_cardNumberRegExp.hasMatch(value)) {
                            return 'Enter a valid 16-digit card number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledTextField(
                              label: 'Expiry (MM / YY)',
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                              placeholder: 'MM / YY',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Expiry date is required';
                                } else if (!_isExpiryValid(value)) {
                                  return 'Enter a valid expiry date in the future';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLabeledTextField(
                              label: 'CVC',
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3)
                              ],
                              placeholder: 'CVC',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'CVC is required';
                                } else if (!_cvcRegExp.hasMatch(value)) {
                                  return 'Enter a valid 3-digit CVC';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabeledDropdown(
                              label: 'Country',
                              value: selectedCountry,
                              items: ['United States', 'Canada', 'UK'],
                              onChanged: (value) => setState(() => selectedCountry = value!),
                              placeholder: 'Select country',
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Country is required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLabeledTextField(
                              label: 'Postal code',
                              controller: _postalCodeController,
                              keyboardType: TextInputType.number,
                              placeholder: '90210',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Postal code is required';
                                } else if (!_postalCodeRegExp.hasMatch(value)) {
                                  return 'Enter a valid postal code';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                        Center(
                        child: ElevatedButton(
                          onPressed: _saveCardDetails,
                          style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21007E), // Button background color
                          foregroundColor: Colors.white, // Button text color
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          ),
                          child: const Text('Save'),
                        ),
                        ),
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

  Widget _buildLabeledTextField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  required String placeholder,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      const SizedBox(height: 3),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 193, 192, 192)), // Change the color here
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ),
    ],
  );
}

  Widget _buildLabeledDropdown({
  required String label,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
  String? Function(String?)? validator,
  required String placeholder,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      const SizedBox(height: 4),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ),
    ],
  );
}
}

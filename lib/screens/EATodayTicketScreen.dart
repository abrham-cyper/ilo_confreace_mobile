import 'package:event_prokit/screens/PaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/main.dart';

import 'EAPurchaseScreen.dart';

class EATodayTicketScreen extends StatefulWidget {
  const EATodayTicketScreen({Key? key}) : super(key: key);

  @override
  _EATodayTicketScreenState createState() => _EATodayTicketScreenState();
}

class _EATodayTicketScreenState extends State<EATodayTicketScreen> {
  // Define controllers for form inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  
  // Form validation flag
  bool isFormValid = false;

  // Function to validate the form
  void validateForm() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          ageController.text.isNotEmpty &&
          genderController.text.isNotEmpty &&
          eventTypeController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Register for the event:', style: boldTextStyle(size: 18)),
              SizedBox(height: 16),
              
              // Name input field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) {
                  validateForm(); // Validate form whenever the value changes
                },
              ),
              SizedBox(height: 16),

              // Email input field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  validateForm();
                },
              ),
              SizedBox(height: 16),

              // Phone number input field
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  validateForm();
                },
              ),
              SizedBox(height: 16),

              // Address input field
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                onChanged: (value) {
                  validateForm();
                },
              ),
              SizedBox(height: 16),

              // Age input field
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  validateForm();
                },
              ),
              SizedBox(height: 16),

              // Gender input field (Dropdown)
              DropdownButtonFormField<String>(
                value: genderController.text.isNotEmpty ? genderController.text : null,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    genderController.text = value ?? '';
                  });
                  validateForm();
                },
              ),
              SizedBox(height: 16),

              // Event type input field (Dropdown)
              DropdownButtonFormField<String>(
                value: eventTypeController.text.isNotEmpty ? eventTypeController.text : null,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
                items: ['Conference', 'Workshop', 'Seminar']
                    .map((event) => DropdownMenuItem<String>(
                          value: event,
                          child: Text(event),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    eventTypeController.text = value ?? '';
                  });
                  validateForm();
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
  onTap: isFormValid
      ? () {
          // Navigate to PaymentScreen when form is valid
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentScreen()),
          );
        }
      : null, // Disable button if form is not valid
  child: Container(
    alignment: Alignment.center,
    margin: EdgeInsets.all(20),
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(colors: [primaryColor1, primaryColor2]),
      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6, spreadRadius: 2)],
    ),
    child: Text(
      'Register Now'.toUpperCase(),
      style: boldTextStyle(color: white, size: 18),
    ),
  ),
),

    );
  }
}

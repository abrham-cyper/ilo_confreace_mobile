import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BecomePartener extends StatefulWidget {
  @override
  BecomePartenerState createState() => BecomePartenerState();
}

class BecomePartenerState extends State<BecomePartener> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  // Checkbox states
  bool isInternationalDevPartner = false;
  bool isInternationalCompany = false;
  bool isLocalCompany = false;

  // API endpoint
  final String apiUrl = 'http://49.13.202.68:5001/api/partnersapp';

  // Loading and feedback states
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    companyController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  // Function to get accessToken and packageId from SharedPreferences
  Future<Map<String, String?>> _getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken'); // Used as userId in Authorization header
    String? packageId = prefs.getString('packageid');     // Used as partnerId
    return {'accessToken': accessToken, 'packageId': packageId};
  }

  // Function to determine the partner type based on checkbox selection
  String? _getPartnerType() {
    if (isInternationalDevPartner) return 'international_dev_partner';
    if (isInternationalCompany) return 'international_company_local_gov';
    if (isLocalCompany) return 'local_company';
    return null;
  }

  // Function to submit the form data to the API
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? partnerType = _getPartnerType();
      if (partnerType == null) {
        toast('Please select a partner type');
        return;
      }

      // Get accessToken and packageId from SharedPreferences
      final authData = await _getAuthData();
      String? accessToken = authData['accessToken'];
      String? packageId = authData['packageId'];

      if (accessToken == null) {
        toast('Please log in to submit the form');
        return;
      }
      if (packageId == null) {
        toast('Package ID not found in storage');
        return;
      }

      // Prepare the data to send to the API
      final Map<String, dynamic> data = {
        'userId': accessToken, // Assuming userId is derived from accessToken or adjust accordingly
        'partnerId': packageId,
        'type': partnerType,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'companyName': companyController.text.trim(),
        'jobTitle': jobTitleController.text.trim(),
      };

      setState(() {
        isLoading = true;
        errorMessage = null;
        successMessage = null;
      });

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // Add Bearer token as per React code
          },
          body: jsonEncode(data),
        );

        final result = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() { 
            // successMessage = 'Participant registered successfully!';
            // Clear the form
            nameController.clear();
            emailController.clear();
            companyController.clear();
            jobTitleController.clear();
            isInternationalDevPartner = false;
            isInternationalCompany = false;
            isLocalCompany = false;
          });
          toast('Application submitted successfully!');
        } else {
          setState(() {
            errorMessage = result['message'] ?? 'Failed to submit application';
          });
          toast('Error: ${errorMessage}');
        }
      } catch (e) {
        print('Error submitting form: $e');
        setState(() {
          errorMessage = 'Failed to connect to the server';
        });
        toast('Failed to connect to the server');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Partner', style: boldTextStyle(color: white)),
        backgroundColor: primaryColor1,
        iconTheme: IconThemeData(color: white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Gradient Background
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor1, primaryColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join the 2025, 20th ILO Regional Conference',
                        style: boldTextStyle(size: 24, color: white),
                      ),
                      8.height,
                      Text(
                        'Partner with us and play a pivotal role in one of the most influential events in the region.',
                        style: secondaryTextStyle(size: 16, color: white),
                      ),
                    ],
                  ),
                ),
                16.height,

                // Partnership Opportunities
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partnership Opportunities:',
                        style: boldTextStyle(size: 18, color: primaryColor1),
                      ),
                      8.height,
                      _buildOpportunityItem(
                        'Exposure to a highly engaged international audience.',
                      ),
                      _buildOpportunityItem(
                        'Opportunity for networking with national, regional, and global stakeholders.',
                      ),
                      _buildOpportunityItem(
                        'Showcase your values, products, and initiatives in the spirit of South-South collaboration and international solidarity.',
                      ),
                      _buildOpportunityItem(
                        'Take part in espousing or advocating for a sustainable, inclusive, and fair world of work.',
                      ),
                    ],
                  ),
                ),
                16.height,

                // Are You? Section with Checkboxes
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Are You?',
                        style: boldTextStyle(size: 18, color: primaryColor1),
                      ),
                      8.height,
                      CheckboxListTile(
                        title: Text(
                          'International Development Partner (bi/multi-lateral organisation, NGO, IFIs)',
                          style: secondaryTextStyle(size: 14),
                        ),
                        value: isInternationalDevPartner,
                        onChanged: (value) {
                          setState(() {
                            isInternationalDevPartner = value!;
                            if (value) {
                              isInternationalCompany = false;
                              isLocalCompany = false;
                            }
                          });
                        },
                        activeColor: primaryColor1,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text(
                          'International Company and Local Governmental Organization/Public Authority',
                          style: secondaryTextStyle(size: 14),
                        ),
                        value: isInternationalCompany,
                        onChanged: (value) {
                          setState(() {
                            isInternationalCompany = value!;
                            if (value) {
                              isInternationalDevPartner = false;
                              isLocalCompany = false;
                            }
                          });
                        },
                        activeColor: primaryColor1,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Local Company',
                          style: secondaryTextStyle(size: 14),
                        ),
                        value: isLocalCompany,
                        onChanged: (value) {
                          setState(() {
                            isLocalCompany = value!;
                            if (value) {
                              isInternationalDevPartner = false;
                              isInternationalCompany = false;
                            }
                          });
                        },
                        activeColor: primaryColor1,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                16.height,

                // Input Fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Details',
                          style: boldTextStyle(size: 18, color: primaryColor1),
                        ),
                        8.height,
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your name';
                            return null;
                          },
                        ),
                        12.height,
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your email';
                            if (!value.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        12.height,
                        TextFormField(
                          controller: companyController,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your company name';
                            return null;
                          },
                        ),
                        12.height,
                        TextFormField(
                          controller: jobTitleController,
                          decoration: InputDecoration(
                            labelText: 'Job Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your job title';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                24.height,

                // Single Centered Send Button
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: primaryColor1.withOpacity(0.5),
                      foregroundColor: white,
                      textStyle: boldTextStyle(size: 18),
                      minimumSize: Size(200, 50),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => primaryColor1,
                      ),
                      overlayColor: MaterialStateProperty.all(primaryColor2.withOpacity(0.2)),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: white)
                        : Text('Send', style: boldTextStyle(color: white)),
                  ),
                ),
                16.height,

                // Success/Error Messages
                if (successMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      successMessage!,
                      style: TextStyle(color: Colors.green, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                32.height,
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(color: primaryColor1),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widget for opportunity items
  Widget _buildOpportunityItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 16, color: primaryColor1),
        8.width,
        Expanded(
          child: Text(
            text,
            style: secondaryTextStyle(size: 14),
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 4);
  }
}
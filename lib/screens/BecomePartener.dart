import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Partner', style: boldTextStyle(color: white)),
        backgroundColor: primaryColor1,
        iconTheme: IconThemeData(color: white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                      setState(() => isInternationalDevPartner = value!);
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
                      setState(() => isInternationalCompany = value!);
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
                      setState(() => isLocalCompany = value!);
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    toast('Form submitted successfully!');
                    // Add your submission logic here (e.g., API call)
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: primaryColor1.withOpacity(0.5),
                  foregroundColor: white,
                  textStyle: boldTextStyle(size: 18),
                  minimumSize: Size(200, 50), // Makes button wider
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => primaryColor1, // Solid color with splash effect
                  ),
                  overlayColor: MaterialStateProperty.all(primaryColor2.withOpacity(0.2)), // Splash effect
                ),
                child: Text('Send', style: boldTextStyle(color: white)),
              ),
            ),
            32.height,
          ],
        ),
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
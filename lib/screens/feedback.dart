import 'package:event_prokit/main.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

// Define a Spacing utility class for consistent gaps
class Spacing {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      toast("Feedback submitted successfully. Thank you!", bgColor: primaryColor1);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor1,
          title: Text(
            "Submit Feedback",
            style: boldTextStyle(color: white, size: 20, weight: FontWeight.w600),
          ),
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height, // Full screen height
          width: MediaQuery.of(context).size.width,   // Full screen width
          color: Colors.grey[50], // More professional off-white background
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Feedback Card
                  _buildFeedbackCard(context),
                  // Submit Button
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Feedback Card Widget
  Widget _buildFeedbackCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Spacing.large),
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feedback Form",
            style: boldTextStyle(size: 22, color: primaryColor1, weight: FontWeight.w700),
          ),
          SizedBox(height: Spacing.small),
          Text(
            "Your input is valuable to the Ethiopian Road Administration and the 20th ILO Regional Conference.",
            style: primaryTextStyle(size: 14, color: Colors.grey[600], weight: FontWeight.w400),
          ),
          SizedBox(height: Spacing.medium),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: Spacing.medium),
          _buildTextField(
            controller: _nameController,
            label: "Full Name",
            hint: "Enter your full name",
            validator: (value) => value!.isEmpty ? "Please enter your full name" : null,
          ),
          SizedBox(height: Spacing.medium),
          _buildTextField(
            controller: _emailController,
            label: "Email Address",
            hint: "Enter your email address",
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty || !value.contains('@') ? "Please enter a valid email address" : null,
          ),
          SizedBox(height: Spacing.medium),
          _buildTextField(
            controller: _feedbackController,
            label: "Your Feedback",
            hint: "Provide your feedback here",
            maxLines: 5,
            validator: (value) => value!.isEmpty ? "Please provide your feedback" : null,
          ),
        ],
      ),
    );
  }

  // Professional Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: boldTextStyle(size: 14, color: Colors.grey[800], weight: FontWeight.w600),
        ),
        SizedBox(height: Spacing.extraSmall),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: primaryTextStyle(size: 16, color: Colors.grey[900]),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: primaryTextStyle(size: 14, color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: primaryColor1, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: Spacing.medium, vertical: Spacing.small),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Professional Submit Button
  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: Spacing.large, vertical: Spacing.medium),
      color: white, // Match card background for seamless look
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor1,
          padding: EdgeInsets.symmetric(vertical: Spacing.medium),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 3,
          shadowColor: primaryColor1.withOpacity(0.3),
        ),
        child: _isSubmitting
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: white, strokeWidth: 2),
              )
            : Text(
                "Submit Feedback",
                style: boldTextStyle(size: 16, color: white, weight: FontWeight.w600),
              ),
      ),
    );
  }
}
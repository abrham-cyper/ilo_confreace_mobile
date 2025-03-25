import 'dart:convert';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:event_prokit/utils/EAColors.dart'; // Custom colors

class EAForgetPasswordScreen extends StatefulWidget {
  const EAForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _EAForgetPasswordScreenState createState() => _EAForgetPasswordScreenState();
}

class _EAForgetPasswordScreenState extends State<EAForgetPasswordScreen> {
  final TextEditingController emailOrNameController = TextEditingController();
  bool isLoading = false;

  // Function to send reset link via API
  Future<void> sendResetLink() async {
    String input = emailOrNameController.text.trim();

    if (input.isEmpty) {
      toast("Please enter your email");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/user/forgotPassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": input}),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog(input);
      } else {
        throw Exception('Forgot password failed: ${response.reasonPhrase}');
      }
    } catch (error) {
      toast("An error occurred: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show cool success dialog
  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor1, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 60),
              20.height,
              Text(
                "Success!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.height,
              Text(
                "A password reset link has been sent to $email. Please check your email and follow the instructions to reset your password.",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              20.height,
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Back to login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Back to Login",
                  style: TextStyle(color: primaryColor1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintTextColor = isDarkMode ? primaryColor1 : Colors.black54;
    final buttonColor = isDarkMode ? primaryColor1 : primaryColor1;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  20.height,
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  20.height,
                  Text(
                    "Enter your email to reset your password.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: primaryColor1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  40.height,
                  // Card Design without Shadows
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor1.withOpacity(0.2), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor1.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: emailOrNameController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: hintTextColor),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email, color: primaryColor1),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  30.height,
                  SizedBox(
                    width: context.width(),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 4, // Note: Elevation still applies a shadow here
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Send Reset Email",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  20.height,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Login",
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
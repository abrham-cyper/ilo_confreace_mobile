import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart'; // Custom colors

class EAForgetPasswordScreen extends StatefulWidget {
  const EAForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _EAForgetPasswordScreenState createState() => _EAForgetPasswordScreenState();
}

class _EAForgetPasswordScreenState extends State<EAForgetPasswordScreen> {
  final TextEditingController emailOrNameController = TextEditingController();
  bool isLoading = false;

  // Simulate sending email for password reset
  Future<void> sendResetLink() async {
    String input = emailOrNameController.text.trim();

    if (input.isEmpty) {
      toast("Please enter your email or full name");
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (input.contains('@') && input.contains('.')) {
      // Simulate email reset process
      toast("Password reset link sent to $input");
    } else {
      // Simulate full name reset handling
      toast("Password reset instructions sent to your registered email");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define background color and text color based on the theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintTextColor = isDarkMode ? primaryColor1 : Colors.black54;
    final buttonColor = isDarkMode ? primaryColor1 : primaryColor1;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor, // Set background color based on theme
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Image.asset(
                    'images/logo.png', // Path to your logo image
                    height:150, // Adjust height as needed
                    width: 150,  // Adjust width as needed
                    fit: BoxFit.cover, // Ensures the logo fits nicely
                  ),
                  20.height,
                  // Title
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1, // Set title text color based on theme
                    ),
                    textAlign: TextAlign.center,
                  ),
                  20.height,
                  // Subtitle or Instruction
                  Text(
                    "Enter your email or full name to reset your password.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: primaryColor1, // Set instruction text color based on theme
                    ),
                    textAlign: TextAlign.center,
                  ),
                  40.height, // Spacing

                  // Input field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor1,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailOrNameController,
                      decoration: InputDecoration(
                        hintText: "Email or Full Name",
                        hintStyle: TextStyle(color: hintTextColor), // Set hint text color
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: textColor), // Set text color based on theme
                    ),
                  ),
                  30.height, // Spacing

                  // Submit button
                  SizedBox(
                    width: context.width(),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor, // Set button color based on theme
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Send Reset Link",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  20.height, // Spacing

                  // Back to Login text
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                    child: Text(
                      "Back to Login",
                      style: TextStyle(
                        color: buttonColor, // Set color based on theme
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

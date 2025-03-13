import 'package:event_prokit/screens/Forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/screens/EASelectHashtagScreen.dart'; // Next screen

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For form validation
  bool isLoading = false; // To show loading state

  // Simulate authentication (replace with real auth logic, e.g., Firebase)
  Future<bool> authenticateUser(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulated delay
    // Replace with actual authentication logic
    return email.isNotEmpty && password.length >= 6; // Basic validation
  }

  // Handle login action
  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (await authenticateUser(email, password)) {
        toast('Login Successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EASelectHashtagScreen(name: "Dashboard")),
        );
      } else {
        toast('Invalid Credentials');
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0), // More spacious padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo at the top
                  Image.asset(
                    'images/logo.png', // Path to your logo image
                    height:150, // Adjust height as needed
                    width: 150,  // Adjust width as needed
                    fit: BoxFit.cover, // Ensures the logo fits nicely
                  ),
                  20.height, // Space between logo and title
                  // Add a gradient or bold font styling for a more refined welcome text
                  Text(
                    "Welcome to 20th ILO Regional Conference",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: primaryColor1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  20.height,
                  // Email Field with better styling
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: secondaryTextStyle(color: grey.withOpacity(0.8)),
                      prefixIcon: Icon(Icons.email_outlined, color: primaryColor1),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey.withOpacity(0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor1),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  20.height,
                  // Password Field with better styling
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: secondaryTextStyle(color: grey.withOpacity(0.8)),
                      prefixIcon: Icon(Icons.lock_outline, color: primaryColor1),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey.withOpacity(0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor1),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  40.height,
                  // Sign In Button with enhanced design
                  SizedBox(
                    width: context.width(),
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        shadowColor: primaryColor1.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(color: white, strokeWidth: 2),
                            )
                          : Text(
                              "Sign In",
                              style: boldTextStyle(color: white, size: 18),
                            ),
                    ),
                  ),
                  20.height,
                  // Forgot Password link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Forgot your password? ", style: secondaryTextStyle(color: grey)),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the EAForgetPasswordScreen when "Reset" is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EAForgetPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(color: primaryColor1, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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

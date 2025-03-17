import 'package:event_prokit/screens/Otp.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/screens/EASelectHashtagScreen.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessage;

  // API endpoint
  final String apiUrl = '${AppConstants.baseUrl}/api/user/signup';

  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Show success message about OTP
        toast(responseData['message']);
        return true;
      } else {
        setState(() {
          errorMessage = responseData['error'] ?? 'Registration failed';
        });
        toast(errorMessage);
        return false;
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: Please check your connection';
      });
      toast(errorMessage);
      return false;
    }
  }

  Future<void> handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();

      // Additional client-side validation
      if (password != confirmPassword) {
        setState(() {
          errorMessage = 'Passwords do not match';
          isLoading = false;
        });
        toast(errorMessage);
        return;
      }

      bool success = await registerUser(
        email: email,
        password: password,
      );

      setState(() => isLoading = false);

      // In your Signup screen's handleSignup method, replace the navigation part:
if (success) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Otp(email: email),
    ),
  );
}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome message
                    Text(
                      "Welcome to Our App!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryColor1,
                      ),
                    ),
                    15.height,
                    Text(
                      "Please fill out the details below to create an account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    20.height,

                    // Error message display
                    if (errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (errorMessage != null) 15.height,

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                    20.height,

                    // Confirm Password Field
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    20.height,

                    // Signup Button
                    SizedBox(
                      width: context.width(),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    countryController.dispose();
    super.dispose();
  }
}
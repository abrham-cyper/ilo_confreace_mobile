import 'package:event_prokit/main.dart';
import 'package:event_prokit/screens/EADashedBoardScreen.dart';
import 'package:event_prokit/screens/EAHomeScreen.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/screens/EASelectHashtagScreen.dart';
import 'package:event_prokit/screens/Forgetpassword.dart';
import 'package:uuid/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessage;

  final String apiUrl = '${AppConstants.baseUrl}/api/user/login'; // Your backend API endpoint

  
Future<void> _storeUserData(String email, String accessToken, String refreshToken, String id) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Store user data in SharedPreferences
    await prefs.setString('email', email);
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setString('userid', id);  // Saving the 'id' value
    await prefs.setBool('isLoggedIn', true);
    startTokenRefreshTimer();

    print("User data successfully stored.");
  } catch (e) {
    print("Error storing user data: $e");
  }
}
  // Authenticate user with backend
  Future<bool> authenticateUser(String email, String password) async {
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
        // Store user data and tokens
        await _storeUserData(
          responseData['email'],
          responseData['accessToken'],
          responseData['refreshToken'],
          responseData['id'], 
        );
        return true;
      } else {
        setState(() {
          errorMessage = responseData['error'] ?? 'Login failed';
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

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

     if (await authenticateUser(email, password)) {
  toast('Login Successful');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EADashedBoardScreen()),
  );
}
if (await authenticateUser(email, password)) {
  toast('Login Successful');
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => EADashedBoardScreen()),
    (route) => false, // This removes all previous routes
  );
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo at the top
                  Image.asset(
                    'images/logo.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                 
                  // Welcome text
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

                  // Password Field
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

                  // Sign In Button
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
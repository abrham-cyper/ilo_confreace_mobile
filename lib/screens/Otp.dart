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

class Otp extends StatefulWidget {
  final String email; // Email to verify

  const Otp({Key? key, required this.email}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  bool isLoading = false;
  String? errorMessage;
  final String apiUrl = '${AppConstants.baseUrl}/api/user/verify-otp'; // Corrected port
  final String resendApiUrl = '${AppConstants.baseUrl}/api/user/resend-otp'; // Corrected port

  // Store tokens in SharedPreferences
Future<void> _storeTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('refreshToken', refreshToken);
  // Print the success message after storing the tokens
  print('Login successful! Access token and refresh token have been stored.');
}


  // Verify OTP with backend
  Future<bool> verifyOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': widget.email,
          'otp': otp,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Store tokens
        await _storeTokens(
          responseData['accessToken'],
          responseData['refreshToken'],
        );
        return true;
      } else {
        setState(() {
          errorMessage = responseData['error'] ?? 'OTP verification failed';
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

  // Resend OTP
  Future<void> resendOtp() async {
    try {
      final response = await http.post(
        Uri.parse(resendApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': widget.email,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        toast('New OTP sent successfully');
      } else {
        toast(responseData['error'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      toast('Network error while resending OTP');
    }
  }

  Future<void> handleOtpVerification() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      toast('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

 if (await verifyOtp(otp)) {
  toast('OTP Verified Successfully');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => EADashedBoardScreen()),
  );
}

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // OTP Title
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor1,
                    ),
                  ),
                  15.height,
                  // Instructions for OTP
                  Text(
                    "Please enter the 6-digit OTP sent to\n${widget.email}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  40.height,

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

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: otpControllers[index],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            autofocus: index == 0,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: primaryColor1),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                              if (index == 5 && value.isNotEmpty) {
                                handleOtpVerification();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  30.height,

                  // OTP Verification Button
                  SizedBox(
                    width: context.width(),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleOtpVerification,
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
                              "Verify OTP",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  20.height,

                  // Resend OTP Button
                  GestureDetector(
                    onTap: isLoading ? null : resendOtp,
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(color: primaryColor1, fontSize: 14, fontWeight: FontWeight.bold),
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

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
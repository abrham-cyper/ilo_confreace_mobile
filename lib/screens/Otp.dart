import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/screens/EASelectHashtagScreen.dart'; // Next screen

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  bool isLoading = false;

  // Simulate OTP verification (replace with real auth logic)
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(Duration(seconds: 1)); // Simulated delay
    return otp == '123456'; // Replace with actual OTP validation logic
  }

  // Handle OTP verification action
  Future<void> handleOtpVerification() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      toast('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => isLoading = true);

    if (await verifyOtp(otp)) {
      toast('OTP Verified Successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EASelectHashtagScreen(name: "Dashboard")),
      );
    } else {
      toast('Invalid OTP');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center( // Center the whole content vertically
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
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
                    "Please enter the 6-digit OTP sent to your email or phone.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  40.height,
                  // OTP Input Fields (each field with its own controller)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 40,  // Fixed width for each input field
                          child: TextFormField(
                            controller: otpControllers[index],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            autofocus: index == 0,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: '', // Remove the default value, leaving it empty
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
                              child: CircularProgressIndicator(color: white, strokeWidth: 2),
                            )
                          : Text(
                              "Verify OTP",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  20.height,
                  // Resend OTP Button (optional)
                  GestureDetector(
                    onTap: () {
                      toast('OTP Resent');
                      // Logic for resending OTP goes here
                    },
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
}

import 'package:event_prokit/screens/Forgetpassword.dart';
import 'package:event_prokit/screens/OTP.dart';
import 'package:event_prokit/screens/SignIn.dart';
import 'package:event_prokit/screens/Signup.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/screens/EADashedBoardScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/screens/EASelectCityScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EAWalkThroughScreen extends StatefulWidget {
  const EAWalkThroughScreen({Key? key}) : super(key: key);

  @override
  _EAWalkThroughScreenState createState() => _EAWalkThroughScreenState();
}

class _EAWalkThroughScreenState extends State<EAWalkThroughScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  // Initialize GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        print('User: ${googleUser.displayName}');
        print('Email: ${googleUser.email}');
        print('Photo URL: ${googleUser.photoUrl}');
        EASelectCityScreen().launch(context);
      } else {
        toast('Sign in cancelled');
      }
    } catch (error) {
      print('Google Sign In Error: $error');
      toast('Error signing in with Google');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: context.width(),
                  height: context.height(),
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: walkThroughList.length,
                    itemBuilder: (context, i) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          commonCachedNetworkImage(
                            walkThroughList[i].image!,
                            fit: BoxFit.cover,
                          ),
                          // Gradient overlay for shadow effect on background image
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    onPageChanged: (value) {
                      setState(() => currentIndexPage = value);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      walkThroughList[currentIndexPage].title!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontFamily: 'Poppins', // Modern font (ensure it's in pubspec.yaml)
                      ),
                    ),
                    16.height,
                    Text(
                      walkThroughList[currentIndexPage].subtitle!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    32.height,
                    DotIndicator(
                      pageController: pageController,
                      pages: walkThroughList,
                      indicatorColor: white,
                    ),
                    16.height,
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text('Sign In', style: boldTextStyle(color: white)),
                      elevation: 0.0,
                      width: context.width() * 0.9,
                      padding: EdgeInsets.all(12),
                      color: primaryColor1,
                      onTap: () {
                        SignIn().launch(context);
                      },
                    ),
                    16.height,
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text('Sign Up', style: boldTextStyle(color: white)),
                      elevation: 0.0,
                      width: context.width() * 0.9,
                      padding: EdgeInsets.all(12),
                      color: primaryColor1,
                      onTap: () {
                        Signup().launch(context);
                      },
                    ),
                  ],
                ).paddingOnly(bottom: 24, right: 16, left: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
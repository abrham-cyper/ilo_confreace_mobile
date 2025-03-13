import 'package:event_prokit/screens/Forgetpassword.dart';
import 'package:event_prokit/screens/OTP.dart';
import 'package:event_prokit/screens/SignIn.dart';
import 'package:event_prokit/screens/Signup.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/screens/EADashedBoardScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/screens/EASelectCityScreen.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this import

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
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser != null) {
        // Successfully signed in
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        // You can access user details like this:
        print('User: ${googleUser.displayName}');
        print('Email: ${googleUser.email}');
        print('Photo URL: ${googleUser.photoUrl}');
      

        
        
        // Navigate to next screen
        EASelectCityScreen().launch(context);
      } else {
        // User cancelled the sign-in
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
                      return commonCachedNetworkImage(walkThroughList[i].image!, fit: BoxFit.cover);
                    },
                    onPageChanged: (value) {
                      setState(() => currentIndexPage = value);
                    },
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: Text('Skip', style: primaryTextStyle(color: primaryColor1)).onTap(() {
                    EADashedBoardScreen().launch(context);
                  }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(walkThroughList[currentIndexPage].title!, style: boldTextStyle(size: 24, color: white)),
                    16.height,
                    Text(walkThroughList[currentIndexPage].subtitle!, style: primaryTextStyle(color: white), textAlign: TextAlign.center),
                    32.height,
                    DotIndicator(pageController: pageController, pages: walkThroughList, indicatorColor: white),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Fontisto.facebook, color: white),
                              8.width,
                              Text('Facebook', style: primaryTextStyle(color: white)),
                            ],
                          ),
                          elevation: 0.0,
                          width: 150,
                          padding: EdgeInsets.all(8),
                          color: facebook,
                          onTap: () {
                            EASelectCityScreen().launch(context);
                          },
                        ),
                        16.width,
                        AppButton(
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Fontisto.google, color: white),
                              8.width,
                              Text('Google', style: primaryTextStyle(color: white)),
                            ],
                          ),
                          elevation: 0.0,
                          width: 150,
                          padding: EdgeInsets.all(8),
                          color: Colors.red,
                          onTap: _handleGoogleSignIn, // Updated onTap handler
                        ),
                      ],
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
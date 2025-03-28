import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'EAWalkThroughScreen.dart';

class EASplashScreen extends StatefulWidget {
  const EASplashScreen({Key? key}) : super(key: key);

  @override
  _EASplashScreenState createState() => _EASplashScreenState();
}

class _EASplashScreenState extends State<EASplashScreen> {
  @override
  void initState() {
    super.initState();
    //
    init();
  }

  Future<void> init() async {
    setStatusBarColor(transparentColor);
    await 3.seconds.delay;
    finish(context);
    EAWalkThroughScreen().launch(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/logo.png",
            height: 400,
            fit: BoxFit.cover,
            width: context.width(),
          ),
          20.height,
          Text('Ethiopia', style: GoogleFonts.acme(fontSize: 40, color: primaryColor1)),
          20.height,
           Text('Addis Ababa', style: GoogleFonts.acme(fontSize: 40, color: primaryColor1)),
          20.height,
          Text('20th ILO Regional Conference', style: primaryTextStyle()),
        ],
      ),
    );
  }
}

import 'package:event_prokit/main.dart';
import 'package:event_prokit/screens/About.dart';
import 'package:event_prokit/screens/EditProfileScreen.dart';
import 'package:event_prokit/screens/SignIn.dart';
import 'package:event_prokit/screens/feedback.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EASettingScreen extends StatefulWidget {
  const EASettingScreen({Key? key}) : super(key: key);

  @override
  _EASettingScreenState createState() => _EASettingScreenState();
}

class _EASettingScreenState extends State<EASettingScreen> {
  bool isNotificationOn = false;
  bool isLocationOn = false;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor1);
  }

  String selectedLanguage = "English"; // Default language

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: getAppBar(
          "Setting",
          center: true,
          backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/ic_theme.png',
                        height: 24,
                        width: 24,
                        color: appStore.isDarkModeOn ? white : black,
                      ).paddingOnly(left: 16),
                      22.width,
                      Text(event_lblDarkMode, style: boldTextStyle()),
                    ],
                  ),
                  Switch(
                    value: appStore.isDarkModeOn,
                    activeColor: primaryColor1,
                    onChanged: (s) {
                      appStore.toggleDarkMode(value: s);
                    },
                  ),
                ],
              ).onTap(
                () {
                  appStore.toggleDarkMode();
                },
              ),
              // Removed the 16.height and empty Container here
            SettingItemWidget(
            title: "Edit Profile",
            leading: Icon(LineIcons.envelope, size: 30),
            subTitle: "Edit Profile",
            trailing: Icon(Icons.edit, size: 18, color: grey.withOpacity(0.3)),
            onTap: () {
              // Navigate to ProfileEditPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),
              SettingItemWidget(
                title: "Location",
                leading: Icon(LineIcons.city, size: 30),
                subTitle: "Addis Ababa",
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: grey.withOpacity(0.3)),
              ),
              SettingItemWidget(
                title: "Change Password",
                leading: Icon(LineIcons.database, size: 30),
                subTitle: "Privacy",
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: grey.withOpacity(0.3)),
              ),
              SettingItemWidget(
                  title: "Privacy Policy",
                  leading: Icon(
                    LineIcons.credit_card,
                    size: 30,
                  )),
              SettingItemWidget(
                title: "Enable Notification",
                leading: Icon(LineIcons.bell, size: 30),
                trailing: CupertinoSwitch(
                  value: isNotificationOn,
                  onChanged: (bool val) {
                    isNotificationOn = val;
                    setState(() {});
                  },
                ).withHeight(0.5),
              ),
              30.height,
              Text('About US'.toUpperCase(), style: boldTextStyle(color: grey.withOpacity(0.3))).paddingLeft(16),
              16.height,
              SettingItemWidget(
                title: "About us",
                leading: Icon(LineIcons.alternate_comment_1, size: 30),
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: grey.withOpacity(0.3)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              SettingItemWidget(
                title: "Send Feedback",
                leading: Icon(LineIcons.info_circle, size: 30),
                trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: grey.withOpacity(0.3)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
              ),
              SettingItemWidget(
                title: "Logout",
                leading: Icon(Icons.logout, size: 30),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Text('Version 1.0', style: boldTextStyle(), textAlign: TextAlign.center).paddingBottom(16),
      ),
    );
  }

  // Logout Confirmation Dialog with SharedPreferences clearing
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Clear all SharedPreferences data
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Removes all stored key-value pairs
                print("All SharedPreferences cleared");

                Navigator.of(context).pop(); // Close the dialog

                // Navigate to the SignIn screen and replace the current screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
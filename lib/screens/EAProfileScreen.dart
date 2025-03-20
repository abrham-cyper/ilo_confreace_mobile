import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/components/EAProfileTopComponent.dart';
import 'package:event_prokit/screens/EANotificationScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/screens/EASettingScreen.dart';

class EAProfileScreen extends StatefulWidget {
  @override
  EAProfileScreenState createState() => EAProfileScreenState();
}

class EAProfileScreenState extends State<EAProfileScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Container(
              height: context.height() * 0.55,
              child: Stack(
                children: [
                  EAProfileTopComponent(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 40),
                        Text(
                          'Profile',
                          style: boldTextStyle(color: white, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            EASettingScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                          icon: Icon(AntDesign.setting, color: white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section
            Expanded(
              child: Container(
                width: context.width(),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor1, primaryColor1.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About ILO',
                              style: boldTextStyle(size: 20, color: white),
                            ),
                            16.height,
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: _buildInfoItem(
                                        icon: Icons.work_outline,
                                        title: 'Founded',
                                        value: '1919',
                                      ),
                                    ),
                                    SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: _buildInfoItem(
                                        icon: Icons.location_on,
                                        title: 'HQ',
                                        value: 'Geneva',
                                      ),
                                    ),
                                    SizedBox(
                                      width: (constraints.maxWidth - 32) / 3,
                                      child: _buildInfoItem(
                                        icon: Icons.people,
                                        title: 'Members',
                                        value: '187',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            16.height,
                            // Message text removed from here
                            GestureDetector(
                              onTap: () => toast('Learn more about ILO'),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Learn More',
                                  style: boldTextStyle(size: 14, color: primaryColor1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: white,
            size: 28,
          ),
        ),
        8.height,
        Text(
          value,
          style: boldTextStyle(size: 18, color: white),
        ),
        4.height,
        Text(
          title,
          style: secondaryTextStyle(size: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
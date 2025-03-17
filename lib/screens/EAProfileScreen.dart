import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool pinned = true;
  List<dynamic> registeredUsers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    init();
    fetchRegisteredUsers();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  // Fetch registered users from the backend
  Future<void> fetchRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      setState(() {
        errorMessage = "User not logged in";
        isLoading = false;
      });
      toast("Please log in to view registered users");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://49.13.202.68:5001/api/registerUser/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          registeredUsers = data; // Assuming the response is a list of users
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch users: ${response.statusCode}";
          isLoading = false;
        });
        toast("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching users: $e";
        isLoading = false;
      });
      toast("Error fetching users: $e");
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: context.height() * 0.65,
              floating: false,
              pinned: true,
              centerTitle: true,
              title: Text(innerBoxIsScrolled ? 'Profile' : "", style: boldTextStyle(color: white)),
              backgroundColor: innerBoxIsScrolled ? primaryColor1 : transparentColor,
              forceElevated: innerBoxIsScrolled,
              iconTheme: IconThemeData(color: white),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: EAProfileTopComponent(),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            EANotificationScreen().launch(context);
                          },
                          icon: Icon(Icons.notifications_active_outlined, color: white, size: 28),
                        ),
                        Positioned(
                          right: 4,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                            child: Text('1', style: secondaryTextStyle(color: primaryColor1)),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        EASettingScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                      icon: Icon(AntDesign.setting, color: white),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              16.height,
              Text('Registered Users'.toUpperCase(), style: boldTextStyle(color: primaryColor1, size: 20)),
              Divider(color: primaryColor1, thickness: 2),
              if (isLoading)
                Center(child: CircularProgressIndicator(color: primaryColor1)).paddingTop(20)
              else if (errorMessage != null)
                Center(child: Text(errorMessage!, style: secondaryTextStyle(color: Colors.red))).paddingTop(20)
              else
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: registeredUsers.length,
                  itemBuilder: (context, index) {
                    final user = registeredUsers[index];
                    final fullName =
                        "${user['fullName']['first']} ${user['fullName']['middle']} ${user['fullName']['last']}";
                    final photoUrl = user['photo'] != null
                        ? 'http://49.13.202.68:5001/${user['photo']}' // Adjust base URL as needed
                        : 'https://via.placeholder.com/150'; // Fallback image

                    return GestureDetector(
                      onTap: () {
                        toast("Tapped on $fullName");
                        // Add navigation or details view here if needed
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor1.withOpacity(0.8), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Photo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: commonCachedNetworkImage(
                                photoUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            16.width,
                            // User Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: boldTextStyle(color: Colors.white, size: 18),
                                  ),
                                  4.height,
                                  Text(
                                    "Job: ${user['jobTitle']} at ${user['organizationName']}",
                                    style: secondaryTextStyle(color: Colors.white70),
                                  ),
                                  4.height,
                                  Text(
                                    "Nationality: ${user['nationality']}",
                                    style: secondaryTextStyle(color: Colors.white70),
                                  ),
                                  4.height,
                                  Text(
                                    "Phone: ${user['phoneNumber']}",
                                    style: secondaryTextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            // Action Icon
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
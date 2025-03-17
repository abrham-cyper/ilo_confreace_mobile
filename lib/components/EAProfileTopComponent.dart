import 'package:event_prokit/screens/EAExplorerScreen.dart';
import 'package:event_prokit/screens/EAMayBEYouKnowScreen.dart';
import 'package:event_prokit/screens/QRScannerScreen.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EAProfileTopComponent extends StatefulWidget {
  const EAProfileTopComponent({Key? key}) : super(key: key);

  @override
  _EAProfileTopComponentState createState() => _EAProfileTopComponentState();
}

class _EAProfileTopComponentState extends State<EAProfileTopComponent> {
  bool isExpand = true;
  String hashTag =
      "Happy to be part of the ILO Conference. Excited to connect, learn, and contribute to global impact in art, fashion, culture, food & drink, sport, and nightlife.";

  // Variables to store fetched user data
  String? fullname;
  String? country;
  String? bio;
  String? profilePic;
  String? userId; // To store the user's _id
  String? qrData; // QR code data, will be set dynamically

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget initializes
  }

  Future<void> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final refreshToken = prefs.getString('refreshToken');

  if (accessToken == null) {
    toast("User not logged in");
    return;
  }

  try {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userData = data['data'];

      setState(() {
        fullname = userData['fullname'] ?? 'Unknown user';
        country = userData['country'] ?? 'Country';
        bio = userData['bio'] ?? '';
        profilePic = userData['profilePic'] ??
            'https://i.pinimg.com/736x/47/3e/84/473e84e35274f087695236414ff8df3b.jpg';
        userId = userData['_id']; // Store the user ID
        qrData = userId; // Set QR code data to only the userId
      });
    } else if (response.statusCode == 401) {
      final newAccessToken = await refreshAccessToken(refreshToken);
      if (newAccessToken != null) {
        await fetchUserData();
      } else {
        toast("Session expired. Please log in again.");
      }
    } else {
      final error = jsonDecode(response.body);
      toast("Failed to fetch user data: ${error['error']}");
    }
  } catch (e) {
    toast("Error fetching user data: $e");
  }
}

  // Function to refresh the access token using the refresh token
  Future<String?> refreshAccessToken(String? refreshToken) async {
    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/user/refreshToken'), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', newAccessToken);
        return newAccessToken;
      } else {
        return null;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return null;
    }
  }

  // Function to show the QR code in a popup
  void _showQrCodePopup(BuildContext context) {
    if (qrData == null) {
      toast("User data not loaded yet. Please wait.");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Scan QR Code",
                  style: boldTextStyle(size: 20),
                ),
                16.height,
                QrImageView(
                  data: qrData!,
                  version: QrVersions.auto,
                  size: 250.0,
                  gapless: false,
                  foregroundColor: primaryColor1,
                  embeddedImage: AssetImage('images/app_icon.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: primaryColor1,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: primaryColor1,
                  ),
                ),
                16.height,
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: primaryTextStyle(color: primaryColor1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to open QR code scanner
  void _openQrScanner(BuildContext context) async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(),
      ),
    );

    if (scannedData != null) {
      toast("Scanned QR Code: $scannedData");
      if (scannedData.startsWith("http")) {
        // Use a URL launcher or handle the navigation as needed
        // For example: launchUrl(Uri.parse(scannedData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonCachedNetworkImage(
          "https://i.pinimg.com/736x/5d/26/d4/5d26d4c09b6bff231395047042ea1aa5.jpg",
          fit: BoxFit.cover,
          width: context.width(),
          height: 300,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16, left: 16, top: 200),
              padding: EdgeInsets.only(left: 16, right: 16),
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: defaultBoxShadow(),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    36.height,
                    Text(fullname ?? 'Abrham', style: boldTextStyle()),
                    8.height,
                    Text(country ?? 'Ethiopia, Addis Abebe', style: primaryTextStyle()),
                    8.height,
                    GestureDetector(
                      onTap: () => _showQrCodePopup(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QrImageView(
                              data: qrData ?? "${AppConstants.baseUrl}/api/user/default", // Fallback QR data
                              version: QrVersions.auto,
                              size: 40.0,
                              gapless: false,
                              foregroundColor: primaryColor1,
                            ),
                            8.width,
                            Text(
                              "Scan QR",
                              style: primaryTextStyle(color: primaryColor1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    4.height,
                    Row(
                      children: [
                        Text(
                          bio?.isNotEmpty == true ? bio! : hashTag,
                          style: primaryTextStyle(),
                          maxLines: isExpand ? null : 1,
                          overflow: isExpand ? null : TextOverflow.ellipsis,
                        ).expand(),
                      ],
                    ),
                    18.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       GestureDetector(
  onTap: () {
    // Navigate to EAMayBEYouKnowScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EAExplorerScreen(),
      ),
    );
  },
  child: Icon(
    Icons.message,
    color: primaryColor1,
    size: 24,
  ),
),

                        16.width,
                        GestureDetector(
                          onTap: () {
                            // Handle share icon tap
                          },
                          child: Icon(
                            Icons.share,
                            color: primaryColor1,
                            size: 24,
                          ),
                        ),
                        16.width,
                        GestureDetector(
                          onTap: () {
                            toast("Favorite icon tapped");
                          },
                          child: Icon(
                            Icons.favorite_border,
                            color: primaryColor1,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    36.height,
                  ],
                ).paddingTop(8),
              ),
            ),
            Positioned(
              top: 130,
              child: commonCachedNetworkImage(
                profilePic ??
                    'https://i.pinimg.com/736x/47/3e/84/473e84e35274f087695236414ff8df3b.jpg', // Updated fallback image
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(50),
            ),
            Positioned(
              top: 35,
              left: 16,
              child: GestureDetector(
                onTap: () => _openQrScanner(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
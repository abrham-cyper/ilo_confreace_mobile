import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/screens/EAExplorerScreen.dart';
import 'package:event_prokit/screens/EAMayBEYouKnowScreen.dart';
import 'package:event_prokit/screens/QRScannerScreen.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';

// Profile top component with user data and QR functionality
class EAProfileTopComponent extends StatefulWidget {
  const EAProfileTopComponent({super.key});

  @override
  _EAProfileTopComponentState createState() => _EAProfileTopComponentState();
}

class _EAProfileTopComponentState extends State<EAProfileTopComponent> {
  bool isExpanded = true; // Controls bio text expansion
  String defaultBio =
      "Happy to be part of the ILO Conference. Excited to connect, learn, and contribute to global impact.";

  // User data fields
  String? fullname;
  String? country;
  String? bio;
  String? profilePic;
  String? userId;
  String? qrData;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initialization
  }

  // Fetch user data from the backend
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      _showToast("Please log in to view your profile");
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
        final data = jsonDecode(response.body)['data'];
        setState(() {
          fullname = data['fullname'] ?? 'Guest User';
          country = data['country'] ?? 'Unknown Location';
          bio = data['bio']?.isNotEmpty == true ? data['bio'] : defaultBio;
          profilePic = data['profilePic'] ??
              'https://i.pinimg.com/736x/47/3e/84/473e84e35274f087695236414ff8df3b.jpg';
          userId = data['id']; // Use 'id' as per your backend response
          qrData = userId; // QR code displays user ID
        });
      } else if (response.statusCode == 401) {
        final newToken = await _refreshAccessToken();
        if (newToken != null) {
          await _fetchUserData(); // Retry with new token
        } else {
          _showToast("Session expired. Please log in again.");
          // Optionally navigate to login screen
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      } else {
        _showToast("Failed to load profile: ${jsonDecode(response.body)['error']}");
      }
    } catch (e) {
      _showToast("Error fetching profile: $e");
    }
  }

  // Refresh access token
  Future<String?> _refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      _showToast("No refresh token available");
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/user/refreshToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        await prefs.setString('accessToken', newAccessToken);
        print('Token refreshed: $newAccessToken');
        return newAccessToken;
      } else {
        _showToast("Failed to refresh token");
        return null;
      }
    } catch (e) {
      _showToast("Token refresh error: $e");
      return null;
    }
  }

  // Show QR code in a stylish popup
  void _showQrCodePopup(BuildContext context) {
    if (qrData == null) {
      _showToast("Profile not loaded yet");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [primaryColor1.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData!,
                version: QrVersions.auto,
                size: 260,
                gapless: true,
                foregroundColor: primaryColor1,
                embeddedImage: const AssetImage('images/app_icon.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(50, 50)),
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: primaryColor1,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: primaryColor1,
                ),
              ),
              20.height,
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Open QR scanner
  Future<void> _openQrScanner(BuildContext context) async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  QRScannerScreen()),
    );

    if (scannedData != null) {
      _showToast("Scanned: $scannedData");
      // Handle scanned data (e.g., URL or user ID)
      if (scannedData.toString().startsWith("http")) {
        // Optionally launch URL
        // launchUrl(Uri.parse(scannedData));
      }
    }
  }

  // Helper method to show toast messages
  void _showToast(String message) {
    toast(message, bgColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        commonCachedNetworkImage(
          "https://i.pinimg.com/736x/5d/26/d4/5d26d4c09b6bff231395047042ea1aa5.jpg",
          fit: BoxFit.cover,
          width: context.width(),
          height: 280,
        ),
        // Profile card
        Container(
          margin: const EdgeInsets.fromLTRB(16, 180, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              30.height, // Space for profile picture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fullname ?? 'Loading...',
                      style: boldTextStyle(size: 22, weight: FontWeight.w900),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showQrCodePopup(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor1, primaryColor1.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor1.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: qrData ?? 'default',
                        version: QrVersions.auto,
                        size: 50,
                        foregroundColor: Colors.white,
                        embeddedImage: const AssetImage('images/app_icon.png'),
                        embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(12, 12)),
                      ),
                    ),
                  ),
                ],
              ),
              8.height,
              Text(
                country ?? 'Fetching location...',
                style: secondaryTextStyle(color: Colors.grey.shade600, size: 14),
              ),
              12.height,
              Text(
                bio ?? defaultBio,
                style: primaryTextStyle(size: 15),
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
              ),
              16.height,
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Text(
                  isExpanded ? 'Show less' : 'Show more',
                  style: primaryTextStyle(color: primaryColor1, size: 14),
                ),
              ),
              20.height,
            ],
          ),
        ),
        // Profile picture
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Center(
            child: commonCachedNetworkImage(
              profilePic ?? 'https://via.placeholder.com/150',
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(60),
          ),
        ),
        // QR scanner button
        Positioned(
          top: 8,
          left: 20,
          child: GestureDetector(
            onTap: () => _openQrScanner(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor1.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
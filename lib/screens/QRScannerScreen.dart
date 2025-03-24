import 'package:event_prokit/screens/UserDetailScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isLoading = false;
  String errorMessage = "";
  bool isProcessing = false; // To prevent multiple scans

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: primaryColor1,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator()),
          if (errorMessage.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Prevent multiple simultaneous scans

      setState(() {
        result = scanData;
        isLoading = true;
        errorMessage = ""; // Clear previous error message
        isProcessing = true; // Lock processing
      });

      String? userId = scanData.code; // Get the userId from QR code
      await _fetchUserData(userId);

      // Pause the scanner after a scan to prevent repeated triggers
      controller.pauseCamera();
    });
  }

  Future<void> _fetchUserData(String? userId) async {
    if (userId == null) {
      setState(() {
        errorMessage = "Invalid QR Code";
        isLoading = false;
        isProcessing = false;
      });
      controller?.resumeCamera(); // Resume scanning if invalid
      return;
    }

    final url = 'http://49.13.202.68:5001/api/user/userid/$userId';

    // Get the access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      setState(() {
        errorMessage = "No access token found. Please log in.";
        isLoading = false;
        isProcessing = false;
      });
      controller?.resumeCamera();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken', // Add the token to the header
          'Content-Type': 'application/json', // Optional, depending on API
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['exists'] == true) {
          // Navigate to UserDetailScreen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(userId: userId),
            ),
          );
          setState(() {
            isLoading = false;
            isProcessing = false;
          });
          controller?.resumeCamera(); // Resume scanning after returning
        } else {
          setState(() {
            errorMessage = "User not found";
            isLoading = false;
            isProcessing = false;
          });
          controller?.resumeCamera(); // Resume scanning
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized access (e.g., token expired)
        setState(() {
          errorMessage = "Unauthorized: Invalid or expired token";
          isLoading = false;
          isProcessing = false;
        });
        controller?.resumeCamera();
      } else {
        setState(() {
          errorMessage = "Error fetching user data: ${response.statusCode}";
          isLoading = false;
          isProcessing = false;
        });
        controller?.resumeCamera();
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
        isLoading = false;
        isProcessing = false;
      });
      controller?.resumeCamera();
    }
  }
}
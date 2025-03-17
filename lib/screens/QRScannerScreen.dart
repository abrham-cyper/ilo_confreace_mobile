import 'package:event_prokit/screens/UserDetailScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    try {
      final response = await http.get(Uri.parse(url));

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
      } else {
        setState(() {
          errorMessage = "Error fetching user data: ${response.statusCode}";
          isLoading = false;
          isProcessing = false;
        });
        controller?.resumeCamera(); // Resume scanning
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
        isLoading = false;
        isProcessing = false;
      });
      controller?.resumeCamera(); // Resume scanning
    }
  }
}
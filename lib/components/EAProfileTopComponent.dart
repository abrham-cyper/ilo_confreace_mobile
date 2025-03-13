import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:event_prokit/screens/EAConnectionScreen.dart';
import 'package:event_prokit/screens/EAIndexScreen.dart';
import 'package:event_prokit/screens/EARewardScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAImages.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';

class EAProfileTopComponent extends StatefulWidget {
  const EAProfileTopComponent({Key? key}) : super(key: key);

  @override
  _EAProfileTopComponentState createState() => _EAProfileTopComponentState();
}

class _EAProfileTopComponentState extends State<EAProfileTopComponent> {
  bool isExpand = true;
  String hashTag = "Happy to be part of the ILO Conference. Excited to connect, learn, and contribute to global impact in art, fashion, culture, food & drink, sport, and nightlife.";
  final String qrData = "http://localhost:3000/api/user/id"; // QR code data

  // Function to show the QR code in a popup
  void _showQrCodePopup(BuildContext context) {
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
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  gapless: false,
                  foregroundColor: primaryColor1, // Use your app's primary color
                  embeddedImage: AssetImage('images/app_icon.png'), // Optional: Add an embedded logo
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
      // Handle the scanned data (e.g., show a toast or navigate to the URL)
      toast("Scanned QR Code: $scannedData");
      // Example: Navigate to the scanned URL (if it's a URL)
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  36.height,
                  Text("Abrham", style: boldTextStyle()),
                  8.height,
                  Text("Ethiopia, Addis Abebe", style: primaryTextStyle()),
                  8.height, // Small gap before QR code button
                  // QR Code Button
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
                            data: qrData,
                            version: QrVersions.auto,
                            size: 40.0, // Small size for the button
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
                  16.height, 
                    Row(
                        children: [
                          Text(
                            hashTag,
                            style: primaryTextStyle(),
                            maxLines: isExpand ? hashTag.length : 1,
                          ).expand(),
                        ],
                      ).expand(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(
                      //       hashTag,
                      //       style: primaryTextStyle(),
                      //       maxLines: isExpand ? hashTag.length : 1,
                      //     ).expand(),
                      //   ],
                      // ).expand(),
                    ],
                  ).expand(),
                ],
              ).paddingTop(0),
            ),
            Positioned(
              top: 130,
              child: commonCachedNetworkImage(
                'https://i.pinimg.com/736x/f0/4b/c7/f04bc7f4b16a2fc94078139ad03e6f88.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(50),
            ),
            // QR Scanner Button in Top-Left Corner
            Positioned(
              top: 30,
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

// QR Scanner Screen
class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
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
          ),
      // 
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // Automatically pop the scanner screen and return the scanned data
      Navigator.pop(context, scanData.code);
    });
  }
}
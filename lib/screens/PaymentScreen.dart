import 'package:event_prokit/screens/EAHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:chapasdk/chapasdk.dart';
import 'dart:math';

class PaymentScreen extends StatelessWidget {
  final String publicKey =
      'CHAPUBK_TEST-0SSyiMef0nojP3l4J9md4ERZYOCLtHj0';  

  String generateTxRef() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPart = random.nextInt(999999).toString().padLeft(6, '0');
    return 'txn_$timestamp$randomPart';
  }

  void initiatePayment(BuildContext context) {
    String txRef = generateTxRef();  
    Chapa.paymentParameters(
      context: context,
      publicKey: publicKey,
      currency: 'ETB',
      amount: '200',
      email: 'customer@example.com',
      phone: '0911223344',
      firstName: 'First',
      lastName: 'Last',
      txRef: txRef,  
      title: 'Order Payment',
      desc: 'Payment for order #12345',
      nativeCheckout: true,
      namedRouteFallBack: '/',
      showPaymentMethodsOnGridView: true,
      availablePaymentMethods: [
        'cbebirr',
        'telebirr',
        'mpesa',
        'ebirr',
        'Amole',
        'Awash Bank'
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Automatically initiate the payment when the screen is built
    initiatePayment(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EAHomeScreenState().launch(context);
          },
        ),
        title: Text('Chapa Payment'),
      ),
      body: Center(
        child: Container(
            // You can adjust the width or make it responsive
        ),
      ),
    );
  }
}

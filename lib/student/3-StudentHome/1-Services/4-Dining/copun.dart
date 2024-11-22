import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class Coupon extends StatefulWidget {
  const Coupon({super.key});

  @override
  State<Coupon> createState() => CouponState();
}

class CouponState extends State<Coupon> {
  String qrData = '';
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    generateQrCode();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      appBar: OurAppBar(
        title: 'Coupon',
      ),
      body: Padding(
        padding: EdgeInsets.all(1.0),
        child: Center(
          child: Container(
            height: screenHeight * 0.25,
            width: screenWidth * 0.90,
            decoration: BoxDecoration(
              color: green1.withOpacity(0.30),
              border: Border.all(color: green1, width: 2.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dtext(
                  t: 'Meal QR Code for $formattedDate',
                  color: Colors.black,
                  align: TextAlign.center,
                  size: 0.035,
                ),
                Heightsizedbox(h: 0.02),
                // Wrapping QrImage with a SizedBox to control its size
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0, // You can adjust this size
                  ),
                ),
                Heightsizedbox(h: 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateQrCode() async {
    final prefs = await SharedPreferences.getInstance();
    String lastGeneratedDate = prefs.getString('lastGeneratedDate') ?? '';
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if QR code needs to be updated
    if (lastGeneratedDate != today.toIso8601String().split('T')[0]) {
      qrData = '$userId-${today.toIso8601String().split('T')[0]}';
      await prefs.setString(
          'qrData', qrData); // Save the QR code data in SharedPreferences
      await prefs.setString(
          'lastGeneratedDate', today.toIso8601String().split('T')[0]);

      // Save to Firestore or update the state as needed
      FirebaseFirestore.instance.collection('coupons').doc(userId).set({
        'qrData': qrData,
        'date': today.toIso8601String().split('T')[0],
        'used': false,
      });
    } else {
      qrData = prefs.getString('qrData') ?? '';
    }
  }

}

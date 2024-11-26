import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart'; // For handling permissions
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database interaction
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase messaging for notifications
import 'package:geolocator/geolocator.dart'; // Geolocator for getting precise location
import 'package:pnustudenthousing/helpers/Design.dart'; // Custom design components

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  late String studentId;
  late DocumentReference studentDocRef;

  // PNU Housing rectangular area coordinates
  final double topLatitude = 24.8553464;
  final double bottomLatitude = 24.8548155;
  final double leftLongitude = 46.7145656;
  final double rightLongitude = 46.7153880;

  @override
  void initState() {
    super.initState();
    studentId = FirebaseAuth.instance.currentUser!.uid;
    studentDocRef = FirebaseFirestore.instance.collection('student').doc(studentId);
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Emergency Service'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Heightsizedbox(h: 0.10),
              text(
                t: "If you need help with your health, click the following button.",
                align: TextAlign.center,
                color: Colors.black,
              ),
              Heightsizedbox(h: 0.08),
              actionbutton(
                onPressed: getCurrentLocation, // Call getCurrentLocation when pressed
                text: 'Help',
                background: dark1,
                fontsize: 0.05,
              ),
              Heightsizedbox(h: 0.07),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(
                    t: "This is only for emergency situations.",
                    color: red1,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied || status.isPermanentlyDenied) {
      print('Location permission denied. Asking user to go to settings.');
      await openAppSettings();
    }
  }

  bool isWithinBounds(double userLatitude, double userLongitude) {
    return userLatitude >= bottomLatitude &&
        userLatitude <= topLatitude &&
        userLongitude >= leftLongitude &&
        userLongitude <= rightLongitude;
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double userLatitude = position.latitude;
      double userLongitude = position.longitude;

      print('User Location: $userLatitude, $userLongitude');

      if (isWithinBounds(userLatitude, userLongitude)) {
        await sendHelpRequest(userLatitude, userLongitude);
      } else {
        ErrorDialog("You are not in the PNU housing area", context, buttons: [
          {"OK": () async => context.pop()},
        ]);
      }
    } catch (e) {
      print('Error getting location: $e');
      ErrorDialog(
        "Failed to retrieve your location. Please ensure your location services are enabled.",
        context,
        buttons: [{"OK": () => context.pop()}],
      );
    }
  }

  Future<void> sendHelpRequest(double latitude, double longitude) async {
    try {
      final studentDocSnapshot = await studentDocRef.get();  // Fetch student data
      if (!studentDocSnapshot.exists) {
        throw Exception("Student document not found");
      }

      // Extract the building number from the room reference
      final roomRef = studentDocSnapshot['roomref'];
      final roomId = roomRef is DocumentReference ? roomRef.id : roomRef;
      final buildingNumber = roomId.split('.')[0]; // Extract building number

      // Create the help request document
      final helpRequestDocRef = await FirebaseFirestore.instance.collection('helpRequests').add({
        'location': GeoPoint(latitude, longitude),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'studentInfo': studentDocRef,
      });

      // Update student document with the new help request reference
      await studentDocRef.update({
        'helpRequests': FieldValue.arrayUnion([helpRequestDocRef])
      });

      // Subscribe to relevant topics
      await FirebaseMessaging.instance.subscribeToTopic('HousingSecurityGuard'); // General security topic
      await FirebaseMessaging.instance.subscribeToTopic('Supervisor_Building_$buildingNumber'); // Building-specific topic for supervisor

      // Show success dialog
      InfoDialog("Help request sent successfully", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    } catch (e) {
      // Show error dialog
      ErrorDialog("An error occurred while sending the request", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
      print('Failed to send help request: $e');
    }
  }
}

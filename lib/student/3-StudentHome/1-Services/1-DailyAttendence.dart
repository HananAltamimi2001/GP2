import 'package:flutter/material.dart'; // Importing Flutter material design package for UI components
import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication package to handle user sign-in
import 'package:geolocator/geolocator.dart'; // Importing Geolocator package for location services to get the user's current position
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart'; // Importing Permission Handler package to manage location permissions
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firebase Firestore package to interact with Firestore database
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Stateful widget for the Attendance functionality
class DailyAttendance extends StatefulWidget {
  @override
  _DailyAttendanceState createState() => _DailyAttendanceState();
}

class _DailyAttendanceState extends State<DailyAttendance> {
  // PNU Housing rectangular area coordinates
  final double topLatitude = 24.8553464;
  final double bottomLatitude = 24.8548155;
  final double leftLongitude = 46.7145656;
  final double rightLongitude = 46.7153880;


  @override
  Widget build(BuildContext context) {
    // Get today's date in 'day/month/year' format
    DateTime todayDate = DateTime.now();
    String dayDate = '${todayDate.day}/${todayDate.month}/${todayDate.year}';

    return Scaffold(
      appBar: OurAppBar(title: 'Daily Attendance'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

            Heightsizedbox(h: 0.10), // Add vertical spacing using a custom spacer from the design library

            // Text displaying instructions for confirming attendance
            text(
              t: "To confirm your Attendance for today \n $dayDate \n click the following button:",
              align: TextAlign.center,
              color: Colors.black,
            ),

            Heightsizedbox(h: 0.08), // Add vertical spacing

            // Custom Button to confirm attendance
            actionbutton(
              onPressed: takeAttendance,
              text: 'Confirm',
              background: dark1,
              fontsize: 0.06,
            ),

            Heightsizedbox(h: 0.07), // Add vertical spacing

            // Display a note with important information for the user
            text(
              t: "The button works only if you are inside the Housing Area",
              color: red1,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Function to request location permissions from the user
  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.location.request();
    // Handle the outcome of the permission request
    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied) {
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      print(
          'Location permission permanently denied. Ask user to go to settings.');
      // Open app settings if permission is permanently denied
      await openAppSettings();
    }
  }

  bool isWithinBounds(double userLatitude, double userLongitude) {
    // Check if the user's location is within the rectangular bounds
    return userLatitude >= bottomLatitude &&
        userLatitude <= topLatitude &&
        userLongitude >= leftLongitude &&
        userLongitude <= rightLongitude;
  }

  Future<void>takeAttendance() async {
    try {
      // Request location permission
      await requestPermission();

      // Get the current location using Google Maps Geolocation API
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double userLatitude = position.latitude;
      double userLongitude = position.longitude;

        // Check if the user is within the rectangular bounds
        if (isWithinBounds(userLatitude, userLongitude)) {
          await saveAttendance();
        } else {
          ErrorDialog("You are not in the PNU housing area", context, buttons: [
            {"OK": () async => context.pop()},
          ]);
        }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get your location. Please try again.')),
      );
    }
  }

  // Function to save attendance information to Firestore
  Future<void> saveAttendance() async {
    try {
      String docid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the student document from Firestore using the current user's ID
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('student').doc(docid).get();

      if (documentSnapshot.exists) {
        // Update attendance status to 'Present'
        await documentSnapshot.reference.update({'attendance': 'Present'});

        // Show a custom dialog to inform the user of successful attendance recording
        InfoDialog("Attendance recorded successfully!", context, buttons: [
          {
            "OK": () async => context.pop(),
          }
        ]);
      }
    } catch (e) {
      // Handle errors related to saving attendance
      print('Error saving attendance: $e');
      // Show a custom dialog to inform the user of failure
      ErrorDialog("Failed to record attendance!", context, buttons: [
        {
          "OK": () async => context.pop(),
        }
      ]);
    }
  }

}

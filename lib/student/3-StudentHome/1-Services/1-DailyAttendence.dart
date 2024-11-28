import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:pnustudenthousing/helpers/Design.dart';

// Main class for attendance functionality
class DailyAttendance extends StatefulWidget {
  @override
  _DailyAttendanceState createState() => _DailyAttendanceState();
}

class _DailyAttendanceState extends State<DailyAttendance> {
  // Coordinates of the housing area
  final double topLatitude = 24.8553464;
  final double bottomLatitude = 24.8548155;
  final double leftLongitude = 46.7145656;
  final double rightLongitude = 46.7153880;

  // Notification plugin initialization
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    resetDailyAttendance();
    initializeNotifications();
    checkUnconfirmedAttendance();
    
  }

  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    String dayDate = '${todayDate.day}/${todayDate.month}/${todayDate.year}';

    return Scaffold(
      appBar: OurAppBar(title: 'Daily Attendance'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Heightsizedbox(h: 0.10),
            text(
              t: "To confirm your Attendance for today \n $dayDate \n click the following button:",
              align: TextAlign.center,
              color: Colors.black,
            ),
            Heightsizedbox(h: 0.08),
            actionbutton(
              onPressed: _takeAttendance,
              text: 'Confirm',
              background: dark1,
              fontsize: 0.06,
            ),
            Heightsizedbox(h: 0.07),
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

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted.');
    } else if (status.isDenied) {
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  bool _isWithinBounds(double userLatitude, double userLongitude) {
    return userLatitude >= bottomLatitude &&
        userLatitude <= topLatitude &&
        userLongitude >= leftLongitude &&
        userLongitude <= rightLongitude;
  }

  Future<void> _takeAttendance() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double userLatitude = position.latitude;
    double userLongitude = position.longitude;

    if (_isWithinBounds(userLatitude, userLongitude)) {
      saveAttendance();
    } else {
      ErrorDialog("You are not in the PNU housing area", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    }
  }

  Future<void> saveAttendance() async {
    try {
      String docId = FirebaseAuth.instance.currentUser!.uid;
      String todayDate =
          '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .doc(docId)
          .get();

      if (documentSnapshot.exists) {
        // Update attendance map and lastAttendanceDate field
        await documentSnapshot.reference.update({
          'attendance.$todayDate': 'Present', // Update the attendance map
          'lastAttendanceDate':
              todayDate, // Keep track of the last confirmed attendance date
        });

        InfoDialog("Attendance recorded successfully!", context, buttons: [
          {"OK": () async => context.pop()},
        ]);
      }
    } catch (e) {
      ErrorDialog("Failed to record attendance!", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    }
  }

  Future<void> resetDailyAttendance() async {
    String docId = FirebaseAuth.instance.currentUser!.uid;
    String todayDate =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('student').doc(docId).get();

    if (documentSnapshot.exists) {
      String? lastAttendanceDate =
          documentSnapshot['lastAttendanceDate'] ?? null;
      Map<String, dynamic> attendanceMap = documentSnapshot['attendance'] ?? {};

      // Reset attendance only if it's a new day and today's attendance hasn't been set
      if (lastAttendanceDate != todayDate &&
          !attendanceMap.containsKey(todayDate)) {
        await documentSnapshot.reference.update({
          'attendance.$todayDate': 'Absence',
          'lastAttendanceDate': todayDate,
        });
      }
    }
  }

  void initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void checkUnconfirmedAttendance() async {
    String docId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot studentSnapshot =
        await FirebaseFirestore.instance.collection('student').doc(docId).get();

    if (studentSnapshot.exists) {
      Map<String, dynamic> studentData =
          studentSnapshot.data() as Map<String, dynamic>;

      String? lastAttendanceDate = studentData['lastAttendanceDate'];
      bool hasOvernightRequest = studentData['overnightRequestRef'] != null;

      String dayDate =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

      if (lastAttendanceDate != dayDate && !hasOvernightRequest) {
        scheduleMiddayNotification(); // Only send notification if no overnight request
      }
    }
  }

  void scheduleMiddayNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Attendance Reminder',
      'Please confirm your attendance for today.',
      nextInstanceOfMidday(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'attendance_channel',
          'Daily Attendance Reminder',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Add this
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime nextInstanceOfMidday() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 12);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

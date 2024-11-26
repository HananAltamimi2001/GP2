import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class DayAttendance extends StatefulWidget {
  final String day;

  DayAttendance({required this.day});

  @override
  State<DayAttendance> createState() => DayAttendanceState();
}

class DayAttendanceState extends State<DayAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Attendance for${widget.day}'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAttendanceData(widget.day), // Pass day explicitly
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: dark1));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading attendance data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found'));
          }

          List<Map<String, dynamic>> studentData = snapshot.data!;
          return OurListView(
            data: studentData,
            trailingWidget: (item) => CircleAvatar(
              radius: 15,
              backgroundColor: item['color'],
            ),
            onTap: (item) {
              context.pushNamed('/studentdetails', extra: item['PNUID']);
            },
            title: (item) => item['name'],
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceData(String day) async {
    List<Map<String, dynamic>> studentData = [];
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) {
        print('No authenticated user found.');
        return studentData; // Handle unauthenticated user gracefully
      }

      // Reference to supervisor document
      final supervisorDocRef = FirebaseFirestore.instance.collection('staff').doc(user.uid);
      final supervisorDocSnapshot = await supervisorDocRef.get();

      if (!supervisorDocSnapshot.exists) {
        print('Supervisor data not found.');
        return studentData;
      }

      final buildingNumber = supervisorDocSnapshot['building']; // Supervisor's building number

      // Fetch all resident students and filter by building
      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('resident', isEqualTo: true)
          .get();

      for (var studentDoc in studentSnapshot.docs) {
        final student = studentDoc.data() as Map<String, dynamic>;
        final roomRef = student['roomref'];
        final roomId = roomRef is DocumentReference ? roomRef.id : roomRef;
        final studentBuildingNumber = roomId.split('.')[0]; // Extract building number

        if (studentBuildingNumber != buildingNumber) continue;

        // Retrieve attendance map and status for the selected day
        Map<String, dynamic>? attendanceMap = student['attendance'];
        DateTime now = DateTime.now();
        int currentWeekday = now.weekday % 7; // Make Sunday = 0
        final List<String> days = [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ];
        int selectedDayIndex = days.indexOf(day); // Find index of "Sunday", "Monday", etc.
        DateTime selectedDate = now.subtract(
            Duration(days: currentWeekday - selectedDayIndex));

        // Format the selected date to match the attendance map keys
        String formattedDay = DateFormat('yyyy-MM-dd').format(selectedDate);
        print('f: $formattedDay');
        // Extract the attendance status for the selected day
        String attendanceStatus = attendanceMap?[formattedDay] ?? 'Absence';

        String? pnuid = student['PNUID'];
        String checkStatus = student['checkStatus'] ?? '';

        if (pnuid != null) {
          // Fetch overnight requests for this student
          QuerySnapshot overnightSnapshot = await FirebaseFirestore.instance
              .collection('OvernightRequest')
              .where('studentId', isEqualTo: pnuid)
              .where('status', isEqualTo: 'Accepte')
              .get();

          bool hasOvernightPermission = overnightSnapshot.docs.any((overnightDoc) {
            final overnightData = overnightDoc.data() as Map<String, dynamic>;

            DateTime arrivalDateTime = parseDateTime(overnightData['arrivalDate'], overnightData['arrivalTime']);
            DateTime departureDateTime = parseDateTime(overnightData['departureDate'], overnightData['departureTime']);
            DateTime? checkInTime = convertTimestamp(student['checkTime']);

            if (checkStatus == 'Checked-In' && checkInTime != null) {
              return checkInTime.isBefore(arrivalDateTime) || checkInTime.isBefore(departureDateTime);
            }
            return true;
          });

          // Assign color based on attendance and overnight status
          Color statusColor = determineStatusColor(attendanceStatus, hasOvernightPermission);

          studentData.add({
            'name': '${student['efirstName'] ?? ''} ${student['elastName'] ?? ''}'.trim(),
            'color': statusColor,
            'PNUID': pnuid,
            'email': student['email'] ?? 'Unknown',
            'phone': student['phone'] ?? 'Unknown',
          });
        }
      }

      return studentData;
    } catch (e) {
      print('Error loading attendance data: $e');
      return []; // Return an empty list on error
    }
  }
}

// Helper function to determine status color
Color determineStatusColor(
    String attendanceStatus, bool hasOvernightPermission) {
  if (attendanceStatus == 'Present') return green1;
  if (attendanceStatus == 'Absence') return hasOvernightPermission ? red1 : yellow1;
  return hasOvernightPermission ? red1 : grey1;
}

// Convert Firestore Timestamp to DateTime
DateTime? convertTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is String) {
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      print('Invalid date string: $timestamp');
    }
  }
  return null;
}

// Safely convert 12-hour time format to DateTime
DateTime parseDateTime(String date, String time12h) {
  try {
    String sanitizedTime = time12h.replaceAll(RegExp(r'\s+'), ' ').trim();
    final DateFormat inputFormat = DateFormat.jm(); // e.g., "6:47 PM"
    final DateFormat outputFormat = DateFormat('HH:mm');
    String time24h = outputFormat.format(inputFormat.parse(sanitizedTime));

    return DateTime.parse('$date $time24h');
  } catch (e) {
    print('Error parsing date-time: $e');
    return DateTime.now(); // Fallback if parsing fails
  }
}

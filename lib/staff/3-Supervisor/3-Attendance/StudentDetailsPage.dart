import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Import for date formatting
import 'package:pnustudenthousing/helpers/Design.dart';

class StudentDetails extends StatelessWidget {
  final String pnuid;

  StudentDetails({required this.pnuid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchStudentData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: OurAppBar(title: ''),
            body: Center(child: CircularProgressIndicator(color: dark1)),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: OurAppBar(title: 'Student Details'),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        var studentData = snapshot.data!;
        final roomRef = studentData['roomref'];
        final roomId = roomRef is DocumentReference ? roomRef.id : roomRef;

        // Convert and format checkTime
        Timestamp? checkTime = studentData['checkTime'] as Timestamp?;
        String formattedCheckTime = checkTime != null
            ? DateFormat('yyyy-MM-dd hh:mm a').format(checkTime.toDate())
            : 'N/A';

        return Scaffold(
          appBar: OurAppBar(
            title: '${studentData['efirstName']} ${studentData['elastName']}',
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  t: "Student Info:",
                  align: TextAlign.start,
                  color: dark1,
                ),
                OurContainer(
                  child: Column(
                    children: [
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Full Name',
                        value: studentData['efullName'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'PNU ID',
                        value: studentData['PNUID'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Phone Number',
                        value: studentData['phoneNumber'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Room ID',
                        value: roomId,
                      ),
                    ],
                  ),
                ),
                Heightsizedbox(h: 0.02),
                text(
                  t: "Student Attendance Info:",
                  align: TextAlign.start,
                  color: dark1,
                ),
                OurContainer(borderColor: green1,
                  child: Column(
                    children: [
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Attendance Status',
                        value: studentData['attendance'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Last Attendance Date',
                        value: studentData['lastAttendanceDate'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Check Status',
                        value: studentData['checkStatus'] ?? 'N/A',
                      ),
                      RowInfo.buildInfoRow(
                        defaultLabel: 'Last Check In/Out Time',
                        value: formattedCheckTime,  // Use formatted time here
                      ),
                      if (studentData.containsKey('overnightStatus'))
                        RowInfo.buildInfoRow(
                          defaultLabel: 'Overnight Request Status',
                          value: studentData['overnightStatus'],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchStudentData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot studentSnapshot = await firestore
        .collection('student')
        .where('PNUID', isEqualTo: pnuid)
        .get();

    if (studentSnapshot.docs.isEmpty) {
      throw Exception('Student not found');
    }

    var studentData = studentSnapshot.docs.first.data() as Map<String, dynamic>;

    if (studentData['OvernightRequest'] != null) {
      DocumentReference overnightRef = studentData['OvernightRequest'];
      DocumentSnapshot overnightDoc = await overnightRef.get();

      if (overnightDoc.exists) {
        studentData['overnightStatus'] = overnightDoc['status'] ?? 'Pending';
      } else {
        studentData['overnightStatus'] = 'Request Not Found';
      }
    }

    return studentData;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/staff/7-Security/EmergencyRequestDetailsPage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SupervisorNotifications extends StatefulWidget {
  const SupervisorNotifications({super.key});

  @override
  State<SupervisorNotifications> createState() =>
      SupervisorNotificationsState();
}

class SupervisorNotificationsState extends State<SupervisorNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Supervisor Notifications"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder<List<List<DocumentSnapshot>>>(
            stream: combineStreams(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return buildErrorText(snapshot.error);
              if (snapshot.connectionState == ConnectionState.waiting)
                return  Center(
                  child: OurLoadingIndicator(),
                );

              // Extract and merge data
              final helpRequests = snapshot.data![0];
              final attendanceAlerts = snapshot.data![1];
              final combinedList = [...helpRequests, ...attendanceAlerts];

              if (combinedList.isEmpty)
                return Center(
                  child: buildEmptyMessage('No notifications at the moment.'),
                );

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: combinedList.length,
                itemBuilder: (context, index) {
                  final item = combinedList[index];
                  return item.reference.path.contains('helpRequests')
                      ? buildRequestTile(item)
                      : buildAttendanceAlertTile(item, index, combinedList);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Updated combineStreams with building filter logic
  Stream<List<List<DocumentSnapshot>>> combineStreams() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([[], []]);

    final supervisorDocRef =
    FirebaseFirestore.instance.collection('staff').doc(user.uid);

    return Rx.combineLatest2(
      // Stream for help requests filtered by supervisor's building
      FirebaseFirestore.instance
          .collection('helpRequests')
          .snapshots()
          .asyncMap((snapshot) async {
        final List<DocumentSnapshot> filteredHelpRequests = [];
        final supervisorSnapshot = await supervisorDocRef.get();

        if (supervisorSnapshot.exists) {
          final building = supervisorSnapshot['building'];

          for (var helpRequest in snapshot.docs) {
            final studentRef = helpRequest['studentInfo'] as DocumentReference;
            final studentSnapshot = await studentRef.get();
            final roomRef = studentSnapshot['roomref'];
            final roomId = roomRef is DocumentReference ? roomRef.id : roomRef;
            final studentBuildingNumber = roomId.split('.')[0];
            if (studentSnapshot.exists && studentBuildingNumber == building) {
              filteredHelpRequests.add(helpRequest);
            }
          }
        }
        return filteredHelpRequests;
      }),

      // Stream for attendance alerts from attendance map
      FirebaseFirestore.instance
          .collection('student')
          .snapshots()
          .asyncMap((snapshot) async {
        final List<DocumentSnapshot> filteredStudents = [];
        final supervisorDocSnapshot = await supervisorDocRef.get();

        if (supervisorDocSnapshot.exists) {
          final buildingNumber = supervisorDocSnapshot['building'];

          for (var studentDoc in snapshot.docs) {
            final roomRef = studentDoc['roomref'];
            final roomId = roomRef is DocumentReference ? roomRef.id : roomRef;
            final studentBuildingNumber = roomId.split('.')[0];

            if (studentBuildingNumber == buildingNumber) {
              final attendanceMap = studentDoc['attendance'] as Map<String, dynamic>;
              // Check the latest attendance entries
              final lastDateKey = attendanceMap.keys.last; // Get latest date
              final attendanceStatus = attendanceMap[lastDateKey];

              if (attendanceStatus == 'Absent') {
                filteredStudents.add(studentDoc);
              }
            }
          }
        }
        return filteredStudents;
      }),

          (helpRequests, attendanceAlerts) => [helpRequests, attendanceAlerts],
    );
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
  // Help request tile with asynchronous student name fetching
  Widget buildRequestTile(DocumentSnapshot request) {
    final studentInfoRef = request['studentInfo'] as DocumentReference;

    return FutureBuilder<String>(
      future: getStudentName(studentInfoRef),
      builder: (context, snapshot) {
        // Handle any errors
        if (snapshot.hasError) {
          return ListTile(
            leading: Icon(Icons.error, color: red1),
            title: text(
                t: 'Error fetching student name',
                color: red1,
                align: TextAlign.start),
            subtitle: text(
                t: 'Status: ${request['status']}',
                color: grey1,
                align: TextAlign.start),
          );
        }

        // Display the fetched student name
        final studentName = snapshot.data ?? 'Unknown Student';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: grey2, // Background color for the list item container
            borderRadius: BorderRadius.circular(3), // Rounded corners
          ),
          child: ListTile(
            leading: Icon(Icons.medical_services_outlined,
                color: red1, size: SizeHelper.getSize(context) * 0.09),
            title: GestureDetector(
              onTap: () async {
                final PNUID = await getPNUID(studentInfoRef);

                // Navigate to EmergencyRequestDetails with the student's name
                context.pushNamed(
                  '/EmergencyRequestDetails',
                  extra: EmregencyInfo(
                    pnuid: PNUID,
                    requestId: request.id,
                    location: request['location'],
                  ),
                );
              },
              child: text(
                t: studentName,
                color: dark1,
                align: TextAlign.start,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.check, color: green1),
              onPressed: () => updateRequestStatus(request.id, 'resolved'),
            ),
          ),
        );
      },
    );
  }

  Future<String> getStudentName(DocumentReference studentInfoRef) async {
    try {
      final studentData = await studentInfoRef.get();
      if (studentData.exists) {
        return studentData['efirstName'] +
            ' ' +
            studentData['elastName']; // Fetch the student's full name
      } else {
        return 'Unknown Student'; // Fallback if no student data is found
      }
    } catch (e) {
      print('Error fetching student name: $e');
      return 'Error'; // Fallback in case of error
    }
  }

  Future<String> getPNUID(DocumentReference studentInfoRef) async {
    try {
      final studentData = await studentInfoRef.get();
      if (studentData.exists) {
        return studentData['PNUID']; // Fetch the student's PNUID
      } else {
        return 'Unknown Student'; // Fallback if no student data is found
      }
    } catch (e) {
      print('Error fetching PNUID: $e');
      return 'Error'; // Fallback in case of error
    }
  }

  // Attendance alert tile
  Widget buildAttendanceAlertTile(DocumentSnapshot student, int index,
      List<DocumentSnapshot> combinedList) {
    return Dismissible(
      key: Key(student.id),
      background: Container(
        color: red1,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: SizeHelper.getSize(context) * 0.09,
        ),
      ),
      confirmDismiss: (direction) async {
        return await ErrorDialog(
            "Are you sure you want to remove this alert?", context,
            buttons: [
              {"Delete": () async => context.pop(true)},
              {"Cancel": () async => context.pop(false)},
            ]);
      },
      onDismissed: (direction) {
        setState(() {
          combinedList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alert removed')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: grey2,
          borderRadius: BorderRadius.circular(3),
        ),
        child: ListTile(
          leading: Icon(
            Icons.warning_amber_outlined,
            color: yellow1,
            size: SizeHelper.getSize(context) * 0.09,
          ),
          title: text(
            t: '${student['efirstName']} ${student['elastName'] ?? 'N/A'}',
            color: dark1,
            align: TextAlign.start,
          ),
          subtitle: Dtext(
            t: 'Attendance delayed for 2 days!',
            color: grey1,
            align: TextAlign.start,
            size: 0.03,
          ),
          onTap: () {
            context.pushNamed('/studentdetails', extra: student['PNUID']);
          },
        ),
      ),
    );
  }

  // Utility widgets
  Widget buildErrorText(error) => Center(
      child: text(t: 'Error: $error', color: red1, align: TextAlign.start));
  Widget buildEmptyMessage(String message) =>
      Center(child: text(t: message, color: grey1, align: TextAlign.start));

  // Update help request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('helpRequests')
          .doc(requestId)
          .update({
        'status': status,
      });

      ErrorDialog(
        "Is this request resolved?",
        context,
        buttons: [
          {
            "Yes": () {
              FirebaseFirestore.instance
                  .collection('helpRequests')
                  .doc(requestId)
                  .update({"resolved": true});
              Navigator.of(context).pop();
            }
          },
          {
            "No": () => Navigator.of(context).pop(),
          }
        ],
      );
    } catch (e) {
      print('Error updating request status: $e');
    }
  }
}

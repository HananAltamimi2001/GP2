import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/7-Security/EmergencyRequestDetailsPage.dart';

class SecurityNotifications extends StatefulWidget {
  @override
  State<SecurityNotifications> createState() => SecurityNotificationsState();
}

class SecurityNotificationsState extends State<SecurityNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Notifications'),
      body: StreamBuilder<QuerySnapshot>(
        stream: helpRequestsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: dark1));
          }

          final helpRequests = snapshot.data!.docs;

          if (helpRequests.isEmpty) {
            return Center(child: Text('No help requests at the moment.'));
          }

          // Display help requests in a list with each student's name as the title
          return ListView.builder(
            itemCount: helpRequests.length, // Number of items in the list
            itemBuilder: (context, index) {
              final item = helpRequests[index]; // Get the current item based on the index

              return FutureBuilder<String>(
                future: getStudentName(item['studentInfo'] as DocumentReference),
                builder: (context, studentNameSnapshot) {
                  if (studentNameSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error loading student name'),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: grey2, // Background color for the list item container
                      borderRadius: BorderRadius.circular(3), // Rounded corners
                    ),
                    child: ListTile(
                      leading: Icon(Icons.medical_services_outlined, color: red1 ,size: SizeHelper.getSize(context) * 0.09,),
                      title: GestureDetector(
                        onTap: () async {
                          final studentInfoRef = item['studentInfo'] as DocumentReference;
                          final PNUID = await getPNUID(studentInfoRef);

                          // Navigate to EmergencyRequestDetails with the student's name
                          context.pushNamed(
                            '/EmergencyRequestDetails',
                            extra: EmregencyInfo(
                              pnuid: PNUID,
                              requestId: item.id,
                              location: item['location'],
                            ),
                          );
                        },
                        child: text(
                          t: studentNameSnapshot.data??'',
                          color: dark1,
                          align: TextAlign.start,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.check_outlined, color: green1 , size: SizeHelper.getSize(context) * 0.07),
                        onPressed: () {
                          updateRequestStatus(item.id, 'resolved');
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('helpRequests').doc(requestId).update({
        'status': status,
      });

      ErrorDialog(
        "Is this request resolved?",
        context,
        buttons: [
          {
            "Yes": ()  {
               FirebaseFirestore.instance.collection('helpRequests').doc(requestId).delete();
               FirebaseFirestore.instance.collection('student').doc(FirebaseAuth.instance.currentUser!.uid).update({
                'helpRequests': FieldValue.arrayRemove([
                  FirebaseFirestore.instance.collection('helpRequests').doc(requestId)
                ])
              });
              context.pop();
            },
          },
          {
            "No": () => context.pop(),
          }
        ],
      );


    } catch (e) {
      print('Failed to update status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  Stream<QuerySnapshot> helpRequestsStream() {
    return FirebaseFirestore.instance
        .collection('helpRequests')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getStudentName(DocumentReference studentInfoRef) async {
    try {
      final studentData = await studentInfoRef.get();
      if (studentData.exists) {
        return studentData['efirstName'] +' '+ studentData['elastName']; // Fetch the student's full name
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/1-Manager/3-Appointment/AppointmentDetails.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/SetAppointmentSp.dart';

class AppointmentsSp extends StatefulWidget {
  @override
  AppointmentsSpState createState() => AppointmentsSpState();
}

class AppointmentsSpState extends State<AppointmentsSp> {
  final CollectionReference appoint = FirebaseFirestore.instance.collection("Appointments");
  String? userName; // To store the user's full name
  Stream<QuerySnapshot>? fetchDatas = Stream.empty(); // Initialize fetchDatas with an empty stream

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on initialization
  }

  // Fetch the user data
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('staff').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = '${userDoc['firstName']} ${userDoc['lastName']}';
          });
          // After setting the username, fetch the appointments
          getcomplaint();
        }
      } catch (e) {
        ErrorDialog(
          'Error fetching user data: $e',
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
      }
    }
  }

  // Fetch the appointments after user data is fetched
  void getcomplaint() {
    setState(() {
      fetchDatas = FirebaseFirestore.instance
          .collection("Appointments")
          .where('type', isEqualTo: 'Social Specialist')
          .where('name', isEqualTo: userName)
          .snapshots(); // Assign the stream to fetchDatas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: 'Appointments',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchDatas, // Use the stream directly
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (streamSnapshot.hasError) {
            return Center(child: Text('Error: ${streamSnapshot.error}'));
          } else if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found.'));
          } else {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final appointmentData = documentSnapshot.data() as Map<String, dynamic>;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Color(0xFF007580), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      "Date: ${appointmentData['Date'] ?? 'N/A'} Time: ${appointmentData['Time'] ?? 'N/A'}",
                      style: TextStyle(
                        color: Color(0xFF339199),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Color(0xFF006064)),
                      onPressed: () {
                        context.pushNamed(
                          '/AppointmentDetailsSp',
                          extra: AppointmentInfoM(
                            appointmentId: documentSnapshot.id,
                            appointment: appointmentData,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF006064),
        onPressed: () => showAppointmentDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Show the appointment dialog
  void showAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SetAppointmentScreenSp(); // Ensure this class has a close button
      },
    );
  }
}

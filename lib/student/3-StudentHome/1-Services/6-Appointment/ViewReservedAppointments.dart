import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/viewAppointmentDetails.dart';

class ViewReservedAppointments extends StatelessWidget {
  final CollectionReference fetchData =
  FirebaseFirestore.instance.collection("Appointments");

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OurAppBar(
        title: 'Reserved Appointments',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData
            .where('studentInfo', isEqualTo: FirebaseFirestore.instance.collection('student').doc(currentUserId))
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (streamSnapshot.hasError) {
            return Center(child: Text('Error: ${streamSnapshot.error}'));
          } else if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reserved appointments found.'));
          } else {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

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
                      "Date: ${documentSnapshot['Date']} Time: ${documentSnapshot['Time']}",
                      style: TextStyle(
                        color: Color(0xFF339199),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Color(0xFF006064)),
                      onPressed: () {
                        // Convert to appointmentDatas object and pass it
                        context.pushNamed(
                          "/viewAppointmentDetails",
                          extra: appointmentDatas(appointment: documentSnapshot.data() as Map<String, dynamic>),
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';

class Staffprofile extends StatefulWidget {
  const Staffprofile({Key? key}) : super(key: key);

  @override
  StaffprofileState createState() => StaffprofileState();
}

class StaffprofileState extends State<Staffprofile> {
  DocumentSnapshot? staffData;
  final FirbaseAuthService _auth = FirbaseAuthService();

  @override
  Widget build(BuildContext context) {
    String role = staffData?['role'] ?? 'N/A';
    return Scaffold(
      appBar: OurAppBar(
        title: "Profile",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dtext(
                  t: ' ${staffData?['fullname'] ?? 'N/A'}',
                  align: TextAlign.center,
                  color: dark1,
                  size: 0.06,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007580), width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Role',
                      value: staffData?['role']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Email',
                      value: staffData?['email']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Phone Number',
                      value: staffData?['phone']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Office NO.',
                      value: staffData?['office']?.toString(),
                    ),
                    /*
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Working Peroid',
                      value: staffData?['phone']?.toString(),
                    ),*/
                    /*    (role == 'Housing security guard' || role == 'Resident student supervisor')
            ? RowInfo.buildInfoRow(
                defaultLabel: 'Buliding NO.',
                value: staffData?['buliding']?.toString(),
              )
            : Container(),*/
                  ],
                ),
              ),
            ),
            Heightsizedbox(h: 0.02),
            actionbutton(
                onPressed: () {
                  _auth.signout(context);
                },
                text: "Logout",
                background: red1)
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchstaffData();
  }

  Future<void> fetchstaffData() async {
    try {
      // Check if the user is logged in
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle case where user is not logged in
        print('Staff is not logged in');
        return;
      }

      // Retrieve the staff's data using the user's UID
      String staffId = currentUser.uid;
      print('Staff ID: $staffId');
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('staff') // Corrected the collection name
          .doc(staffId)
          .get();

      if (documentSnapshot.exists) {
        // Only set data if the document exists
        setState(() {
          staffData = documentSnapshot;
        });
      } else {
        // Handle the case where the document does not exist
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching staff data: $e');
    }
  }
}

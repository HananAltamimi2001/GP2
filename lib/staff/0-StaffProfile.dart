import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';

class Staffprofile extends StatefulWidget {
  const Staffprofile({Key? key}) : super(key: key);

  @override
  StaffprofileState createState() => StaffprofileState();
}

class StaffprofileState extends State<Staffprofile> {
  final FirbaseAuthService _auth = FirbaseAuthService();
  late Future<DocumentSnapshot?> staffDataFuture;

  @override
  void initState() {
    super.initState();
    staffDataFuture = fetchstaffData();
  }

  Future<DocumentSnapshot?> fetchstaffData() async {
    try {
      User? currentUser = LoginChecker.user;
      if (currentUser == null) {
        print('Staff is not logged in');
        return null;
      }

      String staffId = currentUser.uid;
      print('Staff ID: $staffId');
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .get();

      if (documentSnapshot.exists) {
        print('Staff data fetched successfully');
        return documentSnapshot;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching staff data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Staff Profile",
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: staffDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No staff data available.'));
          }

          var staffData = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dtext(
                      t: ' ${staffData['efullName'] ?? 'N/A'}',
                      align: TextAlign.center,
                      color: dark1,
                      size: 0.06,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF007580), width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowInfo.buildInfoRow(
                          defaultLabel: 'Role',
                          value: staffData['role']?.toString(),
                        ),
                        RowInfo.buildInfoRow(
                          defaultLabel: 'Email',
                          value: staffData['email']?.toString(),
                        ),
                        RowInfo.buildInfoRow(
                          defaultLabel: 'Phone Number',
                          value: staffData['phone']?.toString(),
                        ),
                        RowInfo.buildInfoRow(
                          defaultLabel: 'Office NO.',
                          value: staffData['office']?.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                Heightsizedbox(h: 0.02),
                actionbutton(
                  onPressed: () {
                    ErrorDialog(
                      "Confirm logout",
                      context,
                      buttons: [
                        {
                          "Confirm": () async => _auth.signout(context),
                        },
                        {
                          "Cancel": () async => context.pop(),
                        }
                      ],
                    );
                  },
                  text: "Logout",
                  background: red1,
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

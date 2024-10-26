import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class studentprofile extends StatefulWidget {
  const studentprofile({Key? key}) : super(key: key);

  @override
  studentprofileState createState() => studentprofileState();
}

class studentprofileState extends State<studentprofile> {
  String? userId;

  DocumentSnapshot? studentData;
  final FirbaseAuthService auth = FirbaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Student Profile",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dtext(
                  t: ' ${studentData?['fullname'] ?? 'N/A'}',
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
                      defaultLabel: 'PNUID',
                      value: studentData?['PNUID']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Email',
                      value: studentData?['email']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Phone Number',
                      value: studentData?['phone']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'ID Type:',
                      value: studentData?['NID']?.toString(),
                      customLabelLogic: (value) {
                        if (value != null && value.startsWith('2')) {
                          return 'Iqama';
                        } else if (value != null && value.startsWith('1')) {
                          return 'National ID';
                        } else {
                          return 'Unknown ID Type';
                        }
                      },
                    ),
/*
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Nationality',
                      value: studentData?['nationality']?.toString(),
                    ),
                     RowInfo.buildInfoRow(
                      defaultLabel: 'Degree',
                      value: studentData?['degree']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Collage',
                      value: studentData?['collage']?.toString(),
                    ),
                    
                     RowInfo.buildInfoRow(
                      defaultLabel: 'Blood Type',
                      value: studentData?['bloodType']?.toString(),
                    ),

                    RowInfo.buildInfoRow(
                      defaultLabel: 'Resident Student',
                      value: studentData?['resident']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Building No.',
                      value: studentData?['buliding no']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Room No.',
                      value: studentData?['buliding no']?.toString(),
                    ),
                     RowInfo.buildInfoRow(
                      defaultLabel: 'Status',
                      value: studentData?['buliding no']?.toString(),
                    ),
*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (userId != null)
                          QrImageView(
                            data: userId!,
                            version: QrVersions.auto,
                            size: 120.0,
                          )
                        else
                          Icon(
                            MdiIcons.qrcodeRemove,
                            size: 40.0,
                            color: red1,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007580), width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Dtext(
                        t: 'Medical Report: ',
                        size: 0.035,
                        align: TextAlign.start,
                        color: dark1,
                      ),
                      Dactionbutton(
                        text: 'View File',
                        background: dark1,
                        fontsize: 0.03,
                        onPressed: () {},
                      ),
                    ]),
                    Heightsizedbox(h: 0.02),
                    Row(children: [
                      Dtext(
                        t: 'Social Security Certificate: ',
                        size: 0.035,
                        align: TextAlign.start,
                        color: dark1,
                      ),
                      Dactionbutton(
                        text: 'View File',
                        background: dark1,
                        fontsize: 0.03,
                        onPressed: () {},
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007580), width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Dtext(
                          t: 'Emergency Contact Information',
                          align: TextAlign.center,
                          color: dark1,
                          size: 0.05,
                        ),
                      ],
                    ),
                    Heightsizedbox(h: 0.01),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Name1',
                      value: studentData?['PNUID']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Email1',
                      value: studentData?['email']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Phone Number1',
                      value: studentData?['phone']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Name2',
                      value: studentData?['PNUID']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Email2',
                      value: studentData?['email']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Phone Number2',
                      value: studentData?['phone']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Home Location',
                      value: studentData?['phone']?.toString(),
                    ),
                  ],
                ),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                actionbutton(
                  onPressed: () {
                  ErrorDialog(
                    "Confirm logout",
                    context,
                    buttons: [
                      {
                        "Confirm": () async => auth.signout(context),
                      },
                      {
                        "Cancel": () async => context.pop(),
                      }
                    ],
                  );
                },
                  text: "Logout",
                  background: red1,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      // Check if the user is logged in
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }

      // Retrieve the student data using the user UID
      setState(() {
        userId = currentUser.uid;
      });

      print('Student ID: $userId');
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .doc(userId)
          .get();

      setState(() {
        studentData = documentSnapshot;
      });
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }
}

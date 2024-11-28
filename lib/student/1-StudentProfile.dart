import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class studentprofile extends StatefulWidget {
  const studentprofile({Key? key}) : super(key: key);

  @override
  studentprofileState createState() => studentprofileState();
}

class studentprofileState extends State<studentprofile> {
  late String userId;

  final FirbaseAuthService auth = FirbaseAuthService();

  Future<DocumentSnapshot?> fetchStudentData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('User is not logged in');
        return null;
      }

      userId = currentUser.uid;
      print('Student ID: $userId');

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .doc(userId)
          .get();

      return documentSnapshot;
    } catch (e) {
      ErrorDialog("Error fetching student data: $e", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Student Profile",
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: fetchStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No student data available.'));
          }

          var studentData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Dtext(
                        t: ' ${studentData['efullName'] ?? 'N/A'}',
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
                            defaultLabel: 'PNUID',
                            value: studentData['PNUID'].toString(),
                          ),
                          RowInfo.buildInfoRow(
                            defaultLabel: 'Email',
                            value: studentData['email'].toString(),
                          ),
                          if (studentData['resident'] == true)
                            Column(
                              children: [
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Phone Number',
                                  value: studentData['phoneNumber'].toString(),
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'ID Type:',
                                  value:
                                      studentData['NID']?.toString() ?? 'N/A',
                                  customLabelLogic: (value) {
                                    if (value != null &&
                                        value.startsWith('2')) {
                                      return 'Iqama';
                                    } else if (value != null &&
                                        value.startsWith('1')) {
                                      return 'National ID';
                                    } else {
                                      return 'Unknown ID Type';
                                    }
                                  },
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Nationality',
                                  value:
                                      studentData?['nationality']?.toString(),
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Degree',
                                  value: studentData?['degree']?.toString(),
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'College',
                                  value: studentData?['college']?.toString(),
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Blood Type',
                                  value: studentData?['bloodType']?.toString(),
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Resident Student',
                                  value: studentData['resident']?.toString(),
                                ),
                                // RowInfo.buildInfoRow(
                                //   defaultLabel: 'Room No.',
                                //   value:
                                //       studentData['roomref'].id,
                                // ),
                             
                              ],
                            ),
                          if (studentData['resident'] == true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (studentData['PNUID'] != null)
                                  QrImageView(
                                    data:studentData['PNUID'],
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
                  if (studentData['resident'] == true)
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF007580), width: 1),
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
                                  padding: 0,
                                  onPressed: () {
                                    context.pushNamed(
                                      '/pdf2',
                                      extra: Pdf(
                                          Url: studentData['medicalReportUrl'],
                                          title: "Medical Report"),
                                    );
                                  }),
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
                                   padding: 0,

                                  onPressed: () {
                                    context.pushNamed(
                                      '/pdf2',
                                      extra: Pdf(
                                          Url: studentData[
                                              "socialSecurityCertificateUrl"],
                                          title: "Social Security"),
                                    );
                                  }),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  Heightsizedbox(h: 0.02),
                  if (studentData['resident'] == true)
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF007580), width: 1),
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
                              defaultLabel: 'Email1',
                              value: studentData?['e1email']?.toString(),
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Phone Number1',
                              value: studentData?['e1phoneNumber']?.toString(),
                            ),
                           RowInfo.buildInfoRow(
                              defaultLabel: 'Email2',
                              value: studentData?['e2email']?.toString(),
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Phone Number2',
                              value: studentData?['e2phoneNumber']?.toString(),
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
                                "Confirm": () async =>
                                    {context.pop(), auth.signout(context)},
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
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

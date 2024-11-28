import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_visitor_req_list.dart';

class SuperPermReqViewVisit extends StatefulWidget {
  final visitorInfo args;

  const SuperPermReqViewVisit({super.key, required this.args});

  @override
  State<SuperPermReqViewVisit> createState() => _SuperPermReqViewVisitState();
}

class _SuperPermReqViewVisitState extends State<SuperPermReqViewVisit> {
  Future<Map<String, dynamic>>? requestData;
  String? studentName;

  @override
  void initState() {
    super.initState();
    requestData = getRequestAndStudentDetails();
  }

  Future<void> acceptVisitor(String visitorId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final docRef = _firestore.collection('VisitorRequest').doc(visitorId);
      await docRef.update({'status': 'Accept'});
    } catch (e) {
      // Handle error here
    }
  }

  Future<void> rejectVisitor(String visitorId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final docRef = _firestore.collection('VisitorRequest').doc(visitorId);
      await docRef.update({'status': 'Reject'});
    } catch (e) {
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "View Request"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: requestData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final data = snapshot.data!;
                studentName = data['studentName']; // Assign studentName
                final room = data['room'];
                final requestData = data['request'];
                return Column(
                  children: [
                    OurContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Titletext(
                              t: studentName ?? 'N/A',
                              color: dark1,
                              align: TextAlign.start,
                            ),
                            OurContainer(
                              backgroundColor: dark1,
                              wdth: .350,
                              hight: 0.06,
                              pddng: 0,
                              child: Center(
                                child: Dtext(
                                  t: 'Visitor Request',
                                  size: 0.035,
                                  align: TextAlign.start,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Student ID',
                              value: requestData['studentId'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Student phone number',
                              value: requestData['phoneNumber'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Room Number',
                              value: room ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Visitor Full Name',
                              value: requestData['visitorName'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Visitor National ID',
                              value: requestData['nationalId'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Relative Relation',
                              value: requestData['relativeRelation'] ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Time',
                              value: requestData['time'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Date',
                              value: requestData['date'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Visiting Duration',
                              value: requestData['visitingDuration'] ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.032),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  actionbutton(
                                    background: red1,
                                    fontsize: 0.04,
                                    text: 'Reject',
                                    onPressed: () async {
                                      await rejectVisitor(
                                          widget.args.requestId);

                                      InfoDialog(
                                          "Visitor request rejected successfully.",
                                          context,
                                          buttons: [
                                            {
                                              "OK": () async => {
                                                    context.pop(),
                                                    context.pop(),
                                                  }
                                            }
                                          ]);
                                    },
                                  ),
                                  actionbutton(
                                    text: 'Accept',
                                    background: green1,
                                    fontsize: 0.04,
                                    onPressed: () async {
                                      await acceptVisitor(
                                          widget.args.requestId);
                                      InfoDialog(
                                          "Visitor request accepted successfully.",
                                          context,
                                          buttons: [
                                            {
                                              "OK": () async => {
                                                    context.pop(),
                                                    context.pop(),
                                                  }
                                            }
                                          ]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getRequestAndStudentDetails() async {
    // Fetch the request details
    DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('VisitorRequest')
        .doc(widget.args.requestId)
        .get();

    if (!requestSnapshot.exists) {
      throw Exception("Request not found");
    }

    var data = requestSnapshot.data() as Map<String, dynamic>;
    DocumentReference studentInfoRef = data['studentInfo'];

    // Fetch the student name
    DocumentSnapshot studentSnapshot = await studentInfoRef.get();
    String roomid = studentSnapshot['roomref'].id;
    String studentName = studentSnapshot['efullName'] ?? 'N/A';

    // Return both the request details and student name
    return {'request': data, 'studentName': studentName, 'room': roomid};
  }
}

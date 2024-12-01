import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_overnight_req_list.dart';

class SuperPermReqViewOvernight extends StatefulWidget {
  final overnightInfo args;

  const SuperPermReqViewOvernight({super.key, required this.args});

  @override
  State<SuperPermReqViewOvernight> createState() =>
      _SuperPermReqViewOvernightState();
}

class _SuperPermReqViewOvernightState extends State<SuperPermReqViewOvernight> {
  Future<Map<String, dynamic>>? requestData;
  String? studentName;

  @override
  void initState() {
    super.initState();
    requestData = getRequestAndStudentDetails();
  }

  Future<void> acceptVisitor(String overnightId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final docRef = _firestore.collection('OvernightRequest').doc(overnightId);
      await docRef.update({'status': 'Accept'});
    } catch (e) {}
  }

  Future<void> rejectVisitor(String overnightId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final docRef = _firestore.collection('OvernightRequest').doc(overnightId);
      await docRef.update({'status': 'Reject'});
    } catch (e) {}
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
                              wdth: .40,
                              hight: 0.06,
                              pddng: 0,
                              child: Center(
                                child: Dtext(
                                  color: Colors.white,
                                  align: TextAlign.start,
                                  t: 'Overnight Request',
                                  size: 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Student ID',
                              value: requestData['studentId'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Student phone number',
                              value: requestData['phoneNumber'] ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Departure date',
                              value: requestData['departureDate'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Departure time',
                              value: requestData['departureTime'] ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Arrival date',
                              value: requestData['arrivalDate'] ?? 'N/A',
                            ),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Arrival time',
                              value: requestData['arrivalTime'] ?? 'N/A',
                            ),
                            Heightsizedbox(h: 0.010),
                            RowInfo.buildInfoRow(
                              defaultLabel: 'Room Number',
                              value: requestData['roomInfo'].toString().replaceAll(
                                      'DocumentReference<Map<String, dynamic>>',
                                      "") ??
                                  'N/A',
                            ),
                            Heightsizedbox(h: 0.032),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  actionbutton(
                                    background: red1,
                                    text: "Reject",
                                    fontsize: 0.04,
                                    onPressed: () async {
                                      await rejectVisitor(
                                          widget.args.overnight);
                                      InfoDialog(
                                          "Overnight request rejected successfully.",
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
                                          widget.args.overnight);
                                      InfoDialog(
                                          "Overnight request accepted successfully.",
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
        .collection('OvernightRequest')
        .doc(widget.args.overnight)
        .get();

    if (!requestSnapshot.exists) {
      throw Exception("Request not found");
    }

    var data = requestSnapshot.data() as Map<String, dynamic>;
    DocumentReference studentInfoRef = data['studentInfo'];

    // Fetch the student name
    DocumentSnapshot studentSnapshot = await studentInfoRef.get();
    String studentName = studentSnapshot['efullName'] ?? 'N/A';
    String roomid = studentSnapshot['roomref'].id;

    // Return both the request details and student name
    return {
      'request': data,
      'studentName': studentName,
      'room': roomid,
    };
  }
}

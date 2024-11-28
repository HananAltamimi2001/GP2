import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:pnustudenthousing/helpers/Design.dart';

class ViewRequestDetails extends StatefulWidget {
  final furniturerequestsid1 args;
  const ViewRequestDetails({super.key, required this.args});

  @override
  State<ViewRequestDetails> createState() => _ViewRequestDetailsState();
}

class _ViewRequestDetailsState extends State<ViewRequestDetails> {
  Map<String, dynamic>? requestData;
  late String studentName;
  String? RoomNo;
  late DocumentReference reqref;
  @override
  void initState() {
    super.initState();
    fetchRequestDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (requestData == null) {
      return Scaffold(
        appBar: OurAppBar(title: "View Request"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String furnitureType = requestData!['FurnitureType'] ?? 'N/A';
    String furnitureService = requestData!['FurnitureService'] ?? 'N/A';
    String time = requestData!['time']?.toString() ?? 'N/A';
    String date = formatDate(requestData!['date']);
    String currentStatus = requestData!['furnitureStatus'] ?? 'N/A';
   // DocumentReference sturef = requestData!['studentInfo'] ?? 'N/A';

    return Scaffold(
      appBar: OurAppBar(title: "View Request"),
      body: Padding(
        padding: EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 325.0,
        ),
        child: OurContainer(
          wdth: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Dtext(
                    t: studentName,
                    color: dark1,
                    align: TextAlign.start,
                    size: 0.053,
                  ),
                  Widthsizedbox(w: 0.06),
                  Container(
                    height: 45,
                    width: 70,
                    decoration: BoxDecoration(
                      color: dark1.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Dtext(
                        t: furnitureService,
                        color: Colors.white,
                        align: TextAlign.center,
                        size: 0.03,
                      ),
                    ),
                  ),
                ],
              ),
              Heightsizedbox(h: 0.016),
              RowInfo.buildInfoRow(
                  defaultLabel: 'Furniture Type', value: furnitureType),
              RowInfo.buildInfoRow(defaultLabel: 'Room No', value: RoomNo),
              RowInfo.buildInfoRow(defaultLabel: 'Time', value: time),
              RowInfo.buildInfoRow(defaultLabel: 'Date', value: date),
              Heightsizedbox(h: 0.04),
              Visibility(
                visible: currentStatus == 'Pending',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    actionbutton(
                      text: 'Reject',
                      background: red1,
                      fontsize: 0.04,
                      onPressed: () {
                        updateRequestStatus(widget.args.requestId, 'Rejected');
                      },
                    ),
                    actionbutton(
                      text: 'Accept',
                      background: dark1,
                      fontsize: 0.04,
                      onPressed: () {
                        updateRequestStatus(widget.args.requestId, 'Accepted');
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: currentStatus == "Accepted",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    actionbutton(
                      text: 'Scan',
                      background: green1,
                      fontsize: 0.04,
                      onPressed: () {
                        context.pushNamed('/qrscanner3', extra: reqref);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchRequestDetails() async {
    var data = await getRequestAndStudentDetails();
    setState(() {
      requestData = data['request'];
      studentName = data['studentName'];
      RoomNo = data['roomNo'];
      reqref = requestData!['requestRef'];

      print('Fetched RoomNo: $RoomNo'); // Debugging line
    });
  }

  Future<Map<String, dynamic>> getRequestAndStudentDetails() async {
    // Fetch the request details
    DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('furnitureRequest')
        .doc(widget.args.requestId)
        .get();

    if (!requestSnapshot.exists) {
      throw Exception("Request not found");
    }

    var data = requestSnapshot.data() as Map<String, dynamic>;
    DocumentReference requestRef = requestSnapshot.reference; // Add this line

    DocumentReference studentInfoRef = data['studentInfo'];

    // Fetch the student name
    DocumentSnapshot studentSnapshot = await studentInfoRef.get();
    String studentName = studentSnapshot['efullName'] ?? 'N/A';
    String roomNo = studentSnapshot['roomref'].id ?? 'N/A';

    // Return both the request details and student name
    return {
      'request': data,
      'studentName': studentName,
      'roomNo': roomNo,
      'requestRef': requestRef, // Include the request reference here
    };
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      if (status == "Rejected") {
        await FirebaseFirestore.instance
            .collection('furnitureRequest')
            .doc(requestId)
            .update({
          'furnitureStatus': status,
          'RejectedAt': FieldValue.serverTimestamp(),
        });

        ErrorDialog(
          "Are you sure you want to reject this request?",
          context,
          buttons: [
            {
              "Confirm": () async => {
                    status = "Rejected",
                    context.pop(),
                    context.pushNamed("/viewfurnitureservicerequests")
                  }
            },
            {
              "Cancel": () async => context.pop(),
            }
          ],
        );
      } else {
        await FirebaseFirestore.instance
            .collection('furnitureRequest')
            .doc(requestId)
            .update({'furnitureStatus': status});

        InfoDialog("Request $status", context, buttons: [
          {
            "OK": () async => {
                  {
                    context.pop(),
                    context.pushNamed("/viewfurnitureservicerequests")
                  }
                }
          }
        ]);
      }
    } catch (e) {
      ErrorDialog("Failed to $status request", context, buttons: [
        {
          "OK": () async => context.pop(),
        }
      ]);
    }
  }

  String formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }
}

/* helper class for pass requestId from View furniture service requests class
 * to View Request Details class in buildings Officer Side */
class furniturerequestsid1 {
  final String requestId;

  furniturerequestsid1({
    required this.requestId,
  });
}


// class ViewRequestDetails extends StatefulWidget {
//   final furniturerequestsid1 args;
//   const ViewRequestDetails({super.key, required this.args});

//   @override
//   State<ViewRequestDetails> createState() => _ViewRequestDetailsState();
// }

// class _ViewRequestDetailsState extends State<ViewRequestDetails> {
//   Future<Map<String, dynamic>>? requestData;
//   late String studentName;
//   String? RoomNo;

//   @override
//   void initState() {
//     super.initState();
//     print("initState called"); // Check if initState runs
//     requestData = getRequestAndStudentDetails();
//   }

//   Future<Map<String, dynamic>>? getRequestAndStudentDetails() async {
//     // Fetch the request details
//     DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
//         .collection('furnitureRequest')
//         .doc(widget.args.requestId)
//         .get();

//     if (!requestSnapshot.exists) {
//       throw Exception("Request not found");
//     }

//     var data = requestSnapshot.data() as Map<String, dynamic>;
//     DocumentReference studentInfoRef = data['studentInfo'];

//     // Fetch the student name
//     DocumentSnapshot studentSnapshot = await studentInfoRef.get();
//     String studentName = studentSnapshot['efullname'] ?? 'N/A';
//     String roomNo = studentSnapshot['roomref'].id ?? 'N/A';

//     // Return both the request details and student name
//     return {
//       'request': data,
//       'studentName': studentName,
//       'roomNo': roomNo,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: OurAppBar(title: "View Request"),
//         body: SafeArea(
//             child: SingleChildScrollView(
//                 child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: FutureBuilder<Map<String, dynamic>>(
//                         future: requestData,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: text(
//                               t: "Error: ${snapshot.error}",
//                               align: TextAlign.center,
//                               color: grey1,
//                             ));
//                           }

//                           final data = snapshot.data!;
//                           final requestData = data['request'];
//                           String furnitureType =
//                               requestData!['FurnitureType'] ?? 'N/A';
//                           String furnitureService =
//                               requestData!['FurnitureService'] ?? 'N/A';
//                           String time =
//                               requestData!['time']?.toString() ?? 'N/A';
//                           String date = formatDate(requestData!['date']);
//                           String currentStatus =
//                               requestData!['furnitureStatus'] ?? 'N/A';

//                           return Padding(
//                             padding: EdgeInsets.only(
//                               left: 10.0,
//                               top: 10.0,
//                               right: 10.0,
//                               bottom: 325.0,
//                             ),
//                             child: OurContainer(
//                               wdth: 300,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Dtext(
//                                         t: studentName ?? 'N/A',
//                                         color: dark1,
//                                         align: TextAlign.start,
//                                         size: 0.053,
//                                       ),
//                                       Widthsizedbox(w: 0.06),
//                                       Container(
//                                         height: 45,
//                                         width: 70,
//                                         decoration: BoxDecoration(
//                                           color: dark1.withOpacity(0.65),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         child: Center(
//                                           child: Dtext(
//                                             t: furnitureService,
//                                             color: Colors.white,
//                                             align: TextAlign.center,
//                                             size: 0.03,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Heightsizedbox(h: 0.016),
//                                   RowInfo.buildInfoRow(
//                                       defaultLabel: 'Furniture Type',
//                                       value: furnitureType),
//                                   RowInfo.buildInfoRow(
//                                       defaultLabel: 'Room No', value: RoomNo),
//                                   RowInfo.buildInfoRow(
//                                       defaultLabel: 'Time', value: time),
//                                   RowInfo.buildInfoRow(
//                                       defaultLabel: 'Date', value: date),
//                                   Heightsizedbox(h: 0.04),
//                                   Visibility(
//                                     visible: currentStatus == 'Pending',
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         actionbutton(
//                                           text: 'Reject',
//                                           background: red1,
//                                           fontsize: 0.04,
//                                           onPressed: () {
//                                             updateRequestStatus(
//                                                 widget.args.requestId,
//                                                 'Rejected');
//                                           },
//                                         ),
//                                         actionbutton(
//                                           text: 'Accept',
//                                           background: dark1,
//                                           fontsize: 0.04,
//                                           onPressed: () {
//                                             updateRequestStatus(
//                                                 widget.args.requestId,
//                                                 'Accepted');
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Visibility(
//                                     visible: currentStatus == "Accepted",
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         actionbutton(
//                                           text: 'Scan',
//                                           background: green1,
//                                           fontsize: 0.04,
//                                           onPressed: () {
//                                             // context.pushNamed('/QrScanner1',
//                                             //     extra: QrData(
//                                             //         sturef: item['sturef'],
//                                             //         Ceckstatus: 'First Check-in'));
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         })))));
//   }

//   Future<void> updateRequestStatus(String requestId, String status) async {
//     try {
//       if (status == "Rejected") {
//         await FirebaseFirestore.instance
//             .collection('furnitureRequest')
//             .doc(requestId)
//             .update({
//           'furnitureStatus': status,
//           'RejectedAt': FieldValue.serverTimestamp(),
//         });

//         ErrorDialog(
//           "Are you sure you want to reject this request?",
//           context,
//           buttons: [
//             {
//               "Confirm": () async => {
//                     status = "Rejected",
//                     context.pop(),
//                     context.pushNamed("/viewfurnitureservicerequests")
//                   }
//             },
//             {
//               "Cancel": () async => context.pop(),
//             }
//           ],
//         );
//       } else {
//         await FirebaseFirestore.instance
//             .collection('furnitureRequest')
//             .doc(requestId)
//             .update({'furnitureStatus': status});

//         InfoDialog("Request $status", context, buttons: [
//           {
//             "OK": () async => context.pop(),
//           }
//         ]);
//       }
//     } catch (e) {
//       ErrorDialog("Failed to $status request", context, buttons: [
//         {
//           "OK": () async => context.pop(),
//         }
//       ]);
//     }
//   }

//   String formatDate(Timestamp timestamp) {
//     return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
//   }
// }

// /* helper class for pass requestId from View furniture service requests class
//  * to View Request Details class in buildings Officer Side */
// class furniturerequestsid1 {
//   final String requestId;

//   furniturerequestsid1({
//     required this.requestId,
//   });
// }

  
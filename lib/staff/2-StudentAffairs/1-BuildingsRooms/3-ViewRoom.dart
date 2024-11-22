import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/1-BuildingsRooms/2-ListRooms.dart';

class RoomDetails extends StatefulWidget {
  final String roomId;

  RoomDetails({
    required this.roomId,
  });

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  late String currentState;

  @override
  void initState() {
    super.initState();
    fetchRoom();
  }

  ////////////////////////Fetch Room////////////////////////
  Future<Map<String, dynamic>> fetchRoom() async {
    try {
      print("Fetching room details for roomId: ${widget.roomId}");

      // Fetch the room document from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Room')
          .doc(widget.roomId)
          .get();
      print("Room document fetched successfully");

      // Check if the room document exists
      if (!snapshot.exists) {
        print("Room not found for roomId: ${widget.roomId}");
        return {};
      }

      // Extract room details
      String status = snapshot['status'];
      String type = snapshot['type'];
      String rid = snapshot.id;
      DocumentReference roomRef = snapshot.reference;
      print("Room details - ID: $rid, Status: $status, Type: $type");

      // Retrieve the document data as a map
      var roomData = snapshot.data() as Map<String, dynamic>?;
      print("Room data retrieved: $roomData");

      // Check if 'studentInfo' exists in the document data
      var studentInfoData =
          roomData != null && roomData.containsKey('studentInfo')
              ? roomData['studentInfo']
              : null;
      print("Student info data found: $studentInfoData");

      // If studentInfo exists and room is "Occupied" or "Partially Occupied"
      if (studentInfoData != null &&
          (status == 'Occupied' || status == 'Partially Occupied')) {
        print(
            "Room is occupied or partially occupied, fetching student details...");

        // Fetch student details
        Map<String, dynamic> studentData =
            await fetchStudentInfo(studentInfoData);
        print("Fetched student data: $studentData");

        // Return combined room and student data
        return {
          'roomid': rid,
          'status': status,
          'type': type,
          'studentInfo': studentData,
          'roomref': roomRef,
        };
      }

      // If no student information, return only room details
      print("Room has no student info, returning room details only");
      return {
        'roomid': rid,
        'status': status,
        'type': type,
        'roomref': roomRef,
        'studentInfo': null,
      };
    } catch (e) {
      print("Error fetching room details: $e");
      return {};
    }
  }

  ////////////////////////Fetch Student////////////////////////
  Future<Map<String, dynamic>> fetchStudentInfo(dynamic studentInfoData) async {
    try {
      // Initialize map to hold student data
      Map<String, dynamic> studentInfo = {};

      if (studentInfoData is DocumentReference) {
        // Handle single student document reference
        DocumentSnapshot studentSnapshot = await studentInfoData.get();
        if (studentSnapshot.exists) {
          studentInfo['studentInfo0'] = {
            'fullName': studentSnapshot['efullName'] ?? 'N/A',
            'email': studentSnapshot['email'] ?? 'N/A',
            'phoneNumber': studentSnapshot['phoneNumber'] ?? 'N/A',
            'VacateHousingStatus': studentSnapshot['VacateHousing'] ?? null,
            'sturef': studentInfoData,
          };
          if (studentSnapshot['VacateHousing'] is DocumentReference) {
            DocumentSnapshot vacateHousingSnapshot =
                await (studentSnapshot['VacateHousing'] as DocumentReference)
                    .get();
            if (vacateHousingSnapshot.exists) {
              studentInfo['studentInfo0']['vacateHousingStatus'] =
                  vacateHousingSnapshot['status'];
            }
          }
          print(
              "Single student information extracted: ${studentInfo['studentInfo0']}");
        } else {
          print("Student document does not exist");
        }
      } else if (studentInfoData is List) {
        // Handle list of student document references
        for (int i = 0; i < studentInfoData.length && i < 3; i++) {
          var studentRef = studentInfoData[i];
          if (studentRef is DocumentReference) {
            DocumentSnapshot studentSnapshot = await studentRef.get();
            if (studentSnapshot.exists) {
              studentInfo['studentInfo${i + 1}'] = {
                'fullName': studentSnapshot['efullName'] ?? 'N/A',
                'email': studentSnapshot['email'] ?? 'N/A',
                'phoneNumber': studentSnapshot['phoneNumber'] ?? 'N/A',
                'VacateHousing': studentSnapshot['VacateHousing'] ?? null,
                'sturef': studentRef,
              };
              if (studentSnapshot['VacateHousing'] is DocumentReference) {
                DocumentSnapshot vacateHousingSnapshot =
                    await (studentSnapshot['VacateHousing']
                            as DocumentReference)
                        .get();
                if (vacateHousingSnapshot.exists) {
                  studentInfo['studentInfo${i + 1}']['vacateHousingStatus'] =
                      vacateHousingSnapshot['status'];
                }
              }
              print(
                  "Assigned to studentInfo$i: ${studentInfo['studentInfo$i']}");
            } else {
              print("Student document at index $i does not exist");
            }
          }
        }
      } else {
        print("Invalid data structure for student references.");
      }

      return studentInfo;
    } catch (e) {
      print("Error fetching student information: $e");
      return {};
    }
  }

  ////////////////////////Update Room Status///////////////
  Future<void> updateRoomStatus(DocumentReference roomref, String status,
      String vacdoc, DocumentReference? sturef) async {
    bool updated = false;
    if ((status == 'Available' ||
            status == 'Cleaning' ||
            status == 'Maintenance') &&
        vacdoc == '') {
      await roomref.update({
        'status': status,
      });
      updated = true;
    } else if ((status == 'Available' ||
            status == 'Cleaning' ||
            status == 'Maintenance') &&
        vacdoc != '') {
      await roomref.update({
        'status': status,
      });

      // Fetch the room data to check the structure of `studentInfo`.
      DocumentSnapshot roomSnapshot = await roomref.get();
      var studentInfo = roomSnapshot['studentInfo'];

      // Check if `studentInfo` is a list or a single document reference.
      if (studentInfo is List) {
        // `studentInfo` is a list, so we create a mutable copy to modify it.
        List updatedStudentInfo = List.from(studentInfo);

        if (updatedStudentInfo.length == 1 &&
            updatedStudentInfo.contains(sturef)) {
          // If there's only one student and it matches `studentRef`, remove the entire field.
          await roomref.update({'studentInfo': FieldValue.delete()});
        } else {
          // Otherwise, remove only the specific student reference.
          updatedStudentInfo.remove(sturef);
          await roomref.update({'studentInfo': updatedStudentInfo});
        }
      } else if (studentInfo is DocumentReference) {
        // `studentInfo` is a single document reference, remove the entire field.
        await roomref.update({'studentInfo': FieldValue.delete()});
      }
    } else if (status == 'Partially Occupied' && vacdoc != '') {
      // Fetch the room data to check the structure of `studentInfo`.
      DocumentSnapshot roomSnapshot = await roomref.get();
      var studentInfo = roomSnapshot['studentInfo'];

      await roomref.update({
        'status': status,
      });
      if (studentInfo is List) {
        // `studentInfo` is a list, so we create a mutable copy to modify it.
        List updatedStudentInfo = List.from(studentInfo);

        if (updatedStudentInfo.length == 2 &&
            updatedStudentInfo.contains(sturef)) {
          updatedStudentInfo.remove(sturef);
          await roomref.update({'studentInfo': updatedStudentInfo});
        }
      }
    }

    if (updated == true) {
      InfoDialog("Room status ($status) updated successfully", context,
          buttons: [
            {
              "Ok": () => {
                    context.pop(),
                    setState(() {
                      fetchRoom();
                    }),
                  }
            }
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Room ${widget.roomId}"),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchRoom(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: dark1));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading room details'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Room not found'));
                  }

                  final roomData = snapshot.data!;
                  final studentData = roomData['studentInfo'];
                  var stu0;
                  var stu1;
                  var stu2;
                  String? vacdoc0 = '';
                  String? vacdoc1 = '';
                  String? vacdoc2 = '';
                  DocumentReference? sturef0 = null;
                  DocumentReference? sturef1 = null;
                  DocumentReference? sturef2 = null;

                  if (studentData != null) {
                    stu0 = studentData['studentInfo0'];
                    if (stu0 != null) {
                      vacdoc0 = stu0['vacateHousingStatus'];
                      sturef0 = stu0['sturef'];
                    }

                    stu1 = studentData['studentInfo1'];
                    if (stu1 != null) {
                      vacdoc1 = stu1['vacateHousingStatus'];
                      sturef1 = stu1['sturef'];
                    }

                    stu2 = studentData['studentInfo2'];
                    if (stu2 != null) {
                      vacdoc2 = stu2['vacateHousingStatus'];
                      sturef2 = stu2['sturef'];
                    }
                  }
                  final roomref = roomData['roomref'];
                  final currentStatus = roomData['status'];
                  final type = roomData['type'];

                  List<Widget> buttons = [];
                  //avaliable
                  if (currentStatus == 'Available') {
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Maintenance', '', null);
                        },
                        text: 'Maintenance',
                        background: yellow2,
                        padding: 10,
                      ),
                    );
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Cleaning', '', null);
                        },
                        text: 'Cleaning',
                        background: blue1,
                        padding: 10,
                      ),
                    );
                    //cleaning
                  } else if (currentStatus == 'Cleaning') {
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Maintenance', '', null);
                        },
                        text: 'Maintenance',
                        background: yellow2,
                        padding: 10,
                      ),
                    );

                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Available', '', null);
                        },
                        text: 'Available',
                        background: green1,
                        padding: 10,
                      ),
                    );
                    //maintance
                  } else if (currentStatus == 'Maintenance') {
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Cleaning', '', null);
                        },
                        text: 'Cleaning',
                        background: blue1,
                        padding: 10,
                      ),
                    );

                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          updateRoomStatus(roomref, 'Available', '', null);
                        },
                        text: 'Available',
                        background: green1,
                        padding: 10,
                      ),
                    );
                    //occupied
                  } else if (((currentStatus == 'Partially Occupied' &&
                              type == 'Partner') ||
                          (currentStatus == 'Occupied' &&
                              type == "Individual")) &&
                      (vacdoc0 == 'Completed' ||
                          vacdoc1 == 'Completed' ||
                          vacdoc2 == 'Completed')) {
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          if (vacdoc0 != '') {
                            updateRoomStatus(
                                roomref, 'Maintenance', vacdoc0!, sturef0);
                          } else if (vacdoc1 != '') {
                            updateRoomStatus(
                                roomref, 'Maintenance', vacdoc1!, sturef1);
                          } else if (vacdoc2 != '') {
                            updateRoomStatus(
                                roomref, 'Maintenance', vacdoc2!, sturef2);
                          }
                        },
                        text: 'Maintenance',
                        background: yellow2,
                        padding: 10,
                      ),
                    );

                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          if (vacdoc0 != '') {
                            updateRoomStatus(
                                roomref, 'Available', vacdoc0!, sturef0);
                          } else if (vacdoc1 != '') {
                            updateRoomStatus(
                                roomref, 'Available', vacdoc1!, sturef1);
                          } else if (vacdoc2 != '') {
                            updateRoomStatus(
                                roomref, 'Available', vacdoc2!, sturef2);
                          }
                        },
                        text: 'Available',
                        background: green1,
                        padding: 10,
                      ),
                    );

                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          if (vacdoc0 != '') {
                            updateRoomStatus(
                                roomref, 'Cleaning', vacdoc0!, sturef0);
                          } else if (vacdoc1 != '') {
                            updateRoomStatus(
                                roomref, 'Cleaning', vacdoc1!, sturef1);
                          } else if (vacdoc2 != '') {
                            updateRoomStatus(
                                roomref, 'Cleaning', vacdoc2!, sturef2);
                          }
                        },
                        text: 'Cleaning',
                        background: blue1,
                        padding: 10,
                      ),
                    );
                  }
                  //fully occupied
                  else if ((currentStatus == 'Occupied' && type == 'Partner') &&
                      (vacdoc0 == 'Completed' ||
                          vacdoc1 == 'Completed' ||
                          vacdoc2 == 'Completed')) {
                    buttons.add(
                      actionbutton(
                        onPressed: () {
                          if (vacdoc0 != '') {
                            updateRoomStatus(roomref, 'Partially Occupied',
                                vacdoc0!, sturef0);
                          } else if (vacdoc1 != '') {
                            updateRoomStatus(roomref, 'Partially Occupied',
                                vacdoc1!, sturef1);
                          } else if (vacdoc2 != '') {
                            updateRoomStatus(roomref, 'Partially Occupied',
                                vacdoc2!, sturef2);
                          }
                        },
                        text: 'Partially Occupied',
                        background: pink1,
                        padding: 10,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Dtext(
                          t: 'Room Information',
                          align: TextAlign.center,
                          color: dark1,
                          fontWeight: FontWeight.w500,
                          size: 0.05,
                        ),
                        OurContainer(
                          backgroundColor: Colors.white24,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Room No',
                                  value: widget.roomId ?? 'N/A',
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Current Status',
                                  value: currentStatus ?? 'N/A',
                                ),
                                RowInfo.buildInfoRow(
                                  defaultLabel: 'Type',
                                  value: type ?? 'N/A',
                                ),
                              ]),
                        ),
                        Heightsizedbox(h: 0.018),
                        if (stu0 != null)
                          Column(
                            children: [
                              Dtext(
                                t: 'Occupant Information',
                                align: TextAlign.center,
                                color: dark1,
                                fontWeight: FontWeight.w500,
                                size: 0.05,
                              ),
                              OurContainer(
                                backgroundColor: Colors.white24,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RowInfo.buildInfoRow(
                                        defaultLabel: 'Full Name',
                                        value: stu0['fullName'] ?? 'N/A',
                                      ),
                                      RowInfo.buildInfoRow(
                                        defaultLabel: 'Email',
                                        value: stu0['email'] ?? 'N/A',
                                      ),
                                      RowInfo.buildInfoRow(
                                        defaultLabel: 'Phone Number',
                                        value: stu0['phoneNumber'] ?? 'N/A',
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        if (stu1 != null || stu2 != null)
                          Column(
                            children: [
                              Dtext(
                                t: 'Occupants Information',
                                align: TextAlign.center,
                                color: dark1,
                                fontWeight: FontWeight.w500,
                                size: 0.05,
                              ),
                              OurContainer(
                                backgroundColor: Colors.white24,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (stu1 != null)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Dtext(
                                                t: 'Student 1',
                                                align: TextAlign.start,
                                                color: dark1,
                                                fontWeight: FontWeight.w500,
                                                size: 0.045,
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Full Name',
                                                value:
                                                    stu1['fullName'] ?? 'N/A',
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Email',
                                                value: stu1['email'] ?? 'N/A',
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Phone Number',
                                                value: stu1['phoneNumber'] ??
                                                    'N/A',
                                              ),
                                            ]),
                                      if (stu2 != null)
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Dtext(
                                                t: 'Student 2',
                                                align: TextAlign.start,
                                                color: dark1,
                                                fontWeight: FontWeight.w500,
                                                size: 0.045,
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Full Name',
                                                value:
                                                    stu2['fullName'] ?? 'N/A',
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Email',
                                                value: stu2['email'] ?? 'N/A',
                                              ),
                                              RowInfo.buildInfoRow(
                                                defaultLabel: 'Phone Number',
                                                value: stu2['phoneNumber'] ??
                                                    'N/A',
                                              ),
                                            ]),
                                    ]),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: buttons,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

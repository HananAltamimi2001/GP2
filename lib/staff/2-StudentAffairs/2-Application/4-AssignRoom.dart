import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/1-BuildingsRooms/2-ListRooms.dart';

class AssignRoom extends StatefulWidget {
  final Room args;
  const AssignRoom({super.key, required this.args});

  @override
  _AssignRoomState createState() => _AssignRoomState();
}

class _AssignRoomState extends State<AssignRoom> {
  Future<List<Map<String, dynamic>>>? fetchRoom;

  @override
  void initState() {
    super.initState();
    fetchRoom = fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Assign a Room'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            fetchRoom, // Use the class variable instead of calling fetchRooms() again
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: dark1));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading Rooms'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Rooms found'));
          }

          List<Map<String, dynamic>> rooms = snapshot.data!;

          return OurListView(
            data: rooms,
            trailingWidget: (item) => Dactionbutton(
              height: 0.044,
              width: 0.19,
              text: 'Assign',
              background: item['color'],
              fontsize: 0.02,
              onPressed: () {
                // Call updateRoomStatus with roomRef and studentRef
                updateRoomStatus(
                  roomRef: item['roomref'],
                  studentRef: widget.args.requestref,
                  context: context, // Pass the context to show the SnackBar
                );
              },
            ),
            title: (item) => "${item['roomId']}",
          );
        },
      ),
    );
  }

  // Fetch Rooms function
  Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      List<Map<String, dynamic>> rooms = [];
      print("Fetching rooms with status not equal to 'Occupied'...");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where('status', isNotEqualTo: "Occupied")
          .get();

      print("Number of rooms fetched: ${snapshot.docs.length}");

      for (var roomDoc in snapshot.docs) {
        Map<String, dynamic> room = roomDoc.data() as Map<String, dynamic>;

        DocumentReference roomDocRef = roomDoc.reference;

        // Determine the color based on status
        Color statusColor = getColorForStatus(room['status'] ?? 'Unknown');
        rooms.add({
          'roomId': roomDoc.id,
          'color': statusColor,
          'status': room['status'],
          'type': room['type'],
          'roomref': roomDocRef,
        });
      }

      rooms.sort((a, b) {
        int aPriority = getStatePriority(a['status']);
        int bPriority = getStatePriority(b['status']);
        return aPriority.compareTo(bPriority);
      });

      return rooms;
    } catch (e) {
      print("Error fetching rooms: $e");
      return [];
    }
  }

  // Helper method to define priorities for different statuses
  int getStatePriority(String status) {
    switch (status) {
      case "Available":
        return 1;
      case "Cleaning":
        return 3;
      case "Maintenance":
        return 4;
      case "Partially Occupied":
        return 2;
      case "Occupied":
        return 5;
      default:
        return 6; // Priority for unknown statuses
    }
  }

  // Method to update room status
  Future<void> updateRoomStatus({
    required DocumentReference roomRef,
    required DocumentReference studentRef,
    required BuildContext context, // Pass context to show SnackBar
  }) async {
    final roomDoc = await roomRef.get();
    if (!roomDoc.exists) {
      print("Room does not exist.");
      return;
    }
    final studentDoc = await studentRef.get();
    if (studentDoc.exists &&
        (studentDoc.data() as Map<String, dynamic>)['roomref'] != null) {
      print("Student is already assigned to a room.");

      ErrorDialog('Student is already assigned to a room!', context, buttons: [
        {
          'Ok': () => {
                context.pop(),
              }
        }
      ]);
      return; // Exit if student already has a room
    }
    final roomData = roomDoc.data() as Map<String, dynamic>?;
    String roomStatus = roomData?['status'] ?? '';
    String roomType = roomData?['type'] ?? '';
    List studentInfo = List.from(roomData?['studentInfo'] ?? []);
    bool updated = false;
    if (roomType == 'Individual' && roomStatus == 'Available') {
      // Update status to 'Occupied' for individual room
      await roomRef.update({
        'status': 'Occupied',
        'studentInfo': studentRef,
      });
      updated = true;
      print("Individual room updated to 'Occupied' with student reference.");
      InfoDialog(
          "Individual room updated to 'Occupied' with student reference.",
          context,
          buttons: [
            {
              'Ok': () => {
                    context.pop(),
                  }
            }
          ]);
    } else if (roomType == 'Partner') {
      if (roomStatus == 'Available') {
        // Set to 'Partially Occupied' and add first student reference for partner room
        studentInfo.add(studentRef);
        await roomRef.update({
          'status': 'Partially Occupied',
          'studentInfo': studentInfo,
        });
        updated = true;

        print(
            "Partner room updated to 'Partially Occupied' with first student reference.");
        InfoDialog(
            "Partner room updated to 'Partially Occupied' with first student",
            context,
            buttons: [
              {
                'Ok': () => {
                      context.pop(),
                    }
              }
            ]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Room partially occupied with first student reference!')),
        );
      } else if (roomStatus == 'Partially Occupied' &&
          studentInfo.length == 1) {
        // Add second student reference and update status to 'Occupied' for partner room
        studentInfo.add(studentRef);
        await roomRef.update({
          'status': 'Occupied',
          'studentInfo': studentInfo,
        });
        updated = true;

        print("Partner room fully occupied with second student reference.");
        ErrorDialog("Partner room fully occupied", context, buttons: [
          {
            'Ok': () => {
                  context.pop(),
                }
          }
        ]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Room fully occupied with second student reference!')),
        );
      } else {
        print("Room is already fully occupied or ineligible for update.");
        ErrorDialog(
            'Room is already fully occupied or ineligible for update!', context,
            buttons: [
              {
                'Ok': () => {
                      context.pop(),
                    }
              }
            ]);
      }
    } else {
      print("Invalid room type or status.");
      InfoDialog('Error occured please try again later', context, buttons: [
        {
          'Ok': () => {
                context.pop(),
              }
        }
      ]);
    }
    studentRef.update({'roomref': roomRef, 'roomstatus': roomStatus});
    String id = studentRef.id;
    if (updated) {
      InfoDialog('Student assigned to a room successfully', context, buttons: [
        {
          'Ok': () => {
                context.pop(),
                context.goNamed("/ApplicationRequestView", extra: requestid(requestId: id)),
              }
        }
      ]);
    }
  }
}

/*
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/AppRoutes.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/studentaffairs/1-BuildingsRooms/2-ListRooms.dart';

class AssignRoom extends StatefulWidget {
  final Room args;
  const AssignRoom({super.key, required this.args});

  @override
  _AssignRoomState createState() => _AssignRoomState();
}

class _AssignRoomState extends State<AssignRoom> {
  Future<List<Map<String, dynamic>>>? fetchRoom;
  @override
  void initState() {
    super.initState();
    fetchRoom = fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Assign a Room'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: dark1),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading Rooms'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Rooms found'));
          }

          List<Map<String, dynamic>> rooms = snapshot.data!;

          return OurListView(
            data: rooms,
            trailingWidget: (item) => Dactionbutton(
              height: 0.044,
              width: 0.19,
              text: 'Assign',
              background: item['color'],
              fontsize: 0.02,
              onPressed: () {
                updateRoomStatus( widget.args.requestref,
                    item['type'], item['roomref']);
              },
            ),
            title: (item) => "${item['roomId']}",
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      List<Map<String, dynamic>> rooms = [];
      print("Fetching rooms with status not equal to 'Occupied'...");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where('status', isNotEqualTo: "Occupied")
          .get();

      print("Number of rooms fetched: ${snapshot.docs.length}");

      for (var roomDoc in snapshot.docs) {
        Map<String, dynamic> room = roomDoc.data() as Map<String, dynamic>;

        // Get the reference of the document itself
        DocumentReference roomDocRef = roomDoc.reference;

        // Log room details
        print("Room Document ID: ${roomDoc.id}");
        print("Room data: $room");

        // Check for the 'status' field
        String status = room['status'] ?? 'Unknown';
        print("Room status: $status");

        // Determine the color based on status
        Color statusColor = getColorForStatus(status);
        print("Status color: $statusColor");
        rooms.add({
          'roomId': roomDoc.id,
          'color': statusColor,
          'status': status,
          'type': room['type'],
          'roomref': roomDocRef,
        });
      }

      print("Rooms before sorting: $rooms");

      // Sort rooms based on the priority of status
      rooms.sort((a, b) {
        int aPriority = getStatePriority(a['status']);
        int bPriority = getStatePriority(b['status']);
        return aPriority.compareTo(bPriority);
      });

      print("Rooms after sorting: $rooms");

      return rooms;
    } catch (e) {
      print("Error fetching requests: $e");
      return [];
    }
  }

// Helper method to define priorities for different statuses
  int getStatePriority(String status) {
    switch (status) {
      case "Available":
        return 1;
      case "Cleaning":
        return 2;
      case "Maintenance":
        return 3;
      case "Partially Occupied":
        return 4;
      case "Occupied":
        return 5;
      default:
        return 6; // Priority for unknown statuses
    }
  }
// avaliable to "Occupied" or "Partially Occupied"

  Future<void> updateRoomStatus(
      // DocumentReference sturef,
      DocumentReference requestId,
      String type,
      DocumentReference roomref) async {
    try {
      // Get the room document
      // DocumentSnapshot roomDoc =
      //     await FirebaseFirestore.instance.collection('Room').doc(roomid).get();
      DocumentSnapshot stuDoc = await requestId.get();

      if (stuDoc.exists) {
        // Safely cast data to a Map
        Map<String, dynamic> studata = stuDoc.data() as Map<String, dynamic>;
        String id = stuDoc.id;
        // Check if the 'roomref' field exists and is not empty
        if (studata.containsKey('roomref')) {
          DocumentReference roomreff = studata['roomref'] ?? null;

          if (roomreff != null) {
            // Show the error dialog if the student is already assigned to a room
            ErrorDialog("Student is already assigned to a room", context,
                buttons: [
                  {
                    'Ok': () => {
                          context.pop(),
                          context.pushNamed("/req",
                              extra: requestid(requestId: id)),
                        }
                  }
                ]);
          }
        } else {
          DocumentSnapshot roomDoc = await roomref.get();
          if (roomDoc.exists) {
            //    print("Room document found for roomid: $roomid");

            // Cast roomDoc.data() as Map<String, dynamic> and retrieve or initialize the list of students
            Map<String, dynamic> roomData =
                roomDoc.data() as Map<String, dynamic>;
            List<dynamic> studentsInfo = roomData['ref'] ?? [];

            print("Current studentsInfo (after initialization): $studentsInfo");

            // Update logic based on the room type and students count
            Map<String, dynamic> updateRoom;
            if (type == 'Partner') {
              updateRoom = {
                'ref':
                    FieldValue.arrayUnion([requestId]), // Add student reference
                'status': studentsInfo.length == 2
                    ? 'Occupied'
                    : "Partially Occupied", // Set status based on count
              };
            } else {
              updateRoom = {
                'ref':
                    requestId, // Add single student reference as list for consistency
                'status': 'Occupied', // Set status based on type
              };
            }

            // Update the room document
            // await FirebaseFirestore.instance
            //     .collection('Room')
            //     .doc(roomid)
            //     .update(updateRoom);
            await roomref.update(updateRoom);
            await requestId.update({'roomref': roomref});
            print("Room document updated with: $updateRoom");

            InfoDialog("Student assigned to room successfully", context,
                buttons: [
                  {
                    'Ok': () => {
                          context.pop(),
                          context.pushNamed("/req",
                              extra: requestid(requestId: id)),
                        }
                  }
                ]);
            setState(() {}); // Refresh the page
          } else {
            // print("Room document not found for roomid: $roomid");
            ErrorDialog("Error occurred, please try again later", context,
                buttons: [
                  {
                    'Ok': () => context.pop(),
                  }
                ]);
          }
        }
      }
    } catch (e) {
      print("Error updating room status: $e");
      ErrorDialog("Error occurred, please try again later $e", context,
          buttons: [
            {
              'Ok': () => context.pop(),
            }
          ]);
    }
  }
}
*/
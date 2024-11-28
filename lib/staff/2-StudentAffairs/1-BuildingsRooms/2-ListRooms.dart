import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class Rooms extends StatefulWidget {
  final String roomId;

  Rooms({
    required this.roomId,
  });

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
    @override
  void initState() {
    super.initState();
    fetchRooms();
  }
  Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      print("Fetching rooms for roomId starting with: ${widget.roomId}");
      List<Map<String, dynamic>> requests = [];

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Room')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: widget.roomId)
          .where(FieldPath.documentId, isLessThan: widget.roomId + '\uf8ff')
          .get();

      print("Fetched ${snapshot.docs.length} documents");

      for (var doc in snapshot.docs) {
        String status = doc['status'];
        print("Room ID: ${doc.id}, Status: $status");
        String rid = doc.id;

        Color statusColor = getColorForStatus(status);
        print("Assigned color for status '$status': $statusColor");

        requests.add({
          'roomid': rid,
          'color': statusColor,
        });
      }

      print("Final requests list: $requests");
      return requests;
    } catch (e) {
      ErrorDialog(
        'Error fetching requests',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String FID = widget.roomId;
    String RID = FID.split('.').last;
    print(RID);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Loading data...");
          return Scaffold(
              appBar: OurAppBar(title: 'Rooms in Floor $RID'),
              body: Center(child: OurLoadingIndicator()));
        }
        if (snapshot.hasError) {
          print("Error in FutureBuilder: ${snapshot.error}");
          return Scaffold(
            appBar: OurAppBar(title: 'Rooms in Floor $RID'),
            body: Center(child: Text("An error occurred while fetching rooms")),
          );
        }

        List<Map<String, dynamic>> requests = snapshot.data ?? [];
        print("Building UI with ${requests.length} requests");
        return Scaffold(
          appBar: OurAppBar(title: 'Rooms in Floor $RID'),
          body: OurListView(
            data: requests,
            trailingWidget: (item) => Dactionbutton(
              height: 0.044,
              width: 0.19,
              text: 'View',
              padding: 0,
              background: item['color'],
              fontsize: 0.03,
              onPressed: () {
                print("View button pressed for room ID: ${item['roomid']}");
                context.pushNamed('/roomDetailes', extra: '${item['roomid']}');
              },
            ),
            title: (item) {
              String roomId = item['roomid']; // Extract roomId from the item
              String RID =
                  roomId.split('.').last; // Get the last part after split

              print(RID); // Print the RID

              return RID.isNotEmpty ? 'Room $RID' : 'No Name';
            },
          ),
        );
      },
    );
  }
}

Color getColorForStatus(String status) {
  print("Getting color for status: $status");
  switch (status) {
    case 'Maintenance':
      return yellow1;
    case 'Cleaning':
      return blue1;
    case 'Occupied':
      return red1;
    case 'Partially Occupied':
      return pink1;
    case 'Available':
      return green1;
    default:
      return grey1;
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BuildingsScreen(),
    );
  }
}


class BuildingsScreen extends StatelessWidget {
  final CollectionReference buildingCollection =
  FirebaseFirestore.instance.collection("Buildings");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Buildings and Rooms",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFF339199),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: StreamBuilder<QuerySnapshot>(
          stream: buildingCollection.snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (streamSnapshot.hasError) {
              return Center(child: Text('Error: ${streamSnapshot.error}'));
            } else if (!streamSnapshot.hasData ||
                streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No buildings found.'));
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final buildingName = documentSnapshot.id;

                  return Card(
                    color: Color(0xFFF1F0F0),
                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: ListTile(
                      title: Text(
                        buildingName,
                        style:
                        TextStyle(fontSize: 25, color: Color(0xFF339199)),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          size: 30,
                          Icons.arrow_forward,
                          color: Color(0xFF006064),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FloorsScreen(
                                    buildingId: documentSnapshot.id),
                              ));
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class FloorsScreen extends StatelessWidget {
  final String buildingId; // ID of the selected building

  FloorsScreen({required this.buildingId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference floorsCollection = FirebaseFirestore.instance
        .collection("Buildings")
        .doc(buildingId)
        .collection("Floors");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Floors",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Color(0xFF339199),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: StreamBuilder<QuerySnapshot>(
          stream: floorsCollection.snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (streamSnapshot.hasError) {
              return Center(child: Text('Error: ${streamSnapshot.error}'));
            } else if (!streamSnapshot.hasData ||
                streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No floors found.'));
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final floorName = documentSnapshot.id;

                  return Card(
                    color: Color(0xFFF1F0F0),
                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: ListTile(
                      title: Text(
                        floorName,
                        style:
                        TextStyle(fontSize: 25, color: Color(0xFF339199)),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          size: 30,
                          Icons.arrow_forward,
                          color: Color(0xFF006064),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomsScreen(
                                buildingId: buildingId, // Pass the building ID
                                floorId:
                                documentSnapshot.id, // Pass the floor ID
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class RoomsScreen extends StatelessWidget {
  final String buildingId; // ID of the selected building
  final String floorId; // ID of the selected floor

  RoomsScreen({required this.buildingId, required this.floorId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference roomsCollection = FirebaseFirestore.instance
        .collection("Buildings")
        .doc(buildingId)
        .collection("Floors")
        .doc(floorId)
        .collection("Rooms");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Rooms",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color(0xFF339199),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: roomsCollection.snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (streamSnapshot.hasError) {
              return Center(child: Text('Error: ${streamSnapshot.error}'));
            } else if (!streamSnapshot.hasData ||
                streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No rooms found.'));
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final roomName = documentSnapshot.id;
                  final roomState = documentSnapshot['state'] ?? 'Available';

                  Color getColorForState(String state) {
                    switch (state) {
                      case 'Maintenance':
                        return Colors.yellow;
                      case 'Cleaning':
                        return Colors.blue;
                      case 'Occupied':
                        return Colors.red;
                      case 'Available':
                      default:
                        return Colors.green;
                    }
                  }

                  return Card(
                    color: Color(0xFFF1F0F0),
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: ListTile(
                      title: Text(
                        roomName,
                        style:
                        TextStyle(fontSize: 25, color: Color(0xFF339199)),
                      ),
                      trailing: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: getColorForState(roomState),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Text(
                            roomState,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailsScreen(
                              buildingId: buildingId,
                              floorId: floorId,
                              roomId: roomName, // Use the room name as the ID
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
class RoomDetailsScreen extends StatefulWidget {
  final String buildingId; // ID of the building
  final String floorId;   // ID of the floor
  final String roomId;    // ID of the room

  RoomDetailsScreen({
    required this.buildingId,
    required this.floorId,
    required this.roomId,
  });

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  String currentState = 'Available'; // Default state

  @override
  void initState() {
    super.initState();
    _fetchRoomState();
  }

  Future<void> _fetchRoomState() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Buildings")
        .doc(widget.buildingId)
        .collection("Floors")
        .doc(widget.floorId)
        .collection("Rooms")
        .doc(widget.roomId)
        .get();

    setState(() {
      currentState = doc['state'] ?? 'Available';
    });
  }

  Future<void> _updateRoomState(String newState) async {
    await FirebaseFirestore.instance
        .collection("Buildings")
        .doc(widget.buildingId)
        .collection("Floors")
        .doc(widget.floorId)
        .collection("Rooms")
        .doc(widget.roomId)
        .update({'state': newState});

    setState(() {
      currentState = newState;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Room state updated to $newState'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final stateColors = {
      'Available': Colors.green,
      'Occupied': Colors.red,
      'Cleaning': Colors.blue,
      'Maintenance': Colors.yellow,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.roomId}"),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Color(0xFF339199),
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              "${widget.roomId} Needs:",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF339199)),
            ),
            SizedBox(height: 20),
            Text(
              "Current State: $currentState",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF339199)),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Available', 'Occupied'].map((state) {
                    return GestureDetector(
                      onTap: () {
                        _updateRoomState(state);
                      },
                      child: Container(
                        height: 80,
                        width: 160,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: stateColors[state],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: currentState == state ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            state,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20), // Space between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Cleaning', 'Maintenance'].map((state) {
                    return GestureDetector(
                      onTap: () {
                        _updateRoomState(state);
                      },
                      child: Container(
                        height: 80,
                        width: 160,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: stateColors[state],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: currentState == state ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            state,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:appointment/HousingManagerServices/Appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HousinManager());}

class HousinManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _FirstScreenM(),
    );
  }
}

class _FirstScreenM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Housing Manager services",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Color(0xFF339199),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListTile(
        title: Column(
          children: [
            SizedBox(height: 250),
            _buildButton(
              context,
              "Search for Student",
              Icons.search,
              true,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            SizedBox(height: 15),
            _buildButton(
              context,
              "Complaints",
              Icons.chat,
              false,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintsScreen()),
                );
              },
            ),
            SizedBox(height: 15),
            _buildButton(
              context,
              "Appointments",
              Icons.calendar_today,
              true,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HouseManager()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon,
      bool isLeftIcon, VoidCallback onPressed) {
    return Container(
      height: 80,
      width: 390,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF339199),
        ),
        child: Row(
          mainAxisAlignment: isLeftIcon
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            if (isLeftIcon)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF007580),
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 50),
                ),
              ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 25, color: Colors.white, height: 2),
                textAlign: isLeftIcon ? TextAlign.start : TextAlign.end,
              ),
            ),
            if (!isLeftIcon)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF007580),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  //final CollectionReference HTime = FirebaseFirestore.instance.collection("SetAppointments");
  void _performSearch() {
    String searchTerm = _searchController.text;
    print("Searching for: $searchTerm");
    // You can display results or perform further actions based on the search term
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Search for Student",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Color(0xFF339199)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _performSearch();
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF339199), width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 70,
              width: 380,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuildingsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF339199),
                ),
                child: Text(
                  "By building location",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Complaints",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Color(0xFF339199),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
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
            " Buildings",
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
                  return Card(
                    color: Color(0xFFF1F0F0),
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: ListTile(
                      title: Text(
                        roomName,
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFF339199)),),
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
                                builder: (context) => RoomDetailsScreen(
                                  buildingId: buildingId,
                                  floorId: floorId,
                                  roomId: roomName, // Use the room name as the ID
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

  @override
  Widget build(BuildContext context){
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
              "STUDENT NAME",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF339199)),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
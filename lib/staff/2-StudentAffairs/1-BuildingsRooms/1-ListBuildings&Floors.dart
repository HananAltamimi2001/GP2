import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class Buildings extends StatelessWidget {
  List<String> buildings = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Buildings'),
      body: ListView.builder(
        itemCount: buildings.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: grey2, // Background color for the list item container
              borderRadius: BorderRadius.circular(3), // Rounded corners
            ),
            child: ListTile(
              title: text(
                t: 'Building ${buildings[index]}',
                align: TextAlign.start,
                color: dark1,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: dark1,
                  size: SizeHelper.getSize(context) * 0.09,
                ),
                onPressed: () {
                  context.pushNamed('/floor', extra: '${buildings[index]}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class Floors extends StatelessWidget {
  final String buildingId; // ID of the selected building

  Floors({required this.buildingId});

  List<String> floors = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Floors in Building $buildingId'),
      body: ListView.builder(
        itemCount: floors.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: grey2, // Background color for the list item container
              borderRadius: BorderRadius.circular(3), // Rounded corners
            ),
            child: ListTile(
              title: text(
                t: 'Floor ${floors[index]}',
                align: TextAlign.start,
                color: dark1,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: dark1,
                  size: SizeHelper.getSize(context) * 0.09,
                ),
                onPressed: () {
                  //saverooms();
                  context.pushNamed('/room',
                      extra: '${buildingId}.${floors[index]}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}



Future<void> saverooms() async {
  for (int i = 1; i <= 6; i++) {
    for (int j = 1; j <= 6; j++) {
      for (int k = 1; k <= 3; k++) {
        String roomId = '$i.$j.$k';
        String type = '';
        // Randomly generate the room status
        String status = generateRandomStatus();

        // Determine the room type based on the status
        if (i == 1 || i == 3 || 1 == 5) {
          type = 'Partner';
        } else {
          type = 'Individual';
        }

        // Define the room data to be added to Firestore
        final roomData = {
          'status': status,
          'type': type,
          
        };

        // Add room data to Firestore in the 'Room' collection
        await FirebaseFirestore.instance
            .collection('Room')
            .doc(roomId)
            .set(roomData);
        print(roomId);
      }
    }
  }
}

String generateRandomStatus() {
  // Define the list of possible statuses
  List<String> statuses = ['Cleaning', 'Maintenance', 'Available'];

  // Generate a random index to select a status
  int randomIndex = Random().nextInt(statuses.length);

  // Return the randomly selected status
  return statuses[randomIndex];
}

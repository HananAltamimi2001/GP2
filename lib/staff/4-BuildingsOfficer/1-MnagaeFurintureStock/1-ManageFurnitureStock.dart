import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class ManageFurnitureStock extends StatefulWidget {
  const ManageFurnitureStock({super.key});

  @override
  State<ManageFurnitureStock> createState() => ManageFurnitureStockState();
}

class ManageFurnitureStockState extends State<ManageFurnitureStock> {
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> furnitureRows = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, String> furnitureIds = {
    'Table': '1T1',
    'Bed': '1B1',
    'Bedside table': '1BT1',
    'Curtain': '1C1',
    'Office Chair': '1OC1',
  };

  @override
  void initState() {
    super.initState();
    furnitureRows.add({'FurnitureType': '', 'Count': 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Manage Furniture Stock'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned(
                child: ListView.builder(
                  itemCount: furnitureRows.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownList(
                              hint: "Furniture Type",
                              items: furnitureIds.keys.toList(),
                              onItemSelected: (value) {
                                setState(() {
                                  furnitureRows[index]['FurnitureType'] = value;
                                });
                              },
                            ),
                          ),
                          Widthsizedbox(w: 0.02),
                          buildCounter(index),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: addNewRow,
                    icon: Icon(Icons.add, color: dark1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: actionbutton(
                    onPressed: saveFurnitureStock,
                    text: "Insert",
                    background: dark1,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    onPressed: removeRow,
                    icon: Icon(Icons.remove, color: dark1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewRow() {
    if (furnitureRows.length < 8) {
      setState(() {
        furnitureRows.add({'FurnitureType': '', 'Count': 1});
      });
    } else {
      ErrorDialog("You can add a maximum of 8 fields", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    }
  }

  void removeRow() {
    if (furnitureRows.length > 1) {
      setState(() {
        furnitureRows.removeLast();
      });
    } else {
      ErrorDialog("At least one field is required", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    }
  }
void saveFurnitureStock() async {
  try {
    final List<Map<String, dynamic>> qrDataList = []; // Stores furniture type and its QR codes.

    for (var row in furnitureRows) {
      final type = row['FurnitureType'];
      final count = row['Count'];

      // Validation to ensure furniture type is selected
      if (type == null || type.isEmpty) {
        ErrorDialog("Please select a furniture type for all fields", context, buttons: [
          {"OK": () async => context.pop()},
        ]);
        return;
      }

      final furnitureId = furnitureIds[type]!;
      final docRef = firestore.collection('furnitureStock').doc(furnitureId);
      final subCollectionRef = docRef.collection('stock'); // The subcollection reference
      final docSnapshot = await docRef.get();

      int totalItems = 0; // Track the total number of items in the parent document

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['total'] != null) {
          totalItems = data['total']; // Get the current total from the document
        }
      }

      // Generate new QR codes starting from the correct index.
      final qrCodes = List.generate(count, (index) => '$furnitureId-${totalItems + index + 1}');
      qrDataList.add({
        'type': type,
        'qrCodes': qrCodes
      }); // Add type and QR codes to the list.

      if (docSnapshot.exists) {
        // Update the parent document with availableQuantity and total
        await docRef.update({
          'availableQuantity': FieldValue.increment(count),
          'total': FieldValue.increment(count), // Increment the total number of items
        });

        // Add each QR code as a separate document in the subcollection
        for (var qrCode in qrCodes) {
          await subCollectionRef.doc(qrCode).set({
            'status': 'available', // Set initial status to 'available'
          });
        }
        print("Updated parent document and added QR codes to subcollection");
      } else {
        // Create a new document in furnitureStock if it doesn't exist
        await docRef.set({
          'furnitureName': type,
          'furnitureId': furnitureId,
          'availableQuantity': count,
          'total': count, // Set total to the number of new items
        });

        // Add each QR code as a separate document in the subcollection
        for (var qrCode in qrCodes) {
          await subCollectionRef.doc(qrCode).set({
            'status': 'available', // Set initial status to 'available'
          });
        }
        print("Created new document and added QR codes to subcollection");
      }
    }

    // Show success dialog after all operations
    InfoDialog("The furniture items were inserted successfully.", context, buttons: [
      {"OK": () async => context.pop()},
      {
        "QR Codes": () async => {
          context.pop(),
          context.pushNamed("/QRCodeDisplay", extra: qrDataList)
        }
      },
    ]);
  } catch (e) {
    print("Error occurred: $e"); // Debugging error
    ErrorDialog("An error occurred: $e", context, buttons: [
      {"OK": () async => context.pop()},
    ]);
  }
}

  Widget buildCounter(int index) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: dark1,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (furnitureRows[index]['Count'] > 1) {
                setState(() {
                  furnitureRows[index]['Count'] -= 1;
                });
              }
            },
            child: counterButton("-", 20, 35),
          ),
          Container(
            width: 20,
            height: 35,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              color: dark1,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '${furnitureRows[index]['Count']}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                furnitureRows[index]['Count'] += 1;
              });
            },
            child: counterButton("+", 20, 35),
          ),
        ],
      ),
    );
  }

  Widget counterButton(String text, double width, double height) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: dark1,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

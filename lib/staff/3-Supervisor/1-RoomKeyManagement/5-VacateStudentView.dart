import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/3-Vacateing/1-List.dart';

class VacateStudentView extends StatefulWidget {
  final DocumentReference sturef;

  const VacateStudentView({super.key, required this.sturef});

  @override
  State<VacateStudentView> createState() => _VacateStudentViewState();
}

class _VacateStudentViewState extends State<VacateStudentView> {
  Future<Map<String, dynamic>>? getRequest;

  @override
  void initState() {
    super.initState();
    getRequest = getDocumentData(widget.sturef);
  }

  Future<Map<String, dynamic>> getDocumentData(DocumentReference docRef) async {
    try {
      // Fetch the document snapshot
      DocumentSnapshot snapshot = await docRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Return the data as a Map
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // Handle the case where the document doesn't exist
        throw Exception("Document does not exist");
      }
    } catch (e) {
      // Handle any errors that occur
      print("Error fetching document: $e");
      rethrow; // Re-throw the exception to handle it outside the function if needed
    }
  }

  Future<void> updateRoomKey(DocumentReference docRef) async {
    try {
      await docRef.update({"roomKey": false});
      print("Field updated successfully");
    } catch (e) {
      print("Error updating field: $e");
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
              future: getRequest,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final Data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Student name
                    text(
                      t: "Student name:",
                      align: TextAlign.center,
                      color: dark1,
                    ),
                    OurContainer(
                      child: Dtext(
                        t: Data['fullName'],
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        size: 0.055,
                      ),
                      backgroundColor: grey2,
                      borderColor: green1,
                      wdth: 0.9,
                      hight: 0.12,
                      pddng: 6,
                      borderRadius: 15,
                    ),
                    Heightsizedbox(h: 0.018),
                    text(
                      t: "Student ID:",
                      align: TextAlign.center,
                      color: dark1,
                    ),
                    OurContainer(
                      child: Dtext(
                        t: Data['PNUID'],
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        size: 0.055,
                      ),
                      backgroundColor: grey2,
                      borderColor: green1,
                      wdth: 0.9,
                      hight: 0.12,
                      pddng: 6,
                      borderRadius: 15,
                    ),
                    Heightsizedbox(h: 0.018),
                    text(
                      t: "Room Number:",
                      align: TextAlign.center,
                      color: dark1,
                    ),
                    OurContainer(
                      child: Dtext(
                        t: Data['roomref'].id,
                        align: TextAlign.center,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        size: 0.055,
                      ),
                      backgroundColor: grey2,
                      borderColor: green1,
                      wdth: 0.9,
                      hight: 0.12,
                      pddng: 6,
                      borderRadius: 15,
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
}

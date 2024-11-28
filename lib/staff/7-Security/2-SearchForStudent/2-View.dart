import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class StudentViewS extends StatefulWidget {
  final DocumentReference sturef;
  const StudentViewS({super.key, required this.sturef});

  @override
  State<StudentViewS> createState() => _StudentViewSState();
}

class _StudentViewSState extends State<StudentViewS> {
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
      ErrorDialog(
        'Error fetching document',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      print("Error fetching document: $e");
      rethrow; // Re-throw the exception to handle it outside the function if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: OurAppBar(title: "View Student"),
        body: SafeArea(child: LayoutBuilder(builder: (context, cons) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: getRequest,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      final Data = snapshot.data!;
                      final String roomId = Data['roomref'].id;
                      final String fullname = Data['fullName'] ?? 'N/A';
                      final String efullname = Data['efullName'] ?? 'N/A';
                      final String phoneNumber = Data['phoneNumber'] ?? 'N/A';
                      final String email = Data['email'];
                      final String PNUID = Data['PNUID'];

                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Student name arabic
                              text(
                                  t: "Student name in Arabic:",
                                  align: TextAlign.center,
                                  color: dark1),
                              OurContainer(
                                child: Dtext(
                                  t: fullname,
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
                              //Student name english
                              text(
                                  t: "Student name in English:",
                                  align: TextAlign.center,
                                  color: dark1),
                              OurContainer(
                                child: Dtext(
                                  t: efullname,
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

                              //Student PNUID
                              text(
                                  t: "Student PNUID:",
                                  align: TextAlign.start,
                                  color: dark1),
                              OurContainer(
                                child: Dtext(
                                  t: PNUID,
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
                              //Email
                              text(
                                t: "Email:",
                                align: TextAlign.center,
                                color: dark1,
                              ),
                              OurContainer(
                                child: Dtext(
                                  t: email,
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

                              //PHONE NUMBER
                              text(
                                t: "Phone Nmuber:",
                                align: TextAlign.center,
                                color: dark1,
                              ),
                              OurContainer(
                                child: Dtext(
                                  t: phoneNumber,
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
                                  t: roomId,
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
                            ]),
                      );
                    },
                  ),
                ),
              ));
        })));
  }
}

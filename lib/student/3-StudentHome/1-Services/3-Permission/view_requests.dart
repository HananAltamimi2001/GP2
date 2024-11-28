import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pnustudenthousing/helpers/Design.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({super.key});

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  String? fieldValue1;
  String? fieldValue2;
  @override
  void initState() {
    super.initState();
    fetchReferencedDoc1Value();
    fetchReferencedDoc2Value();

  }

  void fetchReferencedDoc1Value() async {
    try {
      // Step 1: Get the current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user is signed in");
        return;
      }

      String userUid = currentUser.uid;

      // Step 2: Get the user's document (assuming it's stored in a 'users' collection)
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('student').doc(userUid);

      // Fetch the user's document
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        // Step 3: Get the document reference from a specific field (e.g., 'linkedDocRef')
        DocumentReference? linkedDocRef = userSnapshot.get('OvernightRequest');

        // Step 4: Fetch the referenced document
        if (linkedDocRef != null) {
          DocumentSnapshot linkedSnapshot = await linkedDocRef.get();

          if (linkedSnapshot.exists) {
            // Step 5: Access a specific field in the referenced document (e.g., 'someField')
            fieldValue1 = linkedSnapshot.get('status');
            setState(() {});

            // Update the UI
            print('Value from referenced document: $fieldValue1 ');
          } else {
            ErrorDialog(
              'Referenced document does not exist',
              context,
              buttons: [
                {
                  "Ok": () => context.pop(),
                },
              ],
            );
          }
        } else {
          ErrorDialog(
            "Field 'linkedDocRef' is null or does not exist in the user document",
            context,
            buttons: [
              {
                "Ok": () => context.pop(),
              },
            ],
          );
        }
      } else {
        ErrorDialog(
          'User document does not exist',
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
      }
    } catch (e) {
      ErrorDialog(
        'Error',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      print("Error: $e");
    }
    setState(() {});
  }

  void fetchReferencedDoc2Value() async {
    try {
      // Step 1: Get the current user's UID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print("No user is signed in");
        return;
      }

      String userUid = currentUser.uid;

      // Step 2: Get the user's document (assuming it's stored in a 'users' collection)
      DocumentReference userDocRef2 =
          FirebaseFirestore.instance.collection('student').doc(userUid);

      // Fetch the user's document
      DocumentSnapshot userSnapshot2 = await userDocRef2.get();

      if (userSnapshot2.exists) {
        // Step 3: Get the document reference from a specific field (e.g., 'linkedDocRef')
        DocumentReference? linkedDocRef2 = userSnapshot2.get('VisitorRequest');

        // Step 4: Fetch the referenced document
        if (linkedDocRef2 != null) {
          DocumentSnapshot linkedSnapshot2 = await linkedDocRef2.get();

          if (linkedSnapshot2.exists) {
            // Step 5: Access a specific field in the referenced document (e.g., 'someField')
            fieldValue2 = linkedSnapshot2.get('status');
            setState(() {});

            // Update the UI
            print('Value from referenced document: $fieldValue2');
          } else {
            ErrorDialog(
              'Referenced document does not exist',
              context,
              buttons: [
                {
                  "Ok": () => context.pop(),
                },
              ],
            );
          }
        } else {
          ErrorDialog(
            "Field 'linkedDocRef' is null or does not exist in the user document",
            context,
            buttons: [
              {
                "Ok": () => context.pop(),
              },
            ],
          );
        }
      } else {
        ErrorDialog(
          'User document does not exist',
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
      }
    } catch (e) {
      ErrorDialog(
        'Error',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "View Requests",
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Heightsizedbox(h: 0.04),
                OurStatusContainer(
                  requestStatus:
                      TextCapitalizer.CtextS(fieldValue1.toString()),
                  labels: [
                    'Awaiting',
                    'Pending',
                    'Accept',
                  ],
                  title: "Overnight request status",
                ),
                Heightsizedbox(h: 0.025),
                OurStatusContainer(
                  requestStatus:
                      TextCapitalizer.CtextS(fieldValue2.toString()),
                  labels: [
                    'Awaiting',
                    'Pending',
                    'Accept',
                  ],
                  title: "Visitor request status",
                ),
              ],
            )),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

class sendcomplaint extends StatefulWidget {
  sendcomplaint({super.key});

  @override
  State<sendcomplaint> createState() => _sendcomplaintState();
}

class _sendcomplaintState extends State<sendcomplaint> {
  final _formKey = GlobalKey<FormState>();
  // Form key to validate the form.
  TextEditingController complaintTitle = TextEditingController();
  // Controller for the complaint Title.
  TextEditingController complaintIssues = TextEditingController();
  // Controller for the complaint Issues .
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Send Complaint",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around the form
        child: Form(
          key: _formKey, // Form key for validation and state management
          child: SingleChildScrollView(
            child: Column(children: [
              Heightsizedbox(
                  h: 0.01), // Add vertical spacing using a custom spacer from our desi,
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align text to the end of the row
                children: [
                  Dtext(
                    t: "Please report your issues ",
                    align: TextAlign.start,
                    color: dark1,
                    size: 0.04,
                  ),
                ],
              ),
              // Input text form field for the complaint Title from our Design library
              textform(
                controller: complaintTitle,
                hinttext: "complaint title",
                lines: 1,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please Write complaint title";
                  }
                  return null;
                },
              ),
              Heightsizedbox(
                  h: 0.02), // Add vertical spacing using a custom spacer from our desi,

              // Input text form field for the complaint Title from our Design library
              textform(
                controller: complaintIssues,
                hinttext: "complaint Issues",
                lines: 10,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please Write complaint Issues";
                  }
                  return null;
                },
              ),
              Heightsizedbox(
                  h: 0.04), // Add vertical spacing using a custom spacer from our desi,

              Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Align button to the end of the row
                  children: [
                    actionbutton(
                        onPressed: () {
                          _uploadData();
                        },
                        background: dark1,
                        text: 'Send',
                        fontsize: 0.05),
                  ]),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data.

      String studentId =
          FirebaseAuth.instance.currentUser!.uid; // Current user ID
      DocumentReference studentDocRef =
          FirebaseFirestore.instance.collection('student').doc(studentId);

      try {
        // Step 1: Create a new document in the furnitureRequest collection
        DocumentReference complaintsDocRef =
            await FirebaseFirestore.instance.collection('complaints').add({
          'complaintTitle': complaintTitle.text,
          'complaintIssues': complaintIssues.text,
          'studentInfo': studentDocRef, // Save the student reference
          'uploadDate': DateTime.now(),
        });

        // Step 2: Save the furnitureRequest document reference in the student document
        await studentDocRef.update({
          'complaints': FieldValue.arrayUnion([complaintsDocRef])
        });

        // Clear the input field after submission
        complaintTitle.clear();
        complaintIssues.clear();

        //Show a success message after everything is saved.
        InfoDialog(
          "complaint send successfully",
          context,
          buttons: [
            {
              "OK": () async => context.pop(),
            },
          ],
        );
      } catch (e) {
        ErrorDialog(
          "An error occurred while sending the Replay",
          context,
          buttons: [
            {
              "OK": () async => context.pop(),
            },
          ],
        );
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class VisitorRequest extends StatefulWidget {
  const VisitorRequest({super.key});

  @override
  State<VisitorRequest> createState() => _VisitorRequestState();
}

class _VisitorRequestState extends State<VisitorRequest> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final _formKey = GlobalKey<FormState>();

  //TEXT EDITING CONTROLLERS
  TextEditingController _visitorFullNameController = TextEditingController();
  TextEditingController _visitorNationalIDController = TextEditingController();
  TextEditingController _relativeRelationController = TextEditingController();

  TextEditingController durationController = TextEditingController();

  bool _canSubmitRequest = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APP BAR AND THE FORM
      appBar: OurAppBar(
        title: "Visitor Request",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Heightsizedbox(h: 0.025),
            text(
              t: "Fill the required information",
              color: green1,
              align: TextAlign.center,
            ),
            Heightsizedbox(
              h: 0.020,
            ),
            // ***************USER INFO***************

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: textform(
                      controller: _visitorFullNameController,
                      validator: (val) => val == ""
                          ? "Please write your visitor's full name"
                          : val!.contains(RegExp(r'[0-9]')) // Check for numbers
                              ? "Full name cannot contain numbers"
                              : val!.contains(RegExp(
                                      r'[^\w\s]')) // Check for special characters
                                  ? "Full name cannot contain special characters"
                                  : null,
                      hinttext: "Visitor's full name",
                      lines: 1,
                    ),
                  ),
                  Heightsizedbox(
                    h: 0.0018,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: // National ID or Iqama
                        textform(
                      controller: _visitorNationalIDController,
                      hinttext: "Visitor's National ID or Iqama",
                      lines: 1,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please write your ID";
                        } else if (val.length != 10) {
                          return "NID must be 10 digits long";
                        } else if (!RegExp(r'^\d{10}$').hasMatch(val)) {
                          return "NID must contain only numbers";
                        }
                        return null;
                      },
                    ),
                  ),
                  Heightsizedbox(
                    h: 0.0018,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: textform(
                      controller: _relativeRelationController,
                      hinttext: "Relative Relation",
                      lines: 1,
                      validator: (val) => val == ""
                          ? "Please write your relative relation"
                          : val!.contains(RegExp(r'[0-9]')) // Check for numbers
                              ? "Last name cannot contain numbers"
                              : val!.contains(RegExp(
                                      r'[^\w\s]')) // Check for special characters
                                  ? "Last name cannot contain special characters"
                                  : null,
                    ),
                  ),
                  Heightsizedbox(
                    h: 0.0018,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: textform(
                      controller: durationController,
                      hinttext: "Visiting Duration",
                      lines: 1,
                      validator: (val) => val == ""
                          ? "Please write the visiting duration"
                          : val!.contains(RegExp(
                                  r'[^\w\s]')) // Check for special characters
                              ? "Last name cannot contain special characters"
                              : null,
                    ),
                  ),
                  Heightsizedbox(
                    h: 0.0018,
                  ),
                ],
              ),
            ),

            // ***************FOR THE TIME AND DATE***************
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(children: [
                    //****TIME****
                    OurFormField(
                      fieldType: 'time',
                      selectedTime: selectedTime,
                      onSelectTime: () async {
                        final TimeOfDay? pickedTime = await pickTime(
                            context); // the pickTime(context) it`s the function in the bellow (18 in this Design file)
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime =
                                pickedTime; // Update the selected time
                          });
                        }
                      },
                      labelText:
                          "Select Time:", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                    Heightsizedbox(
                      h: 0.01,
                    ),
                    OurFormField(
                      fieldType: 'date',
                      selectedDate: selectedDate,
                      onSelectDate: () async {
                        final DateTime? pickedDate = await pickDate(
                            context); // the pickDate(context) it`s the function in the bellow (19 in this Design file)
                        if (pickDate != null) {
                          setState(() {
                            selectedDate =
                                pickedDate; // Update the selected date
                          });
                        }
                      },
                      labelText:
                          "Select Date:", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                  ]),

                  Heightsizedbox(
                    h: 0.02,
                  ),
                  // ******************SUBMITREQUEST*************
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: actionbutton(
                        background: dark1,
                        text: "Submit Request",
                        onPressed: _canSubmitRequest
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  final firestore = FirebaseFirestore.instance;
                                  final String currentUserId =
                                      await FirebaseAuth
                                          .instance.currentUser!.uid;
                                  final studentDoc = await firestore
                                      .collection('student')
                                      .doc(currentUserId)
                                      .get();
                                  final studentData = studentDoc.data();

                                  final DocumentReference studentDocRef =
                                      FirebaseFirestore.instance
                                          .collection('student')
                                          .doc(currentUserId);

                                  DocumentReference visitorReqDocRef =
                                      FirebaseFirestore.instance
                                          .collection('VisitorRequest')
                                          .doc();

                                  if (studentData != null) {
                                    final String fullName =
                                        studentData['firstName'] +
                                            ' ' +
                                            studentData['lastName'];
                                    final Visitorname =
                                        _visitorFullNameController.text;
                                    final NationalId =
                                        _visitorNationalIDController.text;
                                    final Relation =
                                        _relativeRelationController.text;
                                    final VisitDur = durationController.text;
                                    final roomInfo = studentData['roomref'];

                                    final Studphone =
                                        studentData['phoneNumber'];
                                    final visitordata = {
                                      'studentId': studentData['PNUID'],
                                      'fullName': fullName,
                                      'visitorName': Visitorname,
                                      'nationalId': NationalId,
                                      'relativeRelation': Relation,
                                      'time': selectedTime!.format(context),
                                      'date': selectedDate!
                                          .toString()
                                          .split(' ')[0],
                                      'status': 'pending',
                                      'phoneNumber': Studphone,
                                      'visitingDuration': VisitDur,
                                      'roomInfo': roomInfo,
                                      'studentInfo': studentDocRef,
                                    };

                                    try {
                                      final snapshot = await firestore
                                          .collection('VisitorRequest')
                                          .where('studentId',
                                              isEqualTo: studentData['PNUID'])
                                          .where('status', isEqualTo: 'pending')
                                          .get();

                                      if (snapshot.docs.isNotEmpty &&
                                          snapshot.docs[0]['status'] ==
                                              'pending') {
                                        // There's a pending request, prevent submission
                                        ErrorDialog(
                                            "You have a pending visitor request. Please wait for it to be processed before submitting another.",
                                            context,
                                            buttons: [
                                              {"OK": () async => {context.pop(),context.pop()}}
                                            ]);
                                      } else {
                                        // No pending request, submit the new one
                                        await visitorReqDocRef.set(visitordata);

                                        await studentDocRef.update({
                                          'VisitorRequest': visitorReqDocRef
                                        });
                                        print('Data added successfully!');
                                        InfoDialog(
                                            "Your request has been\nsubmitted successfully",
                                            context,
                                            buttons: [
                                              {"OK": () async =>{context.pop(),context.pop()}}
                                            ]);

                                        setState(() {
                                          _canSubmitRequest = false;
                                        });
                                      }
                                    } catch (e) {
                                      ErrorDialog(
                                        'Error adding data',
                                        context,
                                        buttons: [
                                          {
                                            "Ok": () => context.pop(),
                                          },
                                        ],
                                      );
                                      print('Error adding data: $e');
                                    }
                                  } else {
                                    ErrorDialog(
                                      'Student Data not found',
                                      context,
                                      buttons: [
                                        {
                                          "Ok": () => context.pop(),
                                        },
                                      ],
                                    );
                                  }
                                }
                              }
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class HousingVacate extends StatefulWidget {
  const HousingVacate({super.key});

  @override
  State<HousingVacate> createState() => _HousingVacateState();
}

class _HousingVacateState extends State<HousingVacate> {
  String? selectedReason;
  String? otherReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Request to vacate housing",
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Heightsizedbox(h: 0.015),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Titletext(
                t: "Reason for vacating",
                align: TextAlign.start,
                color: dark1,
              ),
            ),
            RadioListTile<String>(
              title: text(
                t: 'I graduated from PNU university',
                color: dark1,
                align: TextAlign.start,
              ),
              value: 'Graduated from PNU',
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                  otherReason = null;
                  print('Selected reason: $selectedReason');
                });
              },
            ),
            RadioListTile<String>(
              title: text(
                t: 'I withdrew from a semester at university',
                align: TextAlign.start,
                color: dark1,
              ),
              value: 'Withdrew from a semester',
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                  otherReason = null;
                  print('Selected reason: $selectedReason');
                });
              },
            ),
            RadioListTile<String>(
              title: text(
                t: 'I withdrew from university',
                color: dark1,
                align: TextAlign.start,
              ),
              value: 'Withdrew from university',
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                  otherReason = null;
                  print('Selected reason: $selectedReason');
                });
              },
            ),
            RadioListTile<String>(
              title: text(
                t: 'Others',
                align: TextAlign.start,
                color: dark1,
              ),
              value: 'Others',
              groupValue: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                  print('Selected reason: $selectedReason');
                });
              },
            ),
            if (selectedReason == 'Others')
              Padding(
                padding: const EdgeInsets.fromLTRB(29, 10, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Please specify the reason:',
                  ),
                  onChanged: (value) {
                    setState(() {
                      otherReason = value;
                      print('Other reason: $otherReason');
                    });
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.bottomRight,
                child: actionbutton(
                  background: dark1,
                  text: 'Submit Request',
                  onPressed: () async {
                    print('Submit button pressed');
                    if (selectedReason == null) {
                      print('No reason selected');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a reason for vacating.'),
                        ),
                      );
                      return;
                    }
                    if (selectedReason == 'Others' && otherReason == null) {
                      print('Other reason not specified');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please specify the reason for vacating.'),
                        ),
                      );
                      return;
                    }

                    final currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;
                    print('Current user ID: $currentUserId');

                    final DocumentReference studentDocRef = FirebaseFirestore
                        .instance
                        .collection('student')
                        .doc(currentUserId);
                    DocumentReference housingDocRef = FirebaseFirestore.instance
                        .collection('VacateHousing')
                        .doc();
                    final vacateData = {
                      'reason': selectedReason == 'Others'
                          ? otherReason
                          : selectedReason,
                      'status': 'Pending',
                      'studentInfo': studentDocRef,
                    };

                    print('Vacate data: $vacateData');

                    try {
                      await housingDocRef.set(vacateData);
                      print('Vacate request added to VacateHousing collection');

                      await studentDocRef
                          .update({'VacateHousing': housingDocRef});
                      print(
                          'Vacate request reference added to student document');

                      InfoDialog(
                          "Your vacate request has been\nsubmitted successfully",
                          context,
                          buttons: [
                            {
                              "OK": () async => {context.pop(), context.pop()}
                            }
                          ]);
                    } catch (e) {
                      ErrorDialog("Error adding data: $e", context, buttons: [
                        {"OK": () async => context.pop()},
                      ]);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

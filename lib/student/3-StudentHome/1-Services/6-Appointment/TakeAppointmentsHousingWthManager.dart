import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class TakeAppointmentsHousingWthManager extends StatefulWidget {
  @override
  TakeAppointmentsHousingWthManagerState createState() =>
      TakeAppointmentsHousingWthManagerState();
}

class TakeAppointmentsHousingWthManagerState
    extends State<TakeAppointmentsHousingWthManager> {
  final CollectionReference appdata =
  FirebaseFirestore.instance.collection("Appointments");
  final reasons = TextEditingController();

  late String docId;
  late DocumentReference studentDocRef;

  DateTime? selectedDate;
  String? selectedTime; // Updated variable to store selected time

  @override
  void initState() {
    super.initState();
    docId = FirebaseAuth.instance.currentUser!.uid;
    studentDocRef = FirebaseFirestore.instance.collection('student').doc(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OurAppBar(
        title: 'Housing Manager',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Titletext(
                      t: 'Date:',
                      align: TextAlign.start,
                      color: dark1,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: grey2,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, bottom: 10),
                        child: text(
                          t: selectedDate == null ?'Select Date' :'${selectedDate!.toLocal()}'.split(' ')[0],
                          color: light1,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (newDate != null && newDate != selectedDate) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      }
                    },
                  ),
                ),
                Heightsizedbox(h: 0.02),
                Row(
                  children: [
                    Titletext(
                      t: 'Select Time:',
                      align: TextAlign.start,
                      color: dark1,
                    ),
                  ],
                ),
                Heightsizedbox(h: 0.01),
                StreamBuilder<QuerySnapshot>(
                  stream: appdata
                      .where('Date',
                      isEqualTo: selectedDate.toString().split(' ')[0])
                      .where('type', isEqualTo: 'manager')
                      .where('Status', isEqualTo: 'available')
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (streamSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${streamSnapshot.error}'));
                    } else if (!streamSnapshot.hasData ||
                        streamSnapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('No appointments found for this date.'));
                    } else {
                      return SingleChildScrollView(
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(
                            streamSnapshot.data!.docs.length,
                                (index) {
                              final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                              final time = documentSnapshot['Time'];
                              final isSelected = selectedTime == time;

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? light1
                                        : dark1,
                                    side: isSelected
                                        ? BorderSide(
                                        color: Colors.white, width: 2)
                                        : BorderSide.none,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  },
                                  child: Dtext(
                                    t: time,
                                    align: TextAlign.center,
                                    color: Colors.white,
                                    size: 0.04,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (selectedTime != null) // Display selected time
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Dtext(
                      t: 'Selected Time: $selectedTime',
                      color: Color(0xff003F46),
                      size: 0.05,
                      align: TextAlign.center,
                    ),
                  ),
                Heightsizedbox(h: 0.03),
                Row(
                  children: [
                    Titletext(
                      t: 'Reason:',
                      color: dark1,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                textform(
                  controller: reasons,
                  hinttext: "Appointment Reason",
                  lines: 5,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please write an appointment reason";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.04),
                actionbutton(
                  onPressed: () async {
                    if (selectedTime != null && reasons.text.isNotEmpty) {
                      try {
                        QuerySnapshot querySnapshot = await appdata
                            .where('Date',
                            isEqualTo:
                            selectedDate.toString().split(' ')[0])
                            .where('Time', isEqualTo: selectedTime)
                            .where('type', isEqualTo: 'manager')
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          DocumentReference appointmentDocRef =
                              querySnapshot.docs.first.reference;

                          await appointmentDocRef.update({
                            'Status': "Reserved",
                            'Reason': reasons.text,
                            'studentInfo': studentDocRef,
                          });
                          InfoDialog(
                            "Appointment Reserved successfully",
                            context,
                            buttons: [
                              {
                                "OK": () async => context.pop(),
                              },

                            ],
                          );
                          reasons.clear();
                          setState(() {
                            selectedDate = null;
                            selectedTime = null;
                          });
                        } else {
                          ErrorDialog(
                            'No matching appointment found.',
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
                          'Error updating appointment: $e.',
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
                        'Please select a time and enter a reason',
                        context,
                        buttons: [
                          {
                            "Ok": () => context.pop(),
                          },
                        ],
                      );
                    }
                  },
                  text: 'Save',
                  background: dark1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

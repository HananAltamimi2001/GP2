import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class TakeAppointmentWthSocialSpecialist extends StatefulWidget {
  @override
  TakeAppointmentWthSocialSpecialistState createState() => TakeAppointmentWthSocialSpecialistState();
}

class TakeAppointmentWthSocialSpecialistState extends State<TakeAppointmentWthSocialSpecialist> {
  final CollectionReference appdata =
  FirebaseFirestore.instance.collection("Appointments");
  final reasons = TextEditingController();

  late String docId;
  late DocumentReference studentDocRef;

  DateTime? selectedDate ;
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
        title: 'Social Specialist',
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
                      .where('Date', isEqualTo: selectedDate.toString().split(' ')[0])
                      .where('type', isEqualTo: 'Social Specialist')
                      .where('Status', isEqualTo: 'available')
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (streamSnapshot.hasError) {
                      return Center(child: Text('Error: ${streamSnapshot.error}'));
                    } else if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No available specialists for this date.'));
                    } else {
                      // Group appointments by specialist name
                      Map<String, List<DocumentSnapshot>> groupedAppointments = {};
                      for (var doc in streamSnapshot.data!.docs) {
                        final name = doc['name']; // Ensure this field exists in Firestore
                        if (!groupedAppointments.containsKey(name)) {
                          groupedAppointments[name] = [];
                        }
                        groupedAppointments[name]!.add(doc);
                      }

                      // Display each specialist with their available times
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Ensure titles align left
                        children: groupedAppointments.entries.map((entry) {
                          String specialistName = entry.key;
                          List<DocumentSnapshot> appointments = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                t: specialistName,
                                color: light1,
                                align: TextAlign.start,
                              ),
                              Heightsizedbox(h: 0.01),
                              Row( // Ensure appointments align from the start
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 10.0,
                                    runSpacing: 10.0,
                                    children: appointments.map((doc) {
                                      final time = doc['Time'];
                                      final isSelected = selectedTime == time;

                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isSelected ? light1 : dark1,
                                            side: isSelected ? BorderSide(color: Colors.white, width: 2) : BorderSide.none,
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
                                    }).toList(),
                                  ),
                                ],
                              ),
                              Heightsizedbox(h: 0.02), // Spacing between specialists
                            ],
                          );
                        }).toList(),
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
                            .where('type', isEqualTo: 'Social Specialist')
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

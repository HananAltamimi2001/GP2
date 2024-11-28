import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:intl/intl.dart';

class OvernightRequest extends StatefulWidget {
  const OvernightRequest({super.key});

  @override
  State<OvernightRequest> createState() => _OvernightRequestState();
}

class _OvernightRequestState extends State<OvernightRequest> {
  DateTime? ArrselectedDate;
  DateTime? DepselectedDate;
  TimeOfDay? DepselectedTime;
  TimeOfDay? ArrselectedTime;

  bool? studentChecked = false;
  bool? absenceChecked = false;

  bool validateCheckboxes() {
    return studentChecked == true && absenceChecked == true;
  }

  bool _canSubmitRequest = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //*****App bar and the title******
      appBar: OurAppBar(
        title: "Overnight Request",
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Heightsizedbox(h: 0.025),

              text(
                t: "Fill the required information",
                color: green1,
                align: TextAlign.center,
              ),
              Heightsizedbox(
                h: 0.030,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Dtext(
                        t: "Arrival Date:",
                        align: TextAlign.center,
                        color: dark1,
                        size: 0.04,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: Dtext(
                        t: "Departure Date:",
                        align: TextAlign.center,
                        color: dark1,
                        size: 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  children: [
                    OurFormField(
                      fieldType: 'date',
                      selectedDate: ArrselectedDate,
                      onSelectDate: () async {
                        final DateTime? pickedDate = await pickDate(
                            context); // the pickDate(context) it`s the function in the bellow (19 in this Design file)
                        if (pickDate != null) {
                          setState(() {
                            ArrselectedDate =
                                pickedDate; // Update the selected date
                          });
                        }
                      },
                      labelText:
                          "", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                    const Spacer(),
                    //***********Departure Date***********
                    OurFormField(
                      fieldType: 'date',
                      selectedDate: DepselectedDate,
                      onSelectDate: () async {
                        final DateTime? pickedDate = await pickDate(
                            context); // the pickDate(context) it`s the function in the bellow (19 in this Design file)
                        if (pickDate != null) {
                          setState(() {
                            DepselectedDate =
                                pickedDate; // Update the selected date
                          });
                        }
                      },
                      labelText:
                          "", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                  ],
                ),
              ),
              const Heightsizedbox(
                h: 0.02,
              ),
              //***********Departure Arrival text*************
              const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Dtext(
                      t: "Arrival Time:",
                      color: Color(0xff007580),
                      size: 0.04,
                      align: TextAlign.start,
                    ),
                    Spacer(),
                    Dtext(
                      t: "Departure Time:",
                      align: TextAlign.start,
                      size: 0.04,
                      color: Color(0xff007580),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Row(
                  children: [
                    OurFormField(
                      fieldType: 'time',
                      selectedTime: ArrselectedTime,
                      onSelectTime: () async {
                        final TimeOfDay? pickedTime = await pickTime(
                            context); // the pickTime(context) it`s the function in the bellow (18 in this Design file)
                        if (pickedTime != null) {
                          setState(() {
                            ArrselectedTime =
                                pickedTime; // Update the selected time
                          });
                        }
                      },
                      labelText:
                          "", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                    const Spacer(),
                    OurFormField(
                      fieldType: 'time',
                      selectedTime: DepselectedTime,
                      onSelectTime: () async {
                        final TimeOfDay? pickedTime = await pickTime(
                            context); // the pickTime(context) it`s the function in the bellow (18 in this Design file)
                        if (pickedTime != null) {
                          setState(() {
                            DepselectedTime =
                                pickedTime; // Update the selected time
                          });
                        }
                      },
                      labelText:
                          "", // if you don`t need labelText make it  empty : labelText: "",
                    ),
                  ],
                ),
              ),

              //building number

              const Heightsizedbox(
                h: 0.045,
              ),
              Column(
                //*******************student pledge checkbox*****************
                children: [
                  CheckboxListTile(
                    value: studentChecked,
                    title: const Dtext(
                      t: "I, the student whose information is shown above, one of the beneficiaries of university housing, pledge that the information provided is correct. \n In the event that it is incorrect, the regulations and system in place at the university and univerty housing will be applied to me.",
                      align: TextAlign.start,
                      color: Color(0xFF007580),
                      size: 0.0335,
                    ),
                    onChanged: (studentBool) {
                      setState(() {
                        studentChecked = studentBool;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF007580),
                  ),
                  //*****************absence checkbox*********************
                  CheckboxListTile(
                    value: absenceChecked,
                    title: const Dtext(
                      t: "If my absence exceeds seven days, a document supporting this will be submitted to the Housing Administration at dsa-doff-sh@pnu.edu.sa",
                      align: TextAlign.start,
                      color: Color(0xFF007580),
                      size: 0.0335,
                    ),
                    onChanged: (absenceBool) {
                      setState(() {
                        absenceChecked = absenceBool;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF007580),
                  ),
                ],
              ),
              Heightsizedbox(h: 0.02),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: actionbutton(
                    text: "Submit Request",
                    background: dark1,
                    onPressed: _canSubmitRequest
                        ? () async {
                            if (validateCheckboxes()) {
                              if(ArrselectedDate!.isBefore(DepselectedDate!)){
                              final firestore = FirebaseFirestore.instance;
                              final String currentUserId =
                                  await FirebaseAuth.instance.currentUser!.uid;

                              final studentDoc = await firestore
                                  .collection('student')
                                  .doc(currentUserId)
                                  .get();
                              final studentData = studentDoc.data();

                              final DocumentReference studentDocRef =
                                  FirebaseFirestore.instance
                                      .collection('student')
                                      .doc(currentUserId);

                              DocumentReference overnightReqDocRef =
                                  FirebaseFirestore.instance
                                      .collection('OvernightRequest')
                                      .doc();

                              if (studentData != null) {
                                final String fullName =
                                    studentData['firstName'] +
                                        ' ' +
                                        studentData['lastName'];

                                final roomInfo = studentData['roomref'];
                                final Studphone = studentData['phoneNumber'];

                                final overnightdata = {
                                  'studentId': studentData['PNUID'],
                                  'departureDate':
                                      DepselectedDate!.toString().split(' ')[0],
                                  'arrivalDate':
                                      ArrselectedDate!.toString().split(' ')[0],
                                  'departureTime':
                                      DepselectedTime!.format(context),
                                  'arrivalTime':
                                      ArrselectedTime!.format(context),
                                  'status': 'pending',
                                  'fullName': fullName,
                                  'roomInfo': roomInfo,
                                  'phoneNumber': Studphone,
                                  'studentInfo': studentDocRef,
                                };

                                try {
                                  final snapshot = await firestore
                                      .collection('OvernightRequest')
                                      .where('studentId',
                                          isEqualTo: studentData['PNUID'])
                                      .where('status', isEqualTo: 'pending')
                                      .get();
                                  if (snapshot.docs.isNotEmpty &&
                                      snapshot.docs[0]['status'] == 'pending') {
                                    // There's a pending request, prevent submission
                                    ErrorDialog(
                                        "You have a pending overnight request. Please wait for it to be processed before submitting another.",
                                        context,
                                        buttons: [
                                          {"OK": () async => context.pop()}
                                        ]);
                                  } else {
                                    // No pending request, submit the new one
                                    await overnightReqDocRef.set(overnightdata);
                                    await studentDocRef.update({
                                      'OvernightRequest': overnightReqDocRef
                                    });

                                    print('Data added successfully!');
                                    InfoDialog(
                                        "Your request has been\nsubmitted successfully",
                                        context,
                                        buttons: [
                                          {"OK": () async => {context.pop(),context.pop()}}
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
                            }else{
                               ErrorDialog(
                                  'Arrival Date can not be after Departure Date',
                                  context,
                                  buttons: [
                                    {
                                      "Ok": () => context.pop(),
                                    },]);
                            }}
                          }
                        : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



void compareDates(String date1, String date2) {
  DateFormat format = DateFormat("dd/MM/yyyy");
  DateTime parsedDate1 = format.parse(date1);
  DateTime parsedDate2 = format.parse(date2);

  if (parsedDate1.isBefore(parsedDate2)) {
    print("$date1 is before $date2");
  } else if (parsedDate1.isAfter(parsedDate2)) {
    print("$date1 is after $date2");
  } else {
    print("$date1 is the same as $date2");
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class OvernightRequest extends StatefulWidget {
  const OvernightRequest({super.key});

  @override
  State<OvernightRequest> createState() => _OvernightRequestState();
}

final TextEditingController buildingController = TextEditingController();
final TextEditingController floorController = TextEditingController();
final TextEditingController residentUnitNoController = TextEditingController();

class _OvernightRequestState extends State<OvernightRequest> {
  DateTime? ArrselectedDate;
  DateTime? DepselectedDate;
  TimeOfDay? DepselectedTime;
  TimeOfDay? ArrselectedTime;

  bool? studentChecked = false;
  bool? absenceChecked = false;

  final formKey = GlobalKey<FormState>();

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
              text(
                t: "Fill the required information",
                color: green1,
                align: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Dtext(
                        t: "Departure Date:",
                        align: TextAlign.center,
                        color: dark1,
                        size: 0.04,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: Dtext(
                        t: "Arrival Date:",
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
                      t: "Departure Time:",
                      color: Color(0xff007580),
                      size: 0.04,
                      align: TextAlign.start,
                    ),
                    Spacer(),
                    Dtext(
                      t: "Arrival Time:",
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
                    const Spacer(),
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
                  ],
                ),
              ),
              Heightsizedbox(
                h: 0.020,
              ),
              //building number
              Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.27,
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: textform(
                            controller: buildingController,
                            hinttext: "Building",
                            lines: 1,
                            validator: (val) => val == ""
                                ? "Please write the Building Number"
                                : val!.contains(RegExp(r'[^\d]'))
                                    ? "Can only contain numbers"
                                    : null,
                          )),
                    ),
                    // floor number
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.27,
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: textform(
                            lines: 1,
                            hinttext: "Floor",
                            controller: floorController,
                            validator: (val) => val == ""
                                ? "Please write the Floor Number"
                                : val!.contains(RegExp(r'[^\d]'))
                                    ? "Can only contain numbers"
                                    : null,
                          )),
                    ),
                    // for resident unit
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.27,
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: textform(
                            hinttext: "Unit",
                            lines: 1,
                            controller: residentUnitNoController,
                            validator: (val) => val == ""
                                ? "Please write the Unit Number"
                                : val!.contains(RegExp(r'[^\d]'))
                                    ? "Can only contain numbers"
                                    : null,
                          )),
                    ),
                  ],
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: actionbutton(
                    text: "Submit Request",
                    background: dark1,
                    onPressed: _canSubmitRequest
                        ? () async {
                            if (validateCheckboxes() &&
                                formKey.currentState!.validate()) {
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
                                    studentData['efirstName'] +
                                        ' ' +
                                        studentData['elastName'];

                                final BuildNum = buildingController.text;
                                final FloorNum = floorController.text;
                                final ResUnit = residentUnitNoController.text;
                                final Studphone = studentData['phoneNumber'];

                                final overnightdata = {
                                  'studentId': studentData['PNUID'],
                                  'departureDate': DateFormat('yyyy-MM-dd')
                                      .format(DepselectedDate!)
                                      .toString(),
                                  'arrivalDate': DateFormat('yyyy-MM-dd')
                                      .format(ArrselectedDate!)
                                      .toString(),
                                  'departureTime':
                                      DepselectedTime!.format(context),
                                  'arrivalTime':
                                      ArrselectedTime!.format(context),
                                  'status': 'pending',
                                  'fullName': fullName,
                                  'buildingNumber': BuildNum,
                                  'floorNumber': FloorNum,
                                  'residentialUnitNumber': ResUnit,
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
                                    InfoDialog(
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
                                          {"OK": () async => context.pop()}
                                        ]);

                                    setState(() {
                                      _canSubmitRequest = false;
                                    });
                                  }
                                } catch (e) {
                                  print('Error adding data: $e');
                                }
                              } else {
                                print('Student Data not found');
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
      ),
    );
  }
}

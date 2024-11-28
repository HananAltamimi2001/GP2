import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class VacateRequestView extends StatefulWidget {
  final requestid args;

  const VacateRequestView({super.key, required this.args});

  @override
  State<VacateRequestView> createState() => _VacateRequestViewState();
}

class _VacateRequestViewState extends State<VacateRequestView> {
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  final formKey = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? getRequest;
  @override
  void initState() {
    super.initState();
    print("initState called"); // Check if initState runs
    getRequest = getRequesttAndStudentInfo();
  }

  Future<Map<String, dynamic>>? getRequesttAndStudentInfo() async {
    try {
      print("Fetching request data for ID: ${widget.args.requestId}");

      // Fetch request data
      DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('VacateHousing')
          .doc(widget.args.requestId)
          .get();

      if (!requestSnapshot.exists) {
        print("Request document not found.");
        throw Exception("Request not found");
      }

      var data = requestSnapshot.data() as Map<String, dynamic>;
      DocumentReference studentInfoRef = data['studentInfo'];
      DocumentReference requestDocRef = requestSnapshot.reference;

      print("Request data: $data");

      // Fetch student data
      DocumentSnapshot studentSnapshot = await studentInfoRef.get();
      String fullName = studentSnapshot['fullName'] ?? 'N/A';
      String efullName = studentSnapshot['efullName'] ?? 'N/A';
      String PNUID = studentSnapshot['PNUID'] ?? 'N/A';
      String email = studentSnapshot['email'] ?? 'N/A';

      print("Student data - Full Name: $fullName, PNUID: $PNUID");

      // Fetch room data if available
      DocumentReference? roomRef = studentSnapshot['roomref'] ?? null;
      String roomId = roomRef != null ? roomRef.id : 'N/A';

      print("Room ID: $roomId");

      return {
        'roomId': roomId,
        'request': data,
        'fullName': fullName,
        'efullName': efullName,
        'PNUID': PNUID,
        'email': email,
        'studentref': studentInfoRef,
        'requestref': requestDocRef,
        'roomref': roomRef,
      };
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception("Error fetching data: $e");
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
                  return Center(
                      child: text(
                    t: "Error: ${snapshot.error}",
                    align: TextAlign.center,
                    color: grey1,
                  ));
                }

                final data = snapshot.data!;
                final requestData = data['request'];

                return WillPopScope(
                  onWillPop: () async {
                    if (selectedDate != null &&
                        selectedTime != null &&
                        requestData['status'] == 'Pending') {
                      ErrorDialog(
                        "This student is not assigned to a room",
                        context,
                        buttons: [
                          {'Ok': () => context.pop()}
                        ],
                      );
                      return false;
                    } else {
                      return true;
                    }
                  },
                  child: Column(
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
                          t: data['efullName'],
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
                          t: data['PNUID'],
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
                        t: "Reason for vacating:",
                        align: TextAlign.center,
                        color: dark1,
                      ),
                      OurContainer(
                        child: Dtext(
                          t: requestData['reason'],
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
                      // Student UID
                      Row(
                        children: [
                          text(
                            t: "Room no: ",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          actionbutton(
                            onPressed: () {
                              context.pushNamed('/roomDetailes1',
                                  extra: data['roomId']);
                            },
                            text: data['roomId'],
                            background: dark1,
                            padding: 5,
                          ),
                        ],
                      ),
                      Heightsizedbox(h: 0.018),
                      Visibility(
                        visible: requestData['status'] == 'Pending',
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              text(
                                t: "Set Time and Date for Room Inspection",
                                color: dark1,
                                align: TextAlign.center,
                              ),
                              Heightsizedbox(h: 0.01),
                              Column(
                                children: [
                                  OurFormField(
                                    fieldType: 'time',
                                    selectedTime: selectedTime,
                                    onSelectTime: () async {
                                      final TimeOfDay? pickedTime =
                                          await pickTime(context);
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedTime =
                                              pickedTime; // Update the selected time
                                        });
                                      }
                                      return null;
                                    },
                                    labelText: "Select Time:",
                                  ),
                                  OurFormField(
                                    fieldType: 'date',
                                    selectedDate: selectedDate,
                                    onSelectDate: () async {
                                      final DateTime? pickedDate =
                                          await pickDate(context);
                                      if (pickedDate != null) {
                                        setState(() {
                                          selectedDate =
                                              pickedDate; // Update the selected date
                                        });
                                      }
                                      return null;
                                    },
                                    labelText: "Select Date:",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Visibility(
                              visible: requestData['status'] == 'Pending',
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: actionbutton(
                                  text: "Send",
                                  fontsize: 0.04,
                                  background: dark1,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      DocumentReference requestRef =
                                          data["requestref"];
                                      requestRef.update({
                                        'time': selectedTime!.format(context),
                                        'date': DateFormat('yyyy-MM-dd')
                                            .format(selectedDate!)
                                            .toString(),
                                        'status': 'Sent'
                                      });
                                      // Create an instance of your Firestore mail collection
                                      await FirebaseFirestore.instance
                                          .collection('mail')
                                          .add({
                                        'to': data['email'],
                                        'message': {
                                          'subject': 'Vacate Request|طلب إخلاء',
                                          'html': """
                                          <html>
                                          <body>
                                          <p style="color: #339199; font-size: 20px;>Dear ${data['efullName']},</p>
                                          <p style="color: #339199; font-size: 20px;text-align: right;">عزيزتي الطالبة ${data['fullName']},</p>
                                          <p>We have received your request to vacate your Room. Please make sure to clear the room of all personal belongings.</p>
                                          <p style="text-align: right;">لقد تلقينا طلبك بإخلاء غرفتك. يرجى التأكد من إخلاء الغرفة من جميع المتعلقات الشخصية.</p>
                                          <p>Best regards,</p>
                                          <p>Resident Students affairs,</p>
                                          <p style="text-align: right;">،أطيب التحيات</p>
                                          <p style="text-align: right;">شوؤن طالبات السكن</p>
                                          </body>
                                          </html>
                                           """,
                                        },
                                      });
                                      print('sended email');

                                      try {
                                        print('Data added successfully!');
                                        InfoDialog(
                                          "Time and date for room inspection has been sent successfully",
                                          context,
                                          buttons: [
                                            {
                                              "OK": () async => {
                                                    context.pop(),
                                                    setState(() {
                                                      getRequest =
                                                          getRequesttAndStudentInfo();
                                                    }),
                                                  }
                                            }
                                          ],
                                        );
                                      } catch (e) {
                                        ErrorDialog(
                                          "Error occurred while updating request status",
                                          context,
                                          buttons: [
                                            {
                                              "OK": () async => {
                                                    context.pop(),
                                                    setState(() {
                                                      getRequest =
                                                          getRequesttAndStudentInfo();
                                                    })
                                                  }
                                            }
                                          ],
                                        );
                                        print('Error adding data: $e');
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Visibility(
                              visible: requestData['status'] == 'Sent',
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: actionbutton(
                                  background: dark1,
                                  text: "Complete",
                                  fontsize: 0.04,
                                  onPressed: () async {
                                    DocumentReference requestRef =
                                        data["requestref"];
                                    requestRef.update({'status': 'Completed'});

                                    DocumentReference studentRef =
                                        data["studentref"];
                                    studentRef.update({
                                      //   'resident': false,//after last checkout then flse
                                      "checkStatus": 'Last Check-out',
                                      //  "VacateHousing": FieldValue.delete(),
                                    });

                                    try {
                                      print('Data added successfully!');
                                      InfoDialog(
                                        "Vacating has been completed successfully",
                                        context,
                                        buttons: [
                                          {
                                            "OK": () async => {
                                                  context.pop(),
                                                  setState(() {
                                                    getRequest =
                                                        getRequesttAndStudentInfo();
                                                  })
                                                }
                                          }
                                        ],
                                      );
                                    } catch (e) {
                                      ErrorDialog(
                                        "Error occurred while updating request status",
                                        context,
                                        buttons: [
                                          {
                                            "OK": () async => {
                                                  context.pop(),
                                                  setState(() {
                                                    getRequest =
                                                        getRequesttAndStudentInfo();
                                                  })
                                                }
                                          }
                                        ],
                                      );
                                      print('Error adding data: $e');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

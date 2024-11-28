import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/1-List.dart';

class ApplicationRequestView extends StatefulWidget {
  final requestid args;
  const ApplicationRequestView({super.key, required this.args});

  @override
  State<ApplicationRequestView> createState() => _ApplicationRequestViewState();
}

class _ApplicationRequestViewState extends State<ApplicationRequestView> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late String fullname;
  late String efullname;
  late String roomId;
  late String email;
  final formKey = GlobalKey<FormState>();
  Future<Map<String, dynamic>>? getRequest;

  @override
  void initState() {
    super.initState();
    getRequest = getRequestAndStudentInfo();
  }

  //get application data
  Future<Map<String, dynamic>> getRequestAndStudentInfo() async {
    // fetch request data
    DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('HousingApplication')
        .doc(widget.args.requestId)
        .get();

    if (!requestSnapshot.exists) {
      throw Exception("Request not found");
    }

    var data = requestSnapshot.data() as Map<String, dynamic>;
    DocumentReference studentInfoRef = data['studentInfo'];
    DocumentReference requestDocRef = requestSnapshot.reference;

    // Fetch the student data
    DocumentSnapshot studentSnapshot = await studentInfoRef.get();
    String email = studentSnapshot['email'] ?? 'N/A';
    String PNUID = studentSnapshot['PNUID'] ?? 'N/A';

    // Return both the request details and student data
    return {
      'request': data,
      'email': email,
      'PNUID': PNUID,
      'studentref': studentInfoRef,
      'requestref': requestDocRef,
    };
  }

  Future<void> updateRequestStatus(
      DocumentReference requestId, String status, var rooreff) async {
    try {
      bool updated = false;
      print(
          "Attempting to update request with ID: ${requestId.id}"); // Print the document ID
      print("Status to be updated: $status");

      if (status == 'Initial Accept') {
        print("Updating status to 'Initial Accept' with additional fields.");

        await requestId.update({
          'status': status,
          'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
          'time': selectedTime!.format(context),
        });

        // Create an instance of your Firestore mail collection
        await FirebaseFirestore.instance.collection('mail').add({
          'to': email,
          'message': {
            'subject': 'Application Request|طلب سكن',
            'html': """
        <html>
        <body>
        <p style="color: #339199; font-size: 20px;>Dear $efullname,</p>
        <p style="color: #339199; font-size: 20px;text-align: right;">عزيزتي الطالبة $fullname,</p>

        <p style="font-size: 16px;">We are pleased to inform you that your housing application has been initially accepted. Congratulations! Your application is under review, and we would like to schedule a meeting through teams</p>
        <p style="font-size: 16px;text-align: right;">نحن سعداء بإبلاغك بأنه تم قبول طلب السكن بشكل مبدئي. تهانينا! طلبك قيد المراجعة، ونرغب في تحديد موعد للاجتماع معك خلاص تطبيق تيمز .</p>

        <p style="font-size: 16px;">Please be informed that the meeting is scheduled for:</p>
        <p style="font-size: 16px;">Date: $selectedDate</p>
        <p style="font-size: 16px;">Time: $selectedTime</p>

        <p style="font-size: 16px;text-align: right;">يرجى العلم أن الاجتماع مقرر في:</p>
        <p style="font-size: 16px;text-align: right;">$selectedDate:التاريخ</p>
        <p style="font-size: 16px;text-align: right;">$selectedTime:الوقت</p>

        <p style="font-size: 16px;">We look forward to meeting with you!</p>
        <p style="font-size: 16px;">Resident Student Affairs</p>
        <p>Best regards,</p>
        <p>Resident Students affairs,</p>
        <p style="text-align: right;>مع أطيب التحيات،</p>
        <p style="text-align: right;">شوؤن طالبات السكن</p>
        </body>
        </html>
        """,
          },
        });
        updated = true;
        print("Update successful for status 'Initial Accept'");
      } else if (status == 'Final Accept' && rooreff is DocumentReference) {
        await requestId.update({
          'status': status,
        });
        updated = true;
        print("updattttttttteee");
        moveDataAndUpdate(requestId);
        // Create an instance of your Firestore mail collection
        await FirebaseFirestore.instance.collection('mail').add({
          'to': email,
          'message': {
            'subject': 'Application Request|طلب سكن',
            'html': """
        <html>
        <body>
        <p style="color: #339199; font-size: 20px;>Dear $efullname,</p>
        <p style="color: #339199; font-size: 20px;text-align: right;">عزيزتي الطالبة $fullname,</p>
        <p dir="rtl" style="font-size: 16px;text-align: right;">يسعدنا أن نعلمكم بأنه قد تم **قبول طلب السكن** الخاص بك نهائيًا.</p>
        <p style="font-size: 16px;">We are pleased to inform you that your housing application has been **finally accepted**.</p>
        <p dir="rtl" style="font-size: 16px;">هذا هو رقم غرفتك $roomId</p>

        <p style="font-size: 16px;">Here is your Room number $roomId</p>
        <p style="font-size: 16px;text-align: right;">نتمنى لك الأفضل في رحلتك نحو المستقبل والراحة في منزلك الثاني</p>

        <p style="font-size: 16px;">Wishing you the best on your journey as you settle into your second home.</p>
        <p>Best regards,</p>
        <p>Resident Students affairs,</p>
        <p style="text-align: right; >مع أطيب التحيات،</p>
        <p style="text-align: right;">شوؤن طالبات السكن</p>
          </body>
        </html>
        """,
          },
        });
        updated = true;
      } else if (status == 'Reject' && rooreff is DocumentReference) {
        await requestId.update({
          'status': status,
        });
        updated = true;
      }
      // Optional: If there are other conditions, you can add similar print statements here.
      if (updated) {
        await InfoDialog(
          "Request status $status updated successfully",
          context,
          buttons: [
            {
              "Ok": () => {context.pop(), setState(() {})}
            }
          ],
        );
        setState(() {
          getRequest = getRequestAndStudentInfo();
        }); // Refresh the page
        print("Dialog shown: Request status updated successfully.");
      }
    } catch (e) {
      print("Error occurred while updating request status: $e");

      ErrorDialog(
        "Failed to update request status $status, please try again later",
        context,
        buttons: [
          {
            "Ok": () => {
                  context.pop(),
                }
          }
        ],
      );
    }
  }

  Future<void> moveDataAndUpdate(DocumentReference AppRef) async {
    try {
      print("Starting data transfer from AppRef: ${AppRef.path}");

      // Step 1: Fetch data from AppRef
      DocumentSnapshot AppSnapshot = await AppRef.get();
      print("Fetched AppSnapshot for AppRef: ${AppRef.path}");

      if (AppSnapshot.exists) {
        print("AppRef document exists, retrieving data...");

        // Retrieve data from AppRef
        Map<String, dynamic> AppDoc =
            AppSnapshot.data() as Map<String, dynamic>;
        print("Data retrieved from AppRef: $AppDoc");
        DocumentReference RoomRef = AppDoc['roomref'];

        final MovedData = {
          'roomref': AppDoc['roomref'],
          'fullName': AppDoc['fullName'],
          'firstName': AppDoc['firstName'],
          'middleName': AppDoc['middleName'],
          'lastName': AppDoc['lastName'],
          'efullName': AppDoc['efullName'],
          'efirstName': AppDoc['efirstName'],
          'emiddleName': AppDoc['emiddleName'],
          'elastName': AppDoc['elastName'],
          'bloodType': AppDoc['bloodType'],
          'DoB': AppDoc['DoB'],
          'degree': AppDoc['degree'],
          'college': AppDoc['college'],
          'NID': AppDoc['NID'],
          'nationality': AppDoc['nationality'],
          'phoneNumber': AppDoc['phoneNumber'],
          'e1phoneNumber': AppDoc['e1phoneNumber'],
          'e2phoneNumber': AppDoc['e2phoneNumber'],
          'e1email': AppDoc['e1email'],
          'e2email': AppDoc['e2email'],
          'city': AppDoc['city'],
          'nationalAdd': AppDoc['nationalAdd'],
          'zipCode': AppDoc['zipCode'],
          'nationalIdUrl': AppDoc['nationalIdUrl'],
          'medicalReportUrl': AppDoc['medicalReportUrl'],
          'proofOfDistanceUrl': AppDoc['proofOfDistanceUrl'],
          'socialSecurityCertificateUrl':
              AppDoc['socialSecurityCertificateUrl'],
          'roomKey': false,
          'resident': true,
        };
        print("Prepared MovedData: $MovedData");

        // Assuming AppDoc contains references to StuRef and RoomRef
        DocumentReference StuRef = AppDoc['studentInfo'];
        print("StuRef path: ${StuRef.path}");
        print("RoomRef path: ${RoomRef.path}");

        // Step 2: Check if StuRef exists
        DocumentSnapshot StuSnapshot = await StuRef.get();
        print("Fetched StuSnapshot for StuRef: ${StuRef.path}");

        if (StuSnapshot.exists) {
          print("StuRef document exists. Proceeding to move data...");

          // Step 3: Move data from AppRef to StuRef with merging
          await StuRef.set(MovedData, SetOptions(merge: true));
          print("Data successfully moved to StuRef: ${StuRef.path}");

          // Step 4: Update RoomRef to replace student reference and update status
          DocumentSnapshot RoomSnapshot = await RoomRef.get();
          print("Fetched RoomSnapshot for RoomRef: ${RoomRef.path}");

          if (RoomSnapshot.exists) {
            print("RoomRef document exists, processing room update...");

            List<dynamic> studentsInfo;
            var studentInfoField = RoomSnapshot['studentInfo'];

            if (studentInfoField is List<dynamic>) {
              // If it's already a list, use it directly
              studentsInfo = studentInfoField;
            } else if (studentInfoField is DocumentReference) {
              // If it's a single reference, create a list with that reference
              studentsInfo = [studentInfoField];
            } else {
              // If 'studentInfo' is not defined, set it to an empty list
              studentsInfo = [];
            }
            String type = RoomSnapshot.get('type');
            print("Room type: $type, current students info: $studentsInfo");

            Map<String, dynamic> updateRoom;
            if (type == 'Partner') {
              print("Room type is Partner. Updating students in room...");

              // Step 1: Get the current studentInfo array from RoomRef
              List<dynamic> studentsInfo = RoomSnapshot['studentInfo'] ?? [];

              // Step 2: Find the index of AppRef in the studentInfo array
              int index =
                  studentsInfo.indexWhere((ref) => ref.path == AppRef.path);
              print("Index of AppRef in studentInfo array: $index");

              if (index != -1) {
                // Step 3: Replace AppRef with StuRef at the found index
                studentsInfo[index] = StuRef;
                print("Replaced AppRef with StuRef in studentInfo array.");

                // Step 4: Update RoomRef with the modified studentInfo array and status
                updateRoom = {
                  'studentInfo': studentsInfo,
                  'status': studentsInfo.length == 1
                      ? 'Partially Occupied'
                      : 'Occupied',
                };
                await RoomRef.set(updateRoom, SetOptions(merge: true));
                print(
                    "Room updated successfully with replaced student reference.");
              } else {
                print("AppRef not found in studentInfo array.");
              }
            } else {
              // Non-Partner logic as previously defined
              print(
                  "Room type is not Partner. Updating room to occupied by single student.");
              updateRoom = {
                'studentInfo': StuRef,
                'status': 'Occupied',
              };
              await RoomRef.set(updateRoom, SetOptions(merge: true));
              print("Room updated successfully with new student information.");
            }

            // Optionally, clean up fields in StuRef
            await StuRef.update({
              //  "HousingApplicationRequest": FieldValue.delete(),
              "checkStatus": 'First Check-in'
            });
            print("Cleaned up HousingApplicationRequest field in StuRef.");
          } else {
            print("RoomRef does not exist.");
          }
        } else {
          print("StuRef does not exist.");
        }
      } else {
        print("AppRef does not exist.");
      }
    } catch (e) {
      print("Error moving data: $e");
    }
  }

// after final accept move all info in student doc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "View Request"),
      body: SafeArea(
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

                final data = snapshot.data!;
                final requestData = data['request'];
                roomId = "Rooms";
                var roomref;
                if (requestData['roomref'] != null) {
                  roomref = requestData['roomref'];
                  roomId = roomref?.id;
                }
                String? roomst = requestData['roomstatus'];
                var date = requestData['date'];
                final time = requestData['time'];
                final sturef = data['studentref'];
                final reqref = data['requestref'];
                fullname = requestData['fullName'] ?? 'N/A';
                efullname = requestData['efullName'] ?? 'N/A';
                final String BloodType = requestData['bloodType'] ?? 'N/A';
                final String DoB = requestData['DoB'] ?? 'N/A';
                final String NID = requestData['NID'] ?? 'N/A';
                final String Nationality = requestData['nationality'] ?? 'N/A';
                final String Degree = requestData['degree'] ?? 'N/A';
                final String College = requestData['college'] ?? 'N/A';
                final String phoneNumber = requestData['phoneNumber'] ?? 'N/A';
                final String e1phoneNumber =
                    requestData['e1phoneNumber'] ?? 'N/A';
                final String e2phoneNumber =
                    requestData['e2phoneNumber'] ?? 'N/A';
                email = data['email'];
                final String PNUID = data['PNUID'];
                final String e1email = requestData['e1email'] ?? 'N/A';
                final String e2email = requestData['e2email'] ?? 'N/A';
                final String city = requestData['city'] ?? 'N/A';
                final String nationalAdd = requestData['nationalAdd'] ?? 'N/A';
                final String zipCode = requestData['zipCode'] ?? 'N/A';
                final String status = requestData['status'];
                final String medicalReportUrl = requestData['medicalReportUrl'];
                final String nationalIdUrl = requestData['nationalIdUrl'];

                final String socialSecurityCertificateUrl =
                    requestData['socialSecurityCertificateUrl'];

                final String proofOfDistanceUrl =
                    requestData['proofOfDistanceUrl'];

                double screenWidth = MediaQuery.of(context).size.width;
                List<Widget> buttons = [];

                if (status != 'Final Accept') {
                  buttons.add(
                    actionbutton(
                      onPressed: () {
                        if (roomref == null) {
                          ErrorDialog("ٌReject Student?", context, buttons: [
                            {'Reject': () => context.pop()}
                          ]);
                          updateRequestStatus(reqref, 'Reject', roomref);
                        } else {
                          ErrorDialog(
                              "this Student has been assigned to a room",
                              context,
                              buttons: [
                                {'Ok': () => context.pop()}
                              ]);
                        }
                      },
                      text: 'Reject',
                      background: red1,
                    ),
                  );
                }

                if (status == 'Pending') {
                  buttons.add(
                    actionbutton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            updateRequestStatus(
                                reqref, 'Initial Accept', roomref);
                          });
                        }
                      },
                      text: 'Initial Accept',
                      background: blue1,
                    ),
                  );
                } else if (status == 'Initial Accept') {
                  buttons.add(
                    actionbutton(
                      onPressed: () {
                        print(roomst);

                        if (roomref != null &&
                            (roomst == "Available" ||
                                roomst == 'Partially Occupied')) {
                          updateRequestStatus(reqref, 'Final Accept', roomref);
                        } else {
                          ErrorDialog(
                              "this Student is not assigned to a room or room not Available",
                              context,
                              buttons: [
                                {'Ok': () => context.pop()}
                              ]);
                        }
                      },
                      text: 'Final Accept',
                      background: green1,
                    ),
                  );
                }

                return WillPopScope(
                  onWillPop: () async {
                    if (roomref != null && status == 'Initial Accept') {
                      ErrorDialog(
                        "This student is assigned to a room please update the request status",
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //PERSONAL INFO
                          Dtext(
                            t: "Personal Informatin",
                            align: TextAlign.center,
                            color: dark1,
                            fontWeight: FontWeight.w500,
                            size: 0.06,
                          ),

                          Divider(
                            color: grey1,
                            thickness: 1,
                            indent: screenWidth * 0.05,
                            endIndent: screenWidth * 0.05,
                          ),

                          Heightsizedbox(h: 0.013),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // BloodType
                              Column(
                                children: [
                                  text(
                                    t: "BloodType:",
                                    align: TextAlign.center,
                                    color: dark1,
                                  ),
                                  OurContainer(
                                    child: Dtext(
                                      t: BloodType,
                                      align: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      size: 0.055,
                                    ),
                                    backgroundColor: grey2,
                                    borderColor: green1,
                                    wdth: 0.4,
                                    hight: 0.12,
                                    pddng: 6,
                                    borderRadius: 15,
                                  ),
                                ],
                              ),

                              // Dob
                              Column(
                                children: [
                                  text(
                                    t: "Date Of Birth:",
                                    align: TextAlign.center,
                                    color: dark1,
                                  ),
                                  OurContainer(
                                    child: Dtext(
                                      t: DoB,
                                      align: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      size: 0.055,
                                    ),
                                    backgroundColor: grey2,
                                    borderColor: green1,
                                    wdth: 0.4,
                                    hight: 0.12,
                                    pddng: 6,
                                    borderRadius: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Heightsizedbox(h: 0.018),
                          // NID
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  text(
                                    t: "Nationality:",
                                    align: TextAlign.center,
                                    color: dark1,
                                  ),
                                  OurContainer(
                                    child: Dtext(
                                      t: Nationality,
                                      align: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      size: 0.055,
                                    ),
                                    backgroundColor: grey2,
                                    borderColor: green1,
                                    wdth: 0.4,
                                    hight: 0.12,
                                    pddng: 6,
                                    borderRadius: 15,
                                  ),
                                ],
                              ),
                              // NID
                              Column(
                                children: [
                                  text(
                                    t: NID.startsWith('1')
                                        ? "National ID:"
                                        : "Residency ID:",
                                    align: TextAlign.center,
                                    color: dark1,
                                  ),
                                  OurContainer(
                                    child: Dtext(
                                      t: NID,
                                      align: TextAlign.center,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      size: 0.055,
                                    ),
                                    backgroundColor: grey2,
                                    borderColor: green1,
                                    wdth: 0.4,
                                    hight: 0.12,
                                    pddng: 6,
                                    borderRadius: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Heightsizedbox(h: 0.018),
                          // Degree
                          text(
                            t: "Degree:",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: Degree,
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
                          // college
                          text(
                            t: "College:",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: College,
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
                          Heightsizedbox(h: 0.02),
                          //CONTACT INFO
                          Dtext(
                            t: "Conatact Informatin",
                            align: TextAlign.center,
                            color: dark1,
                            fontWeight: FontWeight.w500,
                            size: 0.06,
                          ),

                          Divider(
                            color: grey1,
                            thickness: 1,
                            indent: screenWidth * 0.05,
                            endIndent: screenWidth * 0.05,
                          ),

                          Heightsizedbox(h: 0.013),
                          //Email 1
                          text(
                            t: "Emergency Email 1",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: e1email,
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

                          //Email 2
                          text(
                            t: "Emergency Email 2",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: e2email,
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
                          //Emeregency phone numbers
                          Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //phone 1
                                  Column(
                                    children: [
                                      Dtext(
                                        t: "Emergency phone 1",
                                        align: TextAlign.start,
                                        color: dark1,
                                        size: 0.045,
                                      ),
                                      OurContainer(
                                        child: Dtext(
                                          t: e1phoneNumber,
                                          align: TextAlign.center,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          size: 0.055,
                                        ),
                                        backgroundColor: grey2,
                                        borderColor: green1,
                                        wdth: 0.4,
                                        hight: 0.12,
                                        pddng: 6,
                                        borderRadius: 15,
                                      ),
                                    ],
                                  ),
                                  Widthsizedbox(w: 0.06),
                                  // Student phone
                                  Column(
                                    children: [
                                      Dtext(
                                          t: "Emergency Phone 2",
                                          align: TextAlign.center,
                                          color: dark1,
                                          size: 0.045),
                                      OurContainer(
                                        child: Dtext(
                                          t: e2phoneNumber,
                                          align: TextAlign.center,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          size: 0.055,
                                        ),
                                        backgroundColor: grey2,
                                        borderColor: green1,
                                        wdth: 0.4,
                                        hight: 0.12,
                                        pddng: 6,
                                        borderRadius: 15,
                                      ),
                                    ],
                                  ),
                                ]),
                          ]),
                          Heightsizedbox(h: 0.018),

                          //ADDRESS INFO
                          Dtext(
                            t: "Address Informatin",
                            align: TextAlign.center,
                            color: dark1,
                            fontWeight: FontWeight.w500,
                            size: 0.06,
                          ),

                          Divider(
                            color: grey1,
                            thickness: 1,
                            indent: screenWidth * 0.05,
                            endIndent: screenWidth * 0.05,
                          ),

                          Heightsizedbox(h: 0.013),
                          // City
                          text(
                            t: "City",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: city,
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

                          //National address
                          text(
                            t: "National address",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: nationalAdd,
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
                          //Postal/Zip code
                          text(
                            t: "Postal/Zip code",
                            align: TextAlign.center,
                            color: dark1,
                          ),
                          OurContainer(
                            child: Dtext(
                              t: zipCode,
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
                          //Files
                          Dtext(
                            t: "The required files:",
                            align: TextAlign.center,
                            color: dark1,
                            fontWeight: FontWeight.w500,
                            size: 0.06,
                          ),

                          Divider(
                            color: grey1,
                            thickness: 1,
                            indent: screenWidth * 0.05,
                            endIndent: screenWidth * 0.05,
                          ),

                          Heightsizedbox(h: 0.013),

                          OurContainer(
                            backgroundColor: grey2,
                            borderColor: green1,
                            wdth: 0.9,
                            hight: 0.12,
                            pddng: 6,
                            borderRadius: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Dtext(
                                  t: "National ID",
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  size: 0.055,
                                ),
                                Dactionbutton(
                                    text: "Open",
                                    background: dark1,
                                    width: 0.25,
                                    height: 0.04,
                                    onPressed: () {
                                      context.pushNamed(
                                        '/pdf',
                                        extra: Pdf(
                                            Url: nationalIdUrl,
                                            title: "National ID"),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          Heightsizedbox(h: 0.018),
                          OurContainer(
                            backgroundColor: grey2,
                            borderColor: green1,
                            wdth: 0.9,
                            hight: 0.12,
                            pddng: 6,
                            borderRadius: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Dtext(
                                  t: "Medical Report",
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  size: 0.055,
                                ),
                                Dactionbutton(
                                    text: "Open",
                                    background: dark1,
                                    width: 0.25,
                                    height: 0.04,
                                    onPressed: () {
                                      context.pushNamed(
                                        '/pdf',
                                        extra: Pdf(
                                            Url: medicalReportUrl,
                                            title: "Medical Report"),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          Heightsizedbox(h: 0.018),

                          OurContainer(
                            backgroundColor: grey2,
                            borderColor: green1,
                            wdth: 0.9,
                            hight: 0.12,
                            pddng: 6,
                            borderRadius: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Dtext(
                                  t: "Proof Of Distance",
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  size: 0.055,
                                ),
                                Dactionbutton(
                                    text: "Open",
                                    background: dark1,
                                    width: 0.25,
                                    height: 0.04,
                                    onPressed: () {
                                      context.pushNamed(
                                        '/pdf',
                                        extra: Pdf(
                                            Url: proofOfDistanceUrl,
                                            title: "Proof Of Distance"),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          Heightsizedbox(h: 0.018),
                          OurContainer(
                            backgroundColor: grey2,
                            borderColor: green1,
                            wdth: 0.9,
                            hight: 0.12,
                            pddng: 6,
                            borderRadius: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Dtext(
                                  t: "Social Security",
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  size: 0.055,
                                ),
                                Dactionbutton(
                                    text: "Open",
                                    background: dark1,
                                    width: 0.25,
                                    height: 0.04,
                                    onPressed: () {
                                      context.pushNamed(
                                        '/pdf',
                                        extra: Pdf(
                                            Url: socialSecurityCertificateUrl,
                                            title: "Social Security"),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          if (status == 'Pending')
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Heightsizedbox(h: 0.018),
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
                                  OurFormField(
                                    fieldType: 'date',
                                    selectedDate: selectedDate,
                                    onSelectDate: () async {
                                      final DateTime? pickedDate = await pickDate(
                                          context); // the pickDate(context) it`s the function in the bellow (19 in this Design file)
                                      if (pickDate != null) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                          // Update the selected date
                                        });
                                      }
                                    },
                                    labelText: "Select Date:",
                                  ),
                                ],
                              ),
                            ),
                          Heightsizedbox(h: 0.018),
                          if (status == 'Initial Accept')
                            Column(
                              children: [
                                text(
                                  t: "Scheduled meeting",
                                  align: TextAlign.center,
                                  color: dark1,
                                ),
                                OurContainer(
                                  child: Dtext(
                                    t: 'Time:$time Date: $date',
                                    align: TextAlign.center,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    size: 0.045,
                                  ),
                                  backgroundColor: grey2,
                                  borderColor: green1,
                                  wdth: 0.9,
                                  hight: 0.12,
                                  pddng: 6,
                                  borderRadius: 15,
                                ),
                                Heightsizedbox(h: 0.018),
                                Row(
                                  children: [
                                    text(
                                      t: "Assign a Room: ",
                                      align: TextAlign.center,
                                      color: dark1,
                                    ),
                                    Dactionbutton(
                                        text: roomId,
                                        background: dark1,
                                        width: 0.25,
                                        height: 0.04,
                                        onPressed: () {
                                          //saverooms();

                                          context.pushNamed('/assignroom',
                                              extra: Room(
                                                  sturef: sturef,
                                                  requestref: reqref));
                                        }),
                                  ],
                                ),
                              ],
                            ),

                          Heightsizedbox(h: 0.018),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: buttons,
                          ),
                        ]),
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

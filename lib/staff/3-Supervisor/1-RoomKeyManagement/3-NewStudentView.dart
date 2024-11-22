import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/4-AssignRoom.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:intl/intl.dart';

class NewStudentView extends StatefulWidget {
  final DocumentReference sturef;
  const NewStudentView({super.key, required this.sturef});

  @override
  State<NewStudentView> createState() => _NewStudentViewState();
}

class _NewStudentViewState extends State<NewStudentView> {
  Future<Map<String, dynamic>>? getRequest;

  @override
  void initState() {
    super.initState();
    getRequest = getDocumentData(widget.sturef);
  }

  Future<Map<String, dynamic>> getDocumentData(DocumentReference docRef) async {
    try {
      // Fetch the document snapshot
      DocumentSnapshot snapshot = await docRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Return the data as a Map
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // Handle the case where the document doesn't exist
        throw Exception("Document does not exist");
      }
    } catch (e) {
      // Handle any errors that occur
      print("Error fetching document: $e");
      rethrow; // Re-throw the exception to handle it outside the function if needed
    }
  }

  Future<void> updateRoomKey(DocumentReference docRef) async {
    try {
      await docRef.update({"roomKey": true});
      print("Field updated successfully");
      setState(() {
        getRequest = getDocumentData(widget.sturef);
      });
    } catch (e) {
      print("Error updating field: $e");
    }
  }

// after final accept move all info in student doc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "View Student"),
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

                final Data = snapshot.data!;
                final String roomId = Data['roomref'].id;
                final String fullname = Data['fullName'] ?? 'N/A';
                final String efullname = Data['efullName'] ?? 'N/A';
                final String BloodType = Data['bloodType'] ?? 'N/A';
                final String DoB = Data['DoB'] ?? 'N/A';
                final String Nationality = Data['nationality'] ?? 'N/A';
                final String Degree = Data['degree'] ?? 'N/A';
                final String College = Data['college'] ?? 'N/A';
                final String phoneNumber = Data['phoneNumber'] ?? 'N/A';
                final String e1phoneNumber = Data['e1phoneNumber'] ?? 'N/A';
                final String e2phoneNumber = Data['e2phoneNumber'] ?? 'N/A';
                final String email = Data['email'];
                final String PNUID = Data['PNUID'];
                final String e1email = Data['e1email'] ?? 'N/A';
                final String e2email = Data['e2email'] ?? 'N/A';
                final String medicalReportUrl = Data['medicalReportUrl'];

                final String socialSecurityCertificateUrl =
                    Data['socialSecurityCertificateUrl'];

                double screenWidth = MediaQuery.of(context).size.width;

                return Padding(
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            Widthsizedbox(w: 0.09),
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
                        //Student PNUID
                        text(
                            t: "Nationality: ",
                            align: TextAlign.start,
                            color: dark1),
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
                          wdth: 0.9,
                          hight: 0.12,
                          pddng: 6,
                          borderRadius: 15,
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
                        Heightsizedbox(h: 0.018),

                        text(
                          t: "Room Number:",
                          align: TextAlign.center,
                          color: dark1,
                        ),

                        OurContainer(
                          child: Dtext(
                            t: roomId,
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

                        Heightsizedbox(h: 0.013),

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

                        Heightsizedbox(h: 0.025),
                        if (Data['roomKey'] == true)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                actionbutton(
                                    onPressed: () {
                                      updateRoomKey(widget.sturef);
                                    },
                                    text: "Confirm",
                                    background: dark1),
                              ]),
                      ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

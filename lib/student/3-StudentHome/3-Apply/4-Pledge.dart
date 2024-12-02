import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/3-StudentHome/0-StudentHomePage.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/0-Component/-pledge_text.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/3-Files.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/2-Information.dart';

class Pledge extends StatefulWidget {
  // final allstudent args;

  const Pledge({
    Key? key,
    //  required this.args
  }) : super(key: key);
  @override
  State<Pledge> createState() => _PledgeState();
}

class _PledgeState extends State<Pledge> {
  bool? housingPledge = false;
  bool isLoading = false;
  bool hasReq = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // safearea
      body: SafeArea(
        // to scroll
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // index for the stepper
              OurStepper(currentStep: 3),
              Padding(
                padding: const EdgeInsets.all(20),
                // container for instructions
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: PledgeText(),
                      ),
                      width: double.infinity,
                      height: 500,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white.withOpacity(0.5),
                          border:
                              Border.all(color: Color(0xff007580), width: 1)),
                    ),
                  ],
                ),
              ),

              CheckboxListTile(
                value: housingPledge,
                title: const Text(
                  "By signing this pledge, I attest to the accuracy of all the information provided and agree to accept responsibility for any fraud or lying. ",
                  style: TextStyle(
                      color: Color(0xFF007580),
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                onChanged: (studentBool) {
                  setState(() {
                    housingPledge = studentBool;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF007580),
              ),
              // sized box
              Heightsizedbox(h: 0.003),
              // row for buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back button
                    actionbutton(
                        onPressed: isLoading
                            ? null // Disable button when loading
                            : () {
                                context.goNamed('/files');
                              },
                        text: 'Back',
                        background: dark1),
                    // forward button
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(dark1),
                      ), // Custom button background color

                      onPressed: isLoading
                          ? null // Disable button when loading
                          : () async {
                              setState(() {
                                isLoading == true;
                              });

                              hasReq = await checkAppReqAndStatus();

                              if (!hasReq) {
                                if (housingPledge != null && housingPledge!) {
                                  InfoDialog(
                                    "You are about to submit an application request. Do you wish to continue?",
                                    context,
                                    buttons: [
                                      {
                                        "Yes": () => {
                                              context.pop(),
                                              saveAppRequest(
                                                DataManager.getfiles(),
                                                DataManager.getStudentInfo(),
                                              ),
                                            },
                                      },
                                      {
                                        "No": () => context.pop(),
                                      },
                                    ],
                                  );
                                } else {
                                  ErrorDialog(
                                      'Please check the pledge to continue.',
                                      context,
                                      buttons: [
                                        {
                                          "Ok": () => context.pop(),
                                        },
                                      ]);
                                }
                              } else {
                                ErrorDialog(
                                    "Sorry, you have send application request, you can not send another request",
                                    context,
                                    buttons: [
                                      {
                                        'Ok': () => {
                                              context.pop(),
                                              setState(() {
                                                isLoading == false;
                                              }),
                                            }
                                      }
                                    ]);
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.06,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit', // Display the button text
                              style: TextStyle(
                                color: Colors
                                    .white, // Button text color set to white
                                fontSize: SizeHelper.getSize(context) *
                                    0.04, // Set the font size for the text dynamically
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAppRequest(allFliesArgs fargs, studentInfoArgs args) async {
    setState(() {
      isLoading = true; // Start loading
    });

    // name Capitalizer
    String efirstName = args.efirstName;
    efirstName = TextCapitalizer.CtextS(efirstName);
    String emiddleName = args.emiddleName;
    emiddleName = TextCapitalizer.CtextS(emiddleName);
    String elastName = args.elastName;
    elastName = TextCapitalizer.CtextS(elastName);
    String efullname = '$efirstName $emiddleName $elastName';
    String fullname = '${args.firstName} ${args.middleName} ${args.lastName}';
    efullname = TextCapitalizer.CtextS(efullname);
    print(efullname);
    // Define a map to store file URLs after upload
    Map<String, String> fileUrls = {};

    final firestore = FirebaseFirestore.instance;

    try {
      String studentId =
          FirebaseAuth.instance.currentUser!.uid; // Current user ID

      // Create a document reference without creating the document yet
      DocumentReference housingDocRef =
          firestore.collection('HousingApplication').doc();
      DocumentReference sturef = firestore
          .collection('student')
          .doc(studentId); // Reference to student document
      final housingAppData = {
        'fullName': fullname,
        'firstName': args.firstName,
        'middleName': args.middleName,
        'lastName': args.lastName,
        'efullName': efullname,
        'efirstName': efirstName,
        'emiddleName': emiddleName,
        'elastName': elastName,
        'bloodType': args.BloodType,
        'DoB': args.DoB,
        'degree': args.Degree,
        'college': args.College,
        'NID': args.NID,
        'nationality': args.Nationality,
        'phoneNumber': args.phoneNumber,
        'e1phoneNumber': args.e1phoneNumber,
        'e2phoneNumber': args.e2phoneNumber,
        'e1email': args.e1email,
        'e2email': args.e2email,
        'city': args.city,
        'nationalAdd': args.nationalAdd,
        'zipCode': args.zipCode,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
        'studentInfo': sturef
      };
      InfoDialog(
        "The request has been submitted Please wait for a response. The response will be sent via email",
        context,
        buttons: [
          {
            "Ok": () => {
                  context.pop(),
                  context.goNamed('/studenthome'),
                }
          },
        ],
      );
      // Save form data to Firestore with automatic reference creation
      await housingDocRef.set(housingAppData);
      print('Data added successfully!');

      // Now use the housingDocRef ID to update the student document
      await sturef.update({
        'HousingApplicationRequest': housingDocRef,
      });

      // Upload all files and save URLs
      fileUrls['nationalIdUrl'] =
          await _uploadFile(fargs.nationalIdFile, UploadType.nationalId);
      fileUrls['medicalReportUrl'] =
          await _uploadFile(fargs.medicalReportFile, UploadType.medicalReport);
      fileUrls['proofOfDistanceUrl'] = await _uploadFile(
          fargs.proofOfDistanceFile, UploadType.proofOfDistance);
      fileUrls['socialSecurityCertificateUrl'] = await _uploadFile(
          fargs.socialSecurityCertificateFile,
          UploadType.socialSecurityCertificate);

      // Save file URLs to Firestore
      await housingDocRef.set(fileUrls, SetOptions(merge: true));

      print('File URLs saved in Firestore successfully!');
      setState(() {
        isLoading = false; // Start loading
      });
    } catch (error) {
      print('Error saving application: $error');
    }
  }

  Future<String> _uploadFile(File? file, UploadType type) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    String fileName = "";

    switch (type) {
      case UploadType.nationalId:
        fileName = "national_id_${file?.path.split('/').last}";
        break;
      case UploadType.medicalReport:
        fileName = "medical_report_${file?.path.split('/').last}";
        break;
      case UploadType.proofOfDistance:
        fileName = "proof_of_distance_${file?.path.split('/').last}";
        break;
      case UploadType.socialSecurityCertificate:
        fileName = "social_security_certificate_${file?.path.split('/').last}";
        break;
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child('Housing Application Files/$userId/$fileName');

    try {
      // Get the current user's ID token for authentication
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();

      // If the token is null, handle the error or prompt the user to log in
      if (token == null) {
        print('Failed to retrieve token');
        return "";
      }

      // Upload the file with the token as metadata
      final uploadTask = ref.putFile(
        file!,
        SettableMetadata(
          customMetadata: {
            'authorization': 'Bearer $token', // Pass the token as metadata
          },
        ),
      );

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL of the uploaded file
      final downloadUrl = await ref.getDownloadURL();

      print('$fileName uploaded successfully!');
      return downloadUrl;
    } catch (error) {
      print('Error uploading $fileName: $error');
      return "";
    }
  }
}

class DataManager {
  static studentInfoArgs _studentInfo = studentInfoArgs(
    firstName: "",
    middleName: "",
    lastName: "",
    efirstName: "",
    emiddleName: "",
    elastName: "",
    NID: "",
    phoneNumber: "",
    e1phoneNumber: "",
    e2phoneNumber: "",
    email: "",
    e1email: "",
    e2email: "",
    city: "",
    nationalAdd: "",
    zipCode: "",
    College: "",
    Degree: "",
    BloodType: "",
    Nationality: "",
    DoB: "",
  );
  static allFliesArgs _files = allFliesArgs(
    nationalIdFile: File(''),
    medicalReportFile: File(''),
    proofOfDistanceFile: File(''),
    socialSecurityCertificateFile: File(''),
  );

  static void saveStudentInfo(studentInfoArgs studentInfo) {
    _studentInfo = studentInfo;
  }

  static void savefiles(allFliesArgs files) {
    _files = files;
  }

  static studentInfoArgs getStudentInfo() {
    return _studentInfo;
  }

  static allFliesArgs getfiles() {
    return _files;
  }
}



//   Future<void> saveAppRequest(allFliesArgs fargs, studentInfoArgs args) async {
//     // name Capitalizer
//     String efirstName = args.efirstName;
//     efirstName = TextCapitalizer.CtextS(efirstName);
//     String emiddleName = args.emiddleName;
//     emiddleName = TextCapitalizer.CtextS(emiddleName);
//     String elastName = args.elastName;
//     elastName = TextCapitalizer.CtextS(elastName);
//     String efullname = '$efirstName $emiddleName $elastName';
//     String fullname = '${args.firstName} ${args.middleName} ${args.lastName}';
//     efullname = TextCapitalizer.CtextS(efullname);
//     print(efullname);
//     // Define a map to store file URLs after upload
//     Map<String, String> fileUrls = {};

//     final firestore = FirebaseFirestore.instance;

//     try {
//       String studentId =
//           FirebaseAuth.instance.currentUser!.uid; // Current user ID

//       // Create a document reference without creating the document yet
//       DocumentReference housingDocRef =
//           firestore.collection('HousingApplication').doc();
//       DocumentReference sturef = firestore
//           .collection('student')
//           .doc(studentId); // Reference to student document
//        final housingAppData = {
//       'fullName': fullname,
//       'firstName': args.firstName,
//       'middleName': args.middleName,
//       'lastName': args.lastName,
//       'efullName': efullname,
//       'efirstName': efirstName,
//       'emiddleName': emiddleName,
//       'elastName': elastName,
//       'bloodType': args.BloodType,
//       'DoB': args.DoB,
//       'degree': args.Degree,
//       'college': args.College,
//       'NID': args.NID,
//       'nationality': args.Nationality,
//       'phoneNumber': args.phoneNumber,
//       'e1phoneNumber': args.e1phoneNumber,
//       'e2phoneNumber': args.e2phoneNumber,
//       'e1email': args.e1email,
//       'e2email': args.e2email,
//       'city': args.city,
//       'nationalAdd': args.nationalAdd,
//       'zipCode': args.zipCode,
//       'status': 'Pending',
//       'createdAt': FieldValue.serverTimestamp(),
//       'studentInfo': sturef
//     };

//       // Save form data to Firestore with automatic reference creation
//       await housingDocRef.set(housingAppData);
//       print('Data added successfully!');

//       // Now use the housingDocRef ID to update the student document
//       await sturef.update({
//         'HousingApplicationRequest': housingDocRef,
//       });

//       // Upload all files and save URLs
//       fileUrls['nationalIdUrl'] =
//           await _uploadFile(fargs.nationalIdFile, UploadType.nationalId);
//       fileUrls['medicalReportUrl'] =
//           await _uploadFile(fargs.medicalReportFile, UploadType.medicalReport);
//       fileUrls['proofOfDistanceUrl'] = await _uploadFile(
//           fargs.proofOfDistanceFile, UploadType.proofOfDistance);
//       fileUrls['socialSecurityCertificateUrl'] = await _uploadFile(
//           fargs.socialSecurityCertificateFile,
//           UploadType.socialSecurityCertificate);

//       // Save file URLs to Firestore
//       await housingDocRef.set(fileUrls, SetOptions(merge: true));
//       // await firestore
//       //     .collection('HousingApplicationFiles')
//       //     .doc(housingDocRef as String?)
//       //     .set(fileUrls, SetOptions(merge: true));

//       // Step 2: Save the furnitureRequest document reference in the student document

//       print('File URLs saved in Firestore successfully!');
//       InfoDialog(
//         "The request has been submitted Please wait for a response. The response will be sent via email",
//         context,
//         buttons: [
//           {
//             "Ok": () => {
//                   context.pop(),
//                   context.goNamed('/studenthome'),
//                 }
//           },
//         ],
//       );
//     } catch (error) {
//       print('Error saving application: $error');
//     }
//   }

//   Future<String> _uploadFile(File? file, UploadType type) async {
//     final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
//     String fileName = "";

//     switch (type) {
//       case UploadType.nationalId:
//         fileName = "national_id_${file?.path.split('/').last}";
//         break;
//       case UploadType.medicalReport:
//         fileName = "medical_report_${file?.path.split('/').last}";
//         break;
//       case UploadType.proofOfDistance:
//         fileName = "proof_of_distance_${file?.path.split('/').last}";
//         break;
//       case UploadType.socialSecurityCertificate:
//         fileName = "social_security_certificate_${file?.path.split('/').last}";
//         break;
//     }

//     final ref = FirebaseStorage.instance
//         .ref()
//         .child('Housing Application Files/$userId/$fileName');
//     try {
//       await ref.putFile(file!);
//       final downloadUrl = await ref.getDownloadURL();
//       print('$fileName uploaded successfully!');
//       return downloadUrl;
//     } catch (error) {
//       print('Error uploading $fileName: $error');
//       return "";
//     }
//   }
// }  how to enhance the file saving and make it faster
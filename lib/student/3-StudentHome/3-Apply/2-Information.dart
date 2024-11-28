import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/3-Files.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/4-Pledge.dart';
import 'package:intl/intl.dart';

class HousingInformation extends StatefulWidget {
  const HousingInformation({super.key});

  @override
  State<HousingInformation> createState() => _HousingInformationState();
}

class _HousingInformationState extends State<HousingInformation> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final efirstNameController = TextEditingController();
  final emiddleNameController = TextEditingController();
  final elastNameController = TextEditingController();
  final NIDController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final e1phoneNumberController = TextEditingController();
  final e2phoneNumberController = TextEditingController();
  final e1emailController = TextEditingController();
  final e2emailController = TextEditingController();
  final cityController = TextEditingController();
  final nationalAddController = TextEditingController();
  final zipCodeController = TextEditingController();
  final nationalityController = TextEditingController();
  DateTime? DoB;
  String email = '';
  String selectedBloodType = '';
  String selectedDegree = '';
  String selectedCollege = '';
  String selectedNationality = '';

  void onBloodTypeSelected(String bloodType) {
    if (bloodType.isNotEmpty) {
      setState(() {
        selectedBloodType = bloodType;
      });
    }
  }

  void onNationalitySelected(String degree) {
    if (degree.isNotEmpty) {
      setState(() {
        selectedNationality = degree;
      });
    }
  }

  void onDegreeSelected(String degree) {
    if (degree.isNotEmpty) {
      setState(() {
        selectedDegree = degree;
      });
    }
  }

  void onCollegeSelected(String college) {
    if (college.isNotEmpty) {
      setState(() {
        selectedCollege = college;
      });
    }
  }

  late final String studentId; // Declare studentId
  late DocumentReference studentDoc;

  void initState() {
    super.initState();
    // Initialize studentId and studentDoc here
    studentId = FirebaseAuth.instance.currentUser!.uid; // Current user ID
    studentDoc =
        FirebaseFirestore.instance.collection('student').doc(studentId);

    // Fetch data from collection1
    fetchDataFromCollection1();
  }

  Future<void> fetchDataFromCollection1() async {
    DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(studentId)
        .get();
    if (studentSnapshot.exists) {
      setState(() {
        email = studentSnapshot['email'];
      });
      // Access the 'name' field
      // You can now use the name variable as needed, e.g., to set a controller or display it
      print('Fetched Name: $email');
    } else {
      ErrorDialog("Document does not exist in collection1", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
      // safearea
      body: SafeArea(
        // to scroll
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // index for the stepper
              OurStepper(currentStep: 1),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            text(
                                t: "Your Full Name",
                                align: TextAlign.center,
                                color: dark1),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // First Name
                            textform(
                              controller: firstNameController,
                              hinttext: "First Name in Arabic",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valArabic(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your first name";
                                  case "2":
                                    return "First name cannot contain numbers";
                                  case "3":
                                    return "First name cannot contain special characters";
                                  case "4":
                                    return "First name must be in Arabic";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // Middle Name
                            textform(
                              controller: middleNameController,
                              hinttext: "Middle Name in Arabic",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valArabic(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your middle name";
                                  case "2":
                                    return "Middle name cannot contain numbers";
                                  case "3":
                                    return "Middle name cannot contain special characters";
                                  case "4":
                                    return "Middle name must be in Arabic";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // Last Name
                            textform(
                              controller: lastNameController,
                              hinttext: "Last Name in Arabic",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valArabic(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your last name";
                                  case "2":
                                    return "Last name cannot contain numbers";
                                  case "3":
                                    return "Last name cannot contain special characters";
                                  case "4":
                                    return "Last name must be in Arabic";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // First Name
                            textform(
                              controller: efirstNameController,
                              hinttext: "First Name in English",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valEnglish(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your first name";
                                  case "2":
                                    return "First name cannot contain numbers";
                                  case "3":
                                    return "First name cannot contain special characters";
                                  case "4":
                                    return "First name must be in English";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // Middle Name
                            textform(
                              controller: emiddleNameController,
                              hinttext: "Middle Name in English",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valEnglish(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your middle name";
                                  case "2":
                                    return "Middle name cannot contain numbers";
                                  case "3":
                                    return "Middle name cannot contain special characters";
                                  case "4":
                                    return "Middle name must be in English";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // Last Name
                            textform(
                              controller: elastNameController,
                              hinttext: "Last Name in English",
                              lines: 1,
                              validator: (val) {
                                String? validationResult = valEnglish(val);

                                switch (validationResult) {
                                  case "1":
                                    return "Please write your last name";
                                  case "2":
                                    return "Last name cannot contain numbers";
                                  case "3":
                                    return "Last name cannot contain special characters";
                                  case "4":
                                    return "Last name must be in English";
                                  default:
                                    return null; // No error
                                }
                              },
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            text(
                                t: "Personal Information",
                                align: TextAlign.center,
                                color: dark1),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            DropdownList(
                              hint: "Nationality",
                              items: ['Saudi', 'Non-Saudi'],
                              onItemSelected: onNationalitySelected,
                            ),

                            if (selectedNationality == 'Non-Saudi')
                              Column(
                                children: [
                                  Heightsizedbox(
                                    h: 0.018,
                                  ), // Nationality
                                  textform(
                                    controller: nationalityController,
                                    hinttext: "Nationality",
                                    lines: 1,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please write your nationality";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // National ID or Iqama
                            textform(
                              controller: NIDController,
                              hinttext: "National ID or Residency",
                              lines: 1,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please write your ID";
                                } else if (val.length != 10) {
                                  return "NID must be 10 digits long";
                                } else if (!RegExp(r'^\d{10}$').hasMatch(val)) {
                                  return "NID must contain only numbers";
                                } else if (selectedNationality == 'Non-Saudi' &&
                                    NIDController.text.isNotEmpty &&
                                    NIDController.text.startsWith('1')) {
                                  return "Please write your residency correctly.";
                                }
                                return null;
                              },
                            ),
                            Heightsizedbox(h: 0.018),
                            OurFormField(
                              fieldType: 'date1',
                              selectedDate1:
                                  DoB, // Use selectedDate1 instead of selectedDate
                              onSelectDate1: () async {
                                // Use onSelectDate1 instead of onSelectDate
                                final DateTime? pickedDate = await pickDate1(
                                    context); // Call pickDate1 instead of pickDate
                                if (pickedDate != null) {
                                  setState(() {
                                    DoB =
                                        pickedDate; // Update the selected date
                                  });
                                }
                              },
                              labelText:
                                  "Date Of Birth:", // if you don`t need labelText make it empty: labelText: "",
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),

                            DropdownList(
                              hint: "BloodType",
                              items: [
                                'A+',
                                'A-',
                                'B+',
                                'B-',
                                'AB+',
                                'AB-',
                                'O+',
                                'O-'
                              ],
                              onItemSelected: onBloodTypeSelected,
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            DropdownList(
                              hint: "Degree",
                              items: ['Master', 'Bachelor', 'Diploma'],
                              onItemSelected: onDegreeSelected,
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            DropdownList(
                              hint: "College",
                              items: [
                                'Computer and Information Sciences',
                                'Engineering',
                                'Science',
                                'Sport Sciences and Physical Activity',
                                'Business Administration',
                                'Health and Rehabilitation Sciences',
                                'Medicine',
                                'Nursing',
                                'Pharmacy',
                                'Dentistry',
                                'Foundation Year for Health Colleges',
                                'Education and Human Development',
                                'Languages',
                                'Art and Design',
                                'Law',
                                'Humanities and Social Sciences',
                                'Applied Colleges',
                                'Arabic Teaching for Non-Arabic',
                                'English Language Institute'
                              ],
                              onItemSelected: onCollegeSelected,
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),

                            text(
                                t: "Contact Information",
                                align: TextAlign.center,
                                color: dark1),
                            Heightsizedbox(h: 0.018),
                            // Phone Number
                            textform(
                              controller: phoneNumberController,
                              hinttext: "Phone Number",
                              lines: 1,
                              validator: (val) => val == ""
                                  ? "Please write your phone number"
                                  : val!.length != 10
                                      ? "Phone number must be 10 digits"
                                      : !val!.startsWith('05')
                                          ? "Phone number must start with 05"
                                          : val!.contains(RegExp(r'[^\d]'))
                                              ? "Phone number can only contain numbers"
                                              : null,
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Dtext(
                                    t: '$email',
                                    align: TextAlign.center,
                                    color: dark1,
                                    size: 0.05),
                              ),
                              width: double.infinity,
                              height: 47,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: grey2,
                                border: Border.all(
                                    color: Color(0xff007580), width: 0.7),
                              ),
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),

                            // Phone Number
                            textform(
                              controller: e1phoneNumberController,
                              hinttext: "Emergency Phone Number 1",
                              lines: 1,
                              validator: (val) => val == ""
                                  ? "Please write your phone number"
                                  : val!.length != 10
                                      ? "Phone number must be 10 digits"
                                      : !val!.startsWith('05')
                                          ? "Phone number must start with 05"
                                          : val!.contains(RegExp(r'[^\d]'))
                                              ? "Phone number can only contain numbers"
                                              : null,
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),

                            // Email
                            textform(
                              controller: e1emailController,
                              hinttext: "Emergency Email 1",
                              lines: 1,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please write your PNU email";
                                }
                                return null;
                              },
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),

                            // Phone Number
                            textform(
                              controller: e2phoneNumberController,
                              hinttext: "Emergency Phone Number 2",
                              lines: 1,
                              validator: (val) => val == ""
                                  ? "Please write your phone number"
                                  : val!.length != 10
                                      ? "Phone number must be 10 digits"
                                      : !val!.startsWith('05')
                                          ? "Phone number must start with 05"
                                          : val!.contains(RegExp(r'[^\d]'))
                                              ? "Phone number can only contain numbers"
                                              : null,
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),

                            // Email
                            textform(
                              controller: e2emailController,
                              hinttext: "Emergency Email 2",
                              lines: 1,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please write your PNU email";
                                }
                                return null;
                              },
                            ),
                            Heightsizedbox(
                              h: 0.018,
                            ),
                            text(
                                t: "Address Information",
                                align: TextAlign.center,
                                color: dark1),
                            Heightsizedbox(h: 0.018),
                            // City
                            textform(
                              controller: cityController,
                              hinttext: "City",
                              lines: 1,
                              validator: (val) =>
                                  val == "" ? "Please write your city" : null,
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),
                            // National Address
                            textform(
                              controller: nationalAddController,
                              hinttext: "National Address",
                              lines: 1,
                              validator: (val) => val == ""
                                  ? "Please write your National Address"
                                  : null,
                            ),

                            Heightsizedbox(
                              h: 0.018,
                            ),

                            // Zip Code
                            textform(
                              controller: zipCodeController,
                              hinttext: "Zip Code",
                              lines: 1,
                              validator: (val) => val == ""
                                  ? "Please write your Zip code"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      Heightsizedbox(
                        h: 0.018,
                      ),

                      // row for buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // back button
                          actionbutton(
                              onPressed: () {
                              //  handleBackButtonPress(context);
                                context.goNamed('/instructions');
                              },
                              text: 'Back',
                              background: dark1),
                          // forward button
                          actionbutton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                     if (selectedNationality == 'Non-Saudi'){
                                  selectedNationality =
                                      nationalityController.text;}
                                  DataManager.saveStudentInfo(studentInfoArgs(
                                    firstName: firstNameController.text,
                                    middleName: middleNameController.text,
                                    lastName: lastNameController.text,
                                    efirstName: efirstNameController.text,
                                    emiddleName: emiddleNameController.text,
                                    elastName: elastNameController.text,
                                    NID: NIDController.text,
                                    phoneNumber: phoneNumberController.text,
                                    email: email,
                                    e1phoneNumber: e1phoneNumberController.text,
                                    e1email: e1emailController.text,
                                    e2phoneNumber: e2phoneNumberController.text,
                                    e2email: e2emailController.text,
                                    city: cityController.text,
                                    nationalAdd: nationalAddController.text,
                                    zipCode: zipCodeController.text,
                                    BloodType: selectedBloodType,
                                    Degree: selectedDegree,
                                    College: selectedCollege,
                                    Nationality: selectedNationality,
                                    DoB: DateFormat('yyyy-MM-dd').format(DoB!),
                                  ));
                                  context.goNamed(
                                    '/files',
                                  );
                                }
                              },
                              text: 'Next Step',
                              background: dark1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? valArabic(String? val) {
  final arabicRegex = RegExp(r'^[\u0600-\u06FF\s]+$');

  if (val == null || val.isEmpty) {
    return "1"; // Code 1: Empty field
  } else if (val.contains(RegExp(r'[0-9]'))) {
    return "2"; // Code 2: Contains numbers
  } else if (RegExp(r'[^\u0600-\u06FF\u0750-\u077F\d\s]').hasMatch(val)) {
    return "3"; // Code 3: Contains special characters
  } else if (!arabicRegex.hasMatch(val)) {
    return "4"; // Code 4: Not in Arabic
  }
  return null; // Valid input
}

String? valEnglish(String? val) {
  final englishRegex = RegExp(r'^[a-zA-Z\s]+$');

  if (val == null || val.isEmpty) {
    return "1"; // Code 1: Empty field
  } else if (val.contains(RegExp(r'[0-9]'))) {
    return "2"; // Code 2: Contains numbers
  } else if (RegExp(r'[^\w\s]').hasMatch(val)) {
    return "3"; // Code 3: Contains special characters
  } else if (!englishRegex.hasMatch(val)) {
    return "4"; // Code 4: Not in English
  }
  return null; // Valid input
}

class studentInfoArgs {
  final String firstName;
  final String middleName;
  final String lastName;
  final String efirstName;
  final String emiddleName;
  final String elastName;
  final String NID;
  final String phoneNumber;
  final String e1phoneNumber;
  final String e2phoneNumber;
  final String email;
  final String e1email;
  final String e2email;
  final String city;
  final String nationalAdd;
  final String zipCode;
  final String College;
  final String Degree;
  final String BloodType;
  final String Nationality;
  final String DoB;

  studentInfoArgs(
      {required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.efirstName,
      required this.emiddleName,
      required this.elastName,
      required this.NID,
      required this.phoneNumber,
      required this.e1phoneNumber,
      required this.e2phoneNumber,
      required this.email,
      required this.e1email,
      required this.e2email,
      required this.city,
      required this.nationalAdd,
      required this.zipCode,
      required this.College,
      required this.Degree,
      required this.BloodType,
      required this.Nationality,
      required this.DoB});
}
// void handleBackButtonPress(BuildContext context) {
//   if (true) {
//     InfoDialog('Are sure you wnat to go back', context, buttons: buttons)
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Action Required"),
//           content: Text(
//             "This student is assigned to a room. Please update the request status.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     // Proceed with other logic or navigation
//     Navigator.of(context).pop(); // Example: Go back
//   }
// }

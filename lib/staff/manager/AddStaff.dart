import 'dart:math';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pnustudenthousing/staff/StaffProfile.dart';

class addStaff extends StatefulWidget {
  const addStaff({super.key});

  @override
  _addStaffState createState() => _addStaffState();
}

class _addStaffState extends State<addStaff> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final NIDController = TextEditingController();
  final OfficeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final password = PasswordGenerator.generatePassword(
    length: 16,
    includeUppercase: true,
    includeLowercase: true,
    includeNumbers: true,
    includeSymbols: true,
  );
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Add Staff'),
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            // To scroll when keyboard hide
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 8),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 10.0),
                                ),
                                // Firat Name
                                textform(
                                  controller: firstNameController,
                                  validator: (val) => val == ""
                                      ? "Please write staff first name"
                                      : val!.contains(RegExp(
                                              r'[0-9]')) // Check for numbers
                                          ? "First name cannot contain numbers"
                                          : val!.contains(RegExp(
                                                  r'[^\w\s]')) // Check for special characters
                                              ? "First name cannot contain special characters"
                                              : null,
                                  hinttext: "First Name",
                                  lines: 1,
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Middle Name
                                textform(
                                  controller: middleNameController,
                                  hinttext: "Middle Name",
                                  lines: 1,
                                  validator: (val) => val == ""
                                      ? "Please write staff middle name"
                                      : val!.contains(RegExp(
                                              r'[0-9]')) // Check for numbers
                                          ? "Middle name cannot contain numbers"
                                          : val!.contains(RegExp(
                                                  r'[^\w\s]')) // Check for special characters
                                              ? "Middle name cannot contain special characters"
                                              : null,
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),
                                // Last Name

                                textform(
                                  controller: lastNameController,
                                  hinttext: "Last Name",
                                  lines: 1,
                                  validator: (val) => val == ""
                                      ? "Please write staff last name"
                                      : val!.contains(RegExp(
                                              r'[0-9]')) // Check for numbers
                                          ? "Last name cannot contain numbers"
                                          : val!.contains(RegExp(
                                                  r'[^\w\s]')) // Check for special characters
                                              ? "Last name cannot contain special characters"
                                              : null,
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // National ID
                                textform(
                                  controller: NIDController,
                                  hinttext: "National ID",
                                  lines: 1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write staff ID";
                                    } else if (val.length != 10) {
                                      return "NID must be 10 digits long";
                                    } else if (!RegExp(r'^\d{10}$')
                                        .hasMatch(val)) {
                                      return "NID must contain only numbers";
                                    }
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Phone Number
                                textform(
                                  controller: phoneNumberController,
                                  hinttext: "Phone Number",
                                  lines: 1,
                                  validator: (val) => val == ""
                                      ? "Please write the phone number"
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
                                  controller: emailController,
                                  hinttext: "Email",
                                  lines: 1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write staff PNU email";
                                    } /* commented for testing purpose
                                    else {
                                      final RegExp emailRegExp =
                                          RegExp(r'^[0-9]{9}@pnu.edu.sa$');
                                      final isValid = emailRegExp.hasMatch(val);
                                      if (!isValid) {
                                        return "There is an error in staff PNU email";
                                      }
                                    }*/
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                //Office NO.
                                textform(
                                  controller: OfficeController,
                                  hinttext: "Office NO.",
                                  lines: 1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write staff Office";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                DropdownList(
                                  hint: "Staff Role",
                                  items: [
                                    'Students affairs officer',
                                    'Resident student supervisor',
                                    'Housing security guard',
                                    'Housing buildings officer',
                                    'Nutrition specialist',
                                    'Social Specialist'
                                  ],
                                  onItemSelected: onRoleSelected,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an item'; // Validation message
                                    }
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Button
                                actionbutton(
                                  text: "Add Staff",
                                  background: dark1,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await addUser();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onRoleSelected(String role) {
    if (role.isNotEmpty) {
      setState(() {
        selectedRole = role;
      });
    }
  }

  Future<void> addUser() async {
    formKey.currentState!.save();
    String fullname = firstNameController.text +
        " " +
        middleNameController.text +
        " " +
        lastNameController.text;
    print(fullname);
    fullname = TextCapitalizer.CtextS(fullname);
    print(fullname);
    try {
      // Create the user in Firebase pnustudenthousing
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: password,
        // Set a temporary password
      );

      // Send email for setting the password
      await userCredential.user!.sendEmailVerification();

      // Store additional user details in Firestore
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameController.text,
        'middleName': middleNameController.text,
        'lastName': lastNameController.text,
        'fullname': fullname,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'office': OfficeController.text,
        'NID': int.tryParse(NIDController.text),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });

      InfoDialog("Staff added successfully!", context, onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Staffprofile(),
          ),
        );
      });

      print(password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user: $e')),
      );
    }
  }
}

class PasswordGenerator {
  static String generatePassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const numberChars = '0123456789';
    const symbolChars = '!@#%^&*_-';

    final characterSets = <String>[];
    if (includeUppercase) characterSets.add(uppercaseChars);
    if (includeLowercase) characterSets.add(lowercaseChars);
    if (includeNumbers) characterSets.add(numberChars);
    if (includeSymbols) characterSets.add(symbolChars);

    if (characterSets.isEmpty) {
      throw ArgumentError('At least one character set must be included.');
    }

    final random = Random.secure();
    final passwordChars = <String>[];

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(characterSets.length);
      final randomChar = characterSets[randomIndex]
          [random.nextInt(characterSets[randomIndex].length)];
      passwordChars.add(randomChar);
    }

    return passwordChars.join();
  }
}

class DropdownList extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onItemSelected;
  final String hint;

  const DropdownList({
    Key? key,
    required this.items,
    required this.onItemSelected,
    required this.hint,
    required this.validator,
  }) : super(key: key);
  final FormFieldValidator validator;
  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selectedItem;
  var validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField<String>(
        hint: Text(widget.hint),
        value: selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            selectedItem = newValue;
          });

          widget.onItemSelected(newValue!);
        },
        validator: validator,
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: red1,
              ),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: green1),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: light1),
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        menuMaxHeight: 200.0,
      ),
    );
  }
}

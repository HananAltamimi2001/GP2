import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/2-Information.dart';

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
  final efirstNameController = TextEditingController();
  final emiddleNameController = TextEditingController();
  final elastNameController = TextEditingController();
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
                                // First Name
                                textform(
                                  controller: firstNameController,
                                  hinttext: "First Name in Arabic",
                                  lines: 1,
                                  validator: (val) {
                                    String? validationResult = valArabic(val);

                                    switch (validationResult) {
                                      case "1":
                                        return "Please write staff first name";
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
                                        return "Please write staff Middle name";
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
                                        return "Please write staff Last name";
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
    // arabic name
    String fullname = firstNameController.text +
        " " +
        middleNameController.text +
        " " +
        lastNameController.text;
    print(fullname);
    fullname = TextCapitalizer.CtextS(fullname);
    print(fullname);
    // Name Capitalizer
    String efullname = efirstNameController.text +
        " " +
        emiddleNameController.text +
        " " +
        elastNameController.text;
    print(Easing.legacyAccelerate);
    efullname = TextCapitalizer.CtextS(efullname);

    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: Firebase.app());

      // Create the user in Firebase pnustudenthousing
      UserCredential userCredential =
          await secondaryAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: password,
        // Set a temporary password
      );

      // Store additional user details in Firestore
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameController.text,
        'middleName': middleNameController.text,
        'lastName': lastNameController.text,
        'fullName': fullname,
        'efirstName': efirstNameController.text,
        'emiddleName': emiddleNameController.text,
        'elastName': elastNameController.text,
        'efullName': efullname,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'office': OfficeController.text,
        'NID': int.tryParse(NIDController.text),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print(password);
      // Create an instance of your Firestore mail collection
      await FirebaseFirestore.instance.collection('mail').add({
        'to': emailController.text,
        'message': {
          'subject': "Welcome to PNU Student Housing: Instructions",
          'html': """
      <html>
      <body>
      <!-- Greeting -->
      <p style="color: #339199; font-size: 20px;">Hello ${fullname},</p>
      <!-- Welcome Message -->
      <p>We are excited to welcome you to the PNU Student Housing. Your account has been successfully created.</p>
      <p style="text-align: right;"> يسعدنا أن نرحب بك في السكن الطلابي بجامعة الأميرة نورة بنت عبدالرحمن. لقد تم إنشاء حسابك في التطبيق بنجاح.</p>
      <!-- Step 1: Download the App -->
      <h4>Step 1: Download PNU Student Housing App App</h4>
      <p>Please download the app to manage your tasks efficiently.</p>
      <h4 style="text-align: right;">الخطوة 1: تنزيل تطبيق PNU Student Housing App</h4>
      <p style="text-align: right;">يرجى تنزيل التطبيق لإدارة مهامك بكفاءة في السكن.</p>
      <!-- Step 2: Reset Password -->
      <h4>Step 2: Reset Your Password</h4>
      <p>Please reset your password to ensure your account's security:</p>
      <p>Resetting your password will give you full access to your account and allow you to manage your tasks effectively.</p>
      <h4 style="text-align: right;">الخطوة 2: إعادة تعيين كلمة المرور</h4>
      <p style="text-align: right;">يرجى إعادة تعيين كلمة المرور لضمان أمان حسابك:</p>
      <p style="text-align: right;">ستتيح لك إعادة تعيين كلمة المرور الوصول الكامل إلى حسابك وتسمح لك بإدارة مهامك بفعالية.</p>
      <p>Thank you,</p>
      <p>PNU Housing team</p>
      <p style="text-align: right;">،شكراً لك</p>
      <p style="text-align: right;">فريق سكن نورة</p>

      </body>
      </html>
    """,
        },
      });

      print('sended email');
      secondaryAuth.signOut();
      InfoDialog(
        "Staff added successfully!",
        context,
        buttons: [
          {
            "Ok": () => {
                  context.pop(),
                  firstNameController.clear(),
                  middleNameController.clear(),
                  lastNameController.clear(),
                  efirstNameController.clear(),
                  emiddleNameController.clear(),
                  elastNameController.clear(),
                  emailController.clear(),
                  phoneNumberController.clear(),
                  NIDController.clear(),
                  OfficeController.clear(),

                  // Reset the dropdown
                  setState(() {
                    selectedRole = null;
                  }),
                }
          }
        ],
      );
    } catch (e) {
      ErrorDialog(
        "Failed to add user",
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
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

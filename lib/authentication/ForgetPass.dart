import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/authentication/firbase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var NIDController = TextEditingController();
  final FirbaseAuthService _auth = FirbaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OurAppBar(
        icon: Icons.language_rounded,
        onIconPressed: () {}, // For language
      ),
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
                    padding: EdgeInsets.all(2.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        30.0,
                        0.0,
                        30.0,
                        8.0,
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Logo
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Image.asset(
                                    'assets/logo green.png',
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 0.02 *
                                        MediaQuery.of(context).size.height,
                                    bottom: 0.01 *
                                        MediaQuery.of(context).size.height,
                                  ),
                                  child: Titletext(
                                    t: "Enter your information to send reset password email",
                                    align: TextAlign.center,
                                    color: Color(0xff007580),
                                  ),
                                ),
                                // National ID or Iqama
                                textform(
                                  controller: NIDController,
                                  hinttext: "National ID or Iqama",
                                  lines: 1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write your ID";
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

                                // Email
                                textform(
                                  controller: emailController,
                                  hinttext: "Email",
                                  lines: 1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write your PNU email";
                                    }
                                    //  else {
                                    //   final RegExp emailRegExp =
                                    //       RegExp(r'^[0-9]{9}@pnu.edu.sa$');
                                    //   final isValid = emailRegExp.hasMatch(val);
                                    //   if (!isValid) {
                                    //     return "There is an error in your PNU email";
                                    //   }
                                    // }
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Button Reset Password
                                actionbutton(
                                  text: "Reset Password",
                                  background: dark1,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await verifyUser();
              
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

  // Method to check if email and NID match in Firestore and send reset password email
  Future<void> verifyUser() async {
    try {
      String localPart = emailController.text.split('@')[0];
      RegExp regExp = RegExp(r'^\d{8}');
      bool startsWithEightDigits = regExp.hasMatch(localPart);

      QuerySnapshot userQuery;
      if (startsWithEightDigits) {
        // Query Firestore for the document with the same email and NID
        userQuery = await FirebaseFirestore.instance
            .collection('student')
            .where('email', isEqualTo: emailController.text)
            .where('NID', isEqualTo: NIDController.text)
            .get();
      } else {
        userQuery = await FirebaseFirestore.instance
            .collection('staff')
            .where('email', isEqualTo: emailController.text)
            .where('NID', isEqualTo: NIDController.text)
            .get();
      }
      print(userQuery);
      if (userQuery.docs.isNotEmpty) {
        await _auth.resetPassword(
            emailController.text, context); // User verified
      }
    } catch (e) {
      
      print('Error fetching user data: $e');
    }
  }
}

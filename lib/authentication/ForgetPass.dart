import 'package:go_router/go_router.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(),
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
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(dark1),
                                  ), // Custom button background color

                                  onPressed: isLoading
                                      ? null // Disable button when loading
                                      : () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true; // Start loading
                                            });
                                            await verifyUser();
                                            setState(() {
                                              isLoading =
                                                  false; // Start loading
                                            });
                                          }
                                        },
                                  child: isLoading
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Reset Password', // Display the button text
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Button text color set to white
                                            fontSize: SizeHelper.getSize(
                                                    context) *
                                                0.04, // Set the font size for the text dynamically
                                          ),
                                        ),
                                ),
                                Heightsizedbox(
                                  h: 0.018,
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
            .get();
      } else {
        userQuery = await FirebaseFirestore.instance
            .collection('staff')
            .where('email', isEqualTo: emailController.text)
            .get();
      }
      print(userQuery);
      bool reseted = false;
      if (userQuery.docs.isNotEmpty) {
        reseted = await _auth.resetPassword(
            emailController.text, context); // User verified
        if (reseted) {
           InfoDialog(
            "Reset password email was sent please check your email inbox",
            context,
            buttons: [
              {
                "Ok": () => context.pop(),
              },
            ],
          );
         
        } else {
          ErrorDialog(
            "Error sending password reset email, Please try again later.",
            context,
            buttons: [
              {
                "Ok": () => context.pop(),
              },
            ],
          );
        }
      }
    } catch (e) {
       ErrorDialog(
            "'Error Occured Please try again later",
            context,
            buttons: [
              {
                "Ok": () => context.pop(),
              },
            ],
          );
      print('Error fetching user data: $e');
    }
  }
}

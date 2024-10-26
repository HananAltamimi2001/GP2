import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/authentication/firbase_auth_services.dart';

class SetPass extends StatefulWidget {
  final SetPassArguments args;

  const SetPass({Key? key, required this.args}) : super(key: key);

  @override
  State<SetPass> createState() => _SetPassState();
}

class _SetPassState extends State<SetPass> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        30.0,
                        30.0,
                        30.0,
                        8.0 * MediaQuery.of(context).size.height / 812.0,
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

                                // Form title
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.0 *
                                        MediaQuery.of(context).size.height /
                                        812.0, // Dynamic top padding
                                    bottom: 10.0 *
                                        MediaQuery.of(context).size.height /
                                        812.0, // Dynamic bottom padding
                                  ),
                                  child: Titletext(
                                    t: "Set Password",
                                    align: TextAlign.center,
                                    color: Color(0xff007580),
                                  ),
                                ),
                                // Password
                                PasswordField(
                                    passwordController: passwordController,
                                    hintText: "Password",
                                    validator: (String? value) {
                                      String? validatePassword(String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }

                                        if (value.length < 8) {
                                          return 'Password must be at least 8 characters long';
                                        }

                                        const uppercaseRegex = r'[A-Z]';
                                        const lowercaseRegex = r'[a-z]';
                                        const digitRegex = r'[0-9]';
                                        const symbolRegex = r'[!@#%^&*_-]';

                                        final hasUppercase =
                                            RegExp(uppercaseRegex)
                                                .hasMatch(value);
                                        final hasLowercase =
                                            RegExp(lowercaseRegex)
                                                .hasMatch(value);
                                        final hasDigit =
                                            RegExp(digitRegex).hasMatch(value);
                                        final hasSymbol =
                                            RegExp(symbolRegex).hasMatch(value);

                                        if (!hasUppercase) {
                                          return 'Password must contain at least one uppercase letter';
                                        }

                                        if (!hasLowercase) {
                                          return 'Password must contain at least one lowercase letter';
                                        }

                                        if (!hasDigit) {
                                          return 'Password must contain at least one digit';
                                        }

                                        if (!hasSymbol) {
                                          return 'Password must contain at least one symbol !@#%^&*_-';
                                        }

                                        return null;
                                      }

                                      return null;
                                    }),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Confirm Password
                                PasswordField(
                                  passwordController: confirmPasswordController,
                                  hintText: "Confirm Password",
                                  validator: (String? val) {
                                    if (val == "") {
                                      return "Please confirm your password";
                                    }

                                    if (val != passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                //Register
                                actionbutton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      signUp();
                                    }
                                  },
                                  //fontsize: ,
                                  text: "Register",
                                  background: dark1,
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

  //Signup
  void signUp() async {
    try {
      String password = passwordController.text;

      User? user =
          await _auth.signupWithEmailAndPassword(widget.args.email, password);

      if (user != null) {
        // name Capitalizer
        String firstName = widget.args.firstName;
        firstName = TextCapitalizer.CtextS(firstName);
        String middleName = widget.args.middleName;
        middleName = TextCapitalizer.CtextS(middleName);
        String lastName = widget.args.lastName;
        lastName = TextCapitalizer.CtextS(lastName);
        String fullname = '$firstName $middleName $lastName';
        fullname = TextCapitalizer.CtextS(fullname);
        print(fullname);

        final String email = '${widget.args.email}';
        final String pnuid = email.split('@')[0];

        // Validate PNUID for 9 characters
        if (pnuid.length != 9 || !pnuid.contains(RegExp(r'^\d{9}$'))) {
          // Handle the error, e.g., show a message or log an error
          print('Invalid PNUID: must be 9 digits and contain only numbers');
          return; // Or handle the error in a different way
        }
        await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .set({
          'firstName':firstName,
          'middleName':middleName,
          'lastName': lastName,
          'fullname':fullname, 
          'PNUID': pnuid,
          'email': email,
          'phone': '${widget.args.phone}',
          'NID': '${widget.args.NID}',
          'createdAt': FieldValue.serverTimestamp(),
        });
         InfoDialog(
         "Your registration is complete. Please log in to continue.",
          context,
          buttons: [
            {
              "Ok": () =>  context.go("/login"),
            },
          ],
        );
        // context.goNamed('/infodialog',
        //     extra: InfoDialogArguments(
        //       message:
        //           "Your registration is complete. Please log in to continue.",
        //       buttonText: "ok",
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ));
        // InfoDialog("Your registration is complete. Please log in to continue.",
        //     context, onPressed: () {
        //   context.go("/login");
        // });

        // For testing purpose
        // Registration successful
        print('Registration successful');
      } else {
         ErrorDialog(
          "An error occurred. Please try again later.",
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
        // ErrorDialog("An error occurred during registration", context,
        //     onPressed: () {
        //   Navigator.pop(context);
        // });
        // Handle error
        print('Registration failed');
      }
    } catch (e) {
       ErrorDialog(
          "An error occurred. Please try again later ohoooooooood.",
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
      // Handle error
      // ErrorDialog("An error occurred during registration", context,
      //     onPressed: () {
      //   Navigator.pop(context);
      // });
      print('Registration failed: $e');
    }
  }
}

// arguments for the route
class SetPassArguments {
  final String firstName;
  final String middleName;
  final String lastName;
  final int NID;
  final String email;
  //final String password;
  final String phone;

  SetPassArguments({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.NID,
    required this.email,
    required this.phone,
  });
}

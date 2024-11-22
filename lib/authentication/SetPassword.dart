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
//signup
void signUp() async {
  try {
    String password = passwordController.text;

    User? user =
        await _auth.signupWithEmailAndPassword(widget.args.email, password);
    print('user added');
    if (user != null) {
      try {
        // Name Capitalizer
        String efullname = widget.args.efullName;
        efullname = TextCapitalizer.CtextS(efullname);

        List<String> enameParts = efullname.trim().split(" ");
        String efirstName = '';
        String emiddleName = '';
        String elastName = '';

        for (int i = 0; i < enameParts.length; i++) {
          switch (i) {
            case 0:
              efirstName = enameParts[i].trim();
              break;
            case 1:
              emiddleName = enameParts[i].trim();
              break;
            case 2:
              elastName = enameParts[i].trim();
              break;
            default:
              elastName += ' ' + enameParts[i].trim();
              break;
          }
        }

        final String email = '${widget.args.email}';
        final String pnuid = email.split('@')[0];

        if (pnuid.length != 9 || !pnuid.contains(RegExp(r'^\d{9}$'))) {
          print('Invalid PNUID: must be 9 digits and contain only numbers');
          return;
        }

        await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .set({
          'fullName': widget.args.fullName,
          'firstName': efirstName,
          'middleName': emiddleName,
          'lastName': elastName,
          'efullName': efullname,
          'PNUID': pnuid,
          'email': email,
          'resident': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        InfoDialog(
          "Your registration is complete. Please log in to continue.",
          context,
          buttons: [
            {
              "Ok": () => context.go("/login"),
            },
          ],
        );

        print('Registration successful');
      } catch (e) {
        // Rollback Firestore document and Auth user in case of any Firestore error
        print("Error saving data: $e");

        // Check and delete the Firebase Authentication user
        try {
          await user.delete();
          print("User deleted from authentication.");
        } catch (authDeleteError) {
          print("Error deleting user from authentication: $authDeleteError");
        }

        ErrorDialog(
          "An error occurred. Please try again later.",
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
        return;
      }
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
      print('Registration failed');
    }
  } catch (e) {
    // Handle general registration errors
    print('Registration failed: $e');

    // Try deleting the Firestore document and Auth user if they exist
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('student')
            .doc(currentUser.uid)
            .get();

        // Delete Firestore document if it exists
        if (studentDoc.exists) {
          await FirebaseFirestore.instance
              .collection('student')
              .doc(currentUser.uid)
              .delete();
          print("Firestore document deleted.");
        }
      } catch (firestoreDeleteError) {
        print("Error deleting Firestore document: $firestoreDeleteError");
      }

      // Delete Firebase Authentication user
      try {
        await currentUser.delete();
        print("User deleted from authentication.");
      } catch (authDeleteError) {
        print("Error deleting user from authentication: $authDeleteError");
      }
    }

    ErrorDialog(
      "An error occurred. Please try again later.",
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
// arguments for the route
class SetPassArguments {
  final String fullName;
  final String efullName;
  final String email;

  SetPassArguments({
    required this.fullName,
    required this.efullName,
    required this.email,
  });
}

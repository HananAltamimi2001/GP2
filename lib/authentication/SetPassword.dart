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
  final isObsecure =
      true.obs; // Create an observable variable to control password visibility
  final isObsecure2 =
      true.obs; // Create an observable variable to control password visibility

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
                                Obx(
                                  () => TextFormField(
                                    controller:
                                        passwordController, // Bind input to the password controller
                                    obscureText: isObsecure
                                        .value, // Hide or show the password based on isObsecure's value
                                    validator: (String? value) {
                                      // Check if value is null
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }

                                      // Password validation logic
                                      const uppercaseRegex = r'[A-Z]';
                                      const lowercaseRegex = r'[a-z]';
                                      const digitRegex = r'[0-9]';
                                      const symbolRegex = r'[!@#%^&*_-]';
                                      const singleQuotePattern = r"[']";
                                      const doubleQuotePattern = r'["]';

                                      final RegExp singleQuoteRegex =
                                          RegExp(singleQuotePattern);
                                      final RegExp doubleQuoteRegex =
                                          RegExp(doubleQuotePattern);

                                      final bool hasUppercase =
                                          RegExp(uppercaseRegex)
                                              .hasMatch(value);
                                      final bool hasLowercase =
                                          RegExp(lowercaseRegex)
                                              .hasMatch(value);
                                      final bool hasDigit =
                                          RegExp(digitRegex).hasMatch(value);
                                      final bool hasSymbol =
                                          RegExp(symbolRegex).hasMatch(value);

                                      if (doubleQuoteRegex.hasMatch(value) ||
                                          singleQuoteRegex.hasMatch(value)) {
                                        return 'Input must not contain special characters';
                                      }
                                      if (!hasUppercase) {
                                        return 'Must contain at least one uppercase letter';
                                      }
                                      if (!hasLowercase) {
                                        return 'Must contain at least one lowercase letter';
                                      }
                                      if (!hasDigit) {
                                        return 'Must contain at least one digit';
                                      }
                                      if (!hasSymbol) {
                                        return 'Must contain at least one symbol !@#%^&*_-';
                                      }

                                      if (value.length < 8) {
                                        return 'Must be at least 8 characters long';
                                      }

                                      return null; // Return null if all checks pass
                                    },

                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons
                                            .vpn_key_sharp, // Icon for password input
                                        color: Color(
                                            0xff007580), // Color of the icon
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          isObsecure.value = !isObsecure
                                              .value; // Toggle password visibility on tap
                                        },
                                        child: Icon(
                                          isObsecure.value
                                              ? Icons.visibility_off
                                              : Icons
                                                  .visibility, // Icon changes based on password visibility
                                          color: const Color(0xff007580),
                                        ),
                                      ),
                                      hintText: "Password", // Display hint text
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                red1, // Border color when there is a validation error
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: red2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  green1), // Border when the input is focused
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  light1), // Border when the input is enabled
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            14, // Horizontal padding for input content
                                        vertical:
                                            6, // Vertical padding for input content
                                      ),
                                      fillColor: Colors
                                          .white, // Background color of the input field
                                      filled:
                                          true, // Enable background color fill
                                    ),
                                  ),
                                ),
                                Heightsizedbox(
                                  h: 0.018,
                                ),
                                // Password
                                Obx(
                                  () => TextFormField(
                                    controller:
                                        confirmPasswordController, // Bind input to the password controller
                                    obscureText: isObsecure2
                                        .value, // Hide or show the password based on isObsecure's value
                                    validator: (String? val) {
                                      if (val == "") {
                                        return "Please confirm your password";
                                      }

                                      if (val != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons
                                            .vpn_key_sharp, // Icon for password input
                                        color: Color(
                                            0xff007580), // Color of the icon
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          isObsecure2.value = !isObsecure2
                                              .value; // Toggle password visibility on tap
                                        },
                                        child: Icon(
                                          isObsecure2.value
                                              ? Icons.visibility_off
                                              : Icons
                                                  .visibility, // Icon changes based on password visibility
                                          color: const Color(0xff007580),
                                        ),
                                      ),
                                      hintText:
                                          "Confirm Password", // Display hint text
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                red1, // Border color when there is a validation error
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: red2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  green1), // Border when the input is focused
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  light1), // Border when the input is enabled
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            14, // Horizontal padding for input content
                                        vertical:
                                            6, // Vertical padding for input content
                                      ),
                                      fillColor: Colors
                                          .white, // Background color of the input field
                                      filled:
                                          true, // Enable background color fill
                                    ),
                                  ),
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

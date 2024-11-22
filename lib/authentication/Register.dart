import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/authentication/SetPassword.dart';
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/2-Information.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final efullNameController = TextEditingController();
  final emailController = TextEditingController();

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
                  // Register screen signup form
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

                                // Form title
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 0.02 *
                                        MediaQuery.of(context).size.height,
                                    bottom: 0.01 *
                                        MediaQuery.of(context).size.height,
                                  ),
                                  child: Titletext(
                                    t: "Register",
                                    align: TextAlign.center,
                                    color: Color(0xff007580),
                                  ),
                                ),
                                // Firat Name
                                Heightsizedbox(
                                  h: 0.018,
                                ),
                                // Last Name
                                textform(
                                  controller: fullNameController,
                                  hinttext: "Full Name in Arabic",
                                  lines: 1,
                                  validator: (val) {
                                    String? validationResult = valArabic(val);

                                    switch (validationResult) {
                                      case "1":
                                        return "Please write your full name";
                                      case "2":
                                        return "Full name cannot contain numbers";
                                      case "3":
                                        return "Full name cannot contain special characters";
                                      case "4":
                                        return "Full name must be in Arabic";
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
                                  controller: efullNameController,
                                  hinttext: "Full Name in English",
                                  lines: 1,
                                  validator: (val) {
                                    String? validationResult = valEnglish(val);

                                    switch (validationResult) {
                                      case "1":
                                        return "Please write your full name";
                                      case "2":
                                        return "Full name cannot contain numbers";
                                      case "3":
                                        return "Full name cannot contain special characters";
                                      case "4":
                                        return "Full name must be in English";
                                      default:
                                        return null; // No error
                                    }
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
                                    } else {
                                      final RegExp emailRegExp =
                                          RegExp(r'^[0-9]{9}@pnu.edu.sa$');
                                      final isValid = emailRegExp.hasMatch(val);
                                      if (!isValid) {
                                        return "There is an error in your PNU email";
                                      }
                                    }
                                    return null;
                                  },
                                ),

                                Heightsizedbox(
                                  h: 0.018,
                                ),

                                // Button Set Password
                                actionbutton(
                                  text: "Set Password",
                                  background: dark1,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.pushNamed(
                                        '/setpass',
                                        extra: SetPassArguments(
                                          fullName: fullNameController.text,
                                          efullName: efullNameController.text,
                                          email: emailController.text,
                                        ),
                                      );
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
}

import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/Authentication/SetPassword.dart';
import 'package:flutter/material.dart';
import 'package:string_extensions/string_extensions.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final NIDController = TextEditingController();

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
                        8.0 ,
                      ),
                      child: Column(children: [
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
                                      MediaQuery.of(context).size.height ,
                                  bottom: 0.01 *
                                      MediaQuery.of(context).size.height ,
                             
                                ),
                                child: Titletext(
                                  t: "Register",
                                  align: TextAlign.center,
                                  color: Color(0xff007580),
                                ),
                              ),
                                // Firat Name
                                textform(
                                  controller: firstNameController,
                                  validator: (val) => val == ""
                                      ? "Please write your first name"
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
                                      ? "Please write your middle name"
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
                                      ? "Please write your last name"
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
                                      Navigator.of(context).pushNamed(
                                        '/setpass',
                                        arguments: SetPassArguments(
                                          firstName: firstNameController.text.capitalize,
                                          middleName:
                                              middleNameController.text.capitalize,
                                          lastName: lastNameController.text.capitalize,
                                          email: emailController.text,
                                          phone: 
                                              phoneNumberController.text,
                                          NID: int.parse(NIDController.text),
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
  }}
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';
import 'package:pnustudenthousing/authentication/firbase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirbaseAuthService _auth = FirbaseAuthService();
  final isObsecure =
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
            // To scroll when keyboard hide
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Login screen header

                  // Login screen form
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 8.0),
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
                                  top:
                                      0.02 * MediaQuery.of(context).size.height,
                                  bottom:
                                      0.01 * MediaQuery.of(context).size.height,
                                ),
                                child: Titletext(
                                  t: "Login",
                                  align: TextAlign.center,
                                  color: Color(0xff007580),
                                ),
                              ),
                              // Email
                              textform(
                                  controller: emailController,
                                  hinttext: "Email",
                                  lines: 1,
                                  icon: Icons.email,
                                  iconColor: dark1,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please write your PNU email";
                                    } /*
                                  commented for testing purpose
                                  else {
                                    final RegExp emailRegExp =
                                        RegExp(r'.*@pnu.edu.sa$');
                                    final isValid = emailRegExp.hasMatch(val);
                                    if (!isValid) {
                                      return "There is an error in your PNU email";
                                    }*/
                                    return null;
                                  }
                                  // },
                                  ),

                              Heightsizedbox(
                                h: 0.018,
                              ),

                              // Password
                              Obx(
                                () => TextFormField(
                                  controller:
                                      passwordController, // Bind input to the password controller
                                  obscureText: isObsecure
                                      .value, // Hide or show the password based on isObsecure's value
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    // Check for invalid characters
                                    const singleQuotePattern = r"[']";
                                    const doubleQuotePattern = r'["]';

                                    if (RegExp(singleQuotePattern)
                                            .hasMatch(value) ||
                                        RegExp(doubleQuotePattern)
                                            .hasMatch(value)) {
                                      return 'Password must not contain single or double quotes';
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                                h: 0.0001,
                              ),
                              // Forget password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.goNamed("/forgetpass");
                                    },
                                    child: const Dtext(
                                        t: "Forget your Pssword?",
                                        align: TextAlign.center,
                                        color: Color(0xFF4ca585),
                                        size: 0.025),
                                  ),
                                ],
                              ),

                              Heightsizedbox(
                                h: 0.018,
                              ),

                              // Button
                              actionbutton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate())
                                      signin();
                                  },
                                  text: "Login",
                                  background: dark1),
                            ],
                          ),
                        ),

                        Heightsizedbox(
                          h: 0.018,
                        ),

                        // Don not have account register
                        // We put row to stay in same line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Dtext(
                                t: "New Student?",
                                color: Color(0xff007580),
                                align: TextAlign.center,
                                size: 0.03),
                            TextButton(
                              onPressed: () {
                                context.goNamed("/register");
                              },
                              child: const Dtext(
                                t: "Register Here",
                                align: TextAlign.center,
                                size: 0.03,
                                color: Color(0xFF4ca585),
                              ),
                            ),
                          ],
                        ),
                      ]),
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

// Signin method
  void signin() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;

      User? user =
          await _auth.signinWithEmailAndPassword(context, email, password);

      if (user != null) {
        // Save the login status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        RouteUsers.routes(context, user.uid);
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
      }
    } catch (e) {
      ErrorDialog(
        'Login Failed. Incorrect email or password',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );

      print('Error: $e');
    }
  }
}

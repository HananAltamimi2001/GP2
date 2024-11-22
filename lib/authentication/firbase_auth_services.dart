import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class FirbaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signup
  Future<User?> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      checkSignInStatus();
     // await _auth.signOut();
      checkSignInStatus();
      return credential.user;
    } on FirebaseAuthException catch (e) {
                  print("here$e");

      return null;
      /*
      Fluttertoast.showToast(
        msg: "An error occurred during registration $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );*/
    }
  }

  // For test purpose check sign in status
  void checkSignInStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      print('User is signed in: ${user.email}');
    } else {
      // User is not signed in
      print('User is not signed in');
    }
  }

  // Signin
  Future<User?> signinWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      print("here");
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        return credential.user;
      }
    } on FirebaseAuthException catch (e) {
            print("here$e");

      return null;
      /* print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Login Failed. Incorrect email or password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );*/
    }
    return null;
  }

  Future<void> signout(context) async {
    
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    GoRouter.of(context).go('/login');
  }

  // Reset password
  Future<void> resetPassword(String email, var context) async {
    {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        InfoDialog(
          "Reset password email was sent please check your email inbox",
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );

        // InfoDialog(
        //     "Reset password email was sent please check your email inbox",
        //     "Ok",
        //     context, onPressed: () {
        //   context.pop();
        // });
      } catch (e) {
        ErrorDialog(
          "Error sending password reset email, Please try again later.",
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
        // ErrorDialog(
        //     "Error sending password reset email, Please try again later.",
        //     "Ok",
        //     context, onPressed: () {
        //   context.pop();
        // });
        //  Fluttertoast.showToast(
        // msg: 'Error sending password reset email',
        // toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.CENTER,
        // backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,

        // );
      }
    }
  }
}

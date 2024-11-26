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
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("here$e");

      return null;
    
    }
  }

  // // For test purpose check sign in status
  // void checkSignInStatus() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // User is signed in
  //     print('User is signed in: ${user.email}');
  //   } else {
  //     // User is not signed in
  //     print('User is not signed in');
  //   }
  // }

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
  Future<bool> resetPassword(String email, var context) async {
    {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return true;
       
      } catch (e) {
        return false;
       
       
      }
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RouteUsers {
  static Future<void> routes(BuildContext context, String? uid) async {
    final query = FirebaseFirestore.instance.collection('student').doc(uid);
    DocumentSnapshot documentSnapshot = await query.get();

    if (documentSnapshot.exists) {
      Navigator.pushReplacementNamed(context, '/personalacc');
    } else {
      // Otherwise, query the staff collection
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('staff').doc(uid).get();

      if (snapshot.exists) {
        // Get the role from the document
        String role = snapshot['role'];

        // Route based on the role
        switch (role) {
          case 'Housing manager':
            Navigator.pushReplacementNamed(context, '/manager');
            break;
          case 'Students affairs officer':
            Navigator.pushReplacementNamed(context, '/studentsAffairs');
            break;
          case 'Resident student supervisor':
            Navigator.pushReplacementNamed(context, '/supervisor');
            break;
          case 'Housing security guard':
            Navigator.pushReplacementNamed(context, '/security');
            break;
          case 'Housing buildings officer':
            Navigator.pushReplacementNamed(context, '/buildingsOfficer');
            break;
          case 'Nutrition specialist':
            Navigator.pushReplacementNamed(context, '/nutritionSpecialist');
            break;
          case 'Social Specialist':
            Navigator.pushReplacementNamed(context, '/socialSpecialist');
            break;
          default:
            // Fallback route if role is unknown
            Navigator.pushReplacementNamed(context, '/UnknownRole');
        }
      }
    }
  }
}

class LoginChecker {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> checker(BuildContext context) async {
    bool loggedIn = await LoginChecker.isLoggedIn();
    if (loggedIn) {
      // Check if the user is still authenticated with Firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        // Call your routeUser method here (assuming it's in another class)
        RouteUsers.routes(context, uid);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

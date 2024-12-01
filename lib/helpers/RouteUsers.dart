import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteUsers {
  static String staffRole = "";
  static Future<void> routes(BuildContext context, String? uid) async {
    if (uid == null) return; // Ensure UID is not null

    // Query the student collection
    final studentQuery =
        FirebaseFirestore.instance.collection('student').doc(uid);
    DocumentSnapshot studentSnapshot = await studentQuery.get();

    if (studentSnapshot.exists) {
      // If the user is a student, navigate to student home
      context.goNamed('/studenthome');
    } else {
      // Otherwise, query the staff collection
      final staffQuery =
          FirebaseFirestore.instance.collection('staff').doc(uid);
      DocumentSnapshot staffSnapshot = await staffQuery.get();

      if (staffSnapshot.exists) {
        // Get the role from the document
        staffRole = staffSnapshot['role'];
        // Update the value

        // Route based on the role
        navigateBasedOnRole(context, staffRole);
      }
    }
  }
}

class LoginChecker {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static User? user = FirebaseAuth.instance.currentUser;
  static Future<void> checker(BuildContext context) async {
    bool loggedIn = await LoginChecker.isLoggedIn();
    if (loggedIn) {
      // Check if the user is still authenticated with Firebase
      //  SharedPreferences prefs = await SharedPreferences.getInstance();
       //await FirebaseAuth.instance.signOut();
      if (user != null) {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        // Call your routeUser method here (assuming it's in another class)
        RouteUsers.routes(context, uid);
      } else {
        // GoRouter.of(context).goNamed("/login");
        context.goNamed("/login");
      }
    } else {
      context.goNamed("/login");
    }
  }
}

BuildContext navigateBasedOnRole(BuildContext context, String staffRole) {
  switch (staffRole) {
    case 'Housing manager':
      context.goNamed('/manager');
      break;
    case 'Students affairs officer':
      context.goNamed('/studentsAffairs');
      break;
    case 'Resident student supervisor':
      context.goNamed('/supervisor');
      break;
    case 'Housing buildings officer':
      context.goNamed('/buildingsOfficer');
      break;
    case 'Nutrition specialist':
      context.goNamed('/nutritionSpecialist');
      break;
    case 'Social Specialist':
      context.goNamed('/socialSpecialist');
      break;
    case 'Housing security guard':
      context.goNamed('/security');
      break;
    default:
      context.goNamed('/login');
  }
  return context;
}


Future<bool> isResident() async {
  try {
    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
     
    // If no user is logged in, return false
    if (userId.isEmpty) {
      return false;
    }

    // Fetch the user's document from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('student')
        .doc(userId)
        .get();

    // Check if the document exists
    if (!userDoc.exists) {
      return false;
    }

    // Extract user data
    final userData = userDoc.data();
    final isResident = userData?['resident'] == true;
    final isCheck = userData?['checkStatus'] != 'First Check-in';

    // Return true if both conditions are met
    return isResident&&isCheck;
  } catch (e) {
    // Handle any errors (e.g., network issues)
    print("Error checking user role and status: $e");
    return false;
  }
}

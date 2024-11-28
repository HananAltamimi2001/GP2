import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class HousingServices extends StatelessWidget {
  const HousingServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Housing Services"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Service_button(
                      icon: Icons.assignment_turned_in_rounded,
                      name: "Daily Attendance",
                      onPressed: () {
                        context.pushNamed('/dailyattendance');
                      },
                    ),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                      icon: Icons.medical_services,
                      name: "Emergency Service ",
                      onPressed: () {
                        context.pushNamed('/emergencyservice');
                      },
                    ),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                        icon: Icons.chair,
                        name: "Furniture Service",
                        onPressed: () {
                          context.pushNamed('/furnitureservice');
                        }),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                        icon: Icons.construction,
                        name: "Maintenance Service",
                        onPressed: () {
                          context.pushNamed('/maintenance');
                        }),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                        icon: MdiIcons.homeExportOutline,
                        name: "Vacate Request",
                        onPressed: () async {
                          bool vacreq = await checkVacReqAndStatus();
                          print("$vacreq vvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
                          if (!vacreq) {
                            context.pushNamed('/vacate');
                          } else {
                            ErrorDialog(
                                "Sorry, you have send vacate request, you can not send another request",
                                context,
                                buttons: [
                                  {'Ok': () => context.pop()}
                                ]);
                          }
                        }),
                  ],
                ),
                Widthsizedbox(w: 0.03),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Service_button(
                        icon: MdiIcons.fileDocumentCheckOutline,
                        name: "Permission Request",
                        onPressed: () {
                          context.pushNamed('/PermissionRequest');
                        }),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                      icon: MdiIcons.silverware,
                      name: "Dining Service",
                      onPressed: () {
                        context..pushNamed('/diningservices');
                      },
                    ),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                      icon: Icons.calendar_month,
                      name: "Book Appointment",
                         onPressed: () {context.pushNamed('/BookAppointment');}
                    ),
                    Heightsizedbox(h: 0.015),
                    Service_button(
                      icon: MdiIcons.chatAlertOutline,
                      name: "Complaints",
                      onPressed: () {
                        context..pushNamed('/complaints');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Service_button extends StatelessWidget {
  const Service_button({
    super.key,
    required this.icon,
    required this.name,
    this.onPressed,
  });
  final IconData icon;
  final String name;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.20, //0.19
      width: screenHeight * 0.20, //0.20
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(children: [
        Heightsizedbox(h: 0.02),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: dark1, // Shadow color
                spreadRadius: 5, // The spread of the shadow
                blurRadius: 10, // How soft the shadow is
                offset: Offset(3, 3), // Shadow position (x, y)
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: SizeHelper.getSize(context) * 0.14,
            //shadows: [Shadow(color: dark1),BoxShadow(color: dark1, spreadRadius: 2, blurRadius: 8, ),],
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "$name",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
          ),
        ),
      ]),
    );
  }
}
Future<bool> checkVacReqAndStatus() async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    print("User ID: $userId");

    if (userId.isEmpty) {
      print("No user is logged in.");
      return false;
    }

    // Get the current user's document
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      print("User document found.");
      final data = userSnapshot.data() as Map<String, dynamic>;

      // Check if the field exists and is a reference
      if (data.containsKey('VacateHousing') &&
          data['VacateHousing'] is DocumentReference) {
        print("VacateHousing field exists and is a DocumentReference.");

        DocumentReference ref = data['VacateHousing'];

        // Get the referenced document
        DocumentSnapshot refSnapshot = await ref.get();

        if (refSnapshot.exists) {
          print("VacateHousing document exists.");
          return true;
        } else {
          print("VacateHousing document does not exist.");
        }
      } else {
        print("VacateHousing field does not exist or is not a DocumentReference.");
      }
    } else {
      print("User document does not exist.");
    }

    return false;
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

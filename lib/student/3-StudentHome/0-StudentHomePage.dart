import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';

// Defining a Stateless widget for the student home page
class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget  from  our design library
        title: "PNU Student Housing", // Setting the title of the AppBar
      ),
      body: SafeArea(
        // Ensuring the content is within the safe area (not overlapping with notches)
        child: Center(
          // Centering the content of the body
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                20.0, 80.0, 20.0, 20.0), // Padding around the content
            child: Center(
              // Centering the content of the body
              child: Column(
                // Using a column to stack buttons vertically
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centering children vertically
                children: [
                  // Home button with icon in left side from our design library for Housing Services section
                  HomeButton1(
                    icon: Icons.manage_accounts_outlined, // Icon for the button
                    name: "Housing Services", // Button text
                    onPressed: () async {
                      bool resident = await isResident();
                      if (resident) {
                        // Function to navigate to the Housing Services page when pressed
                        context.pushNamed('/housingservices');
                      } else {
                        ErrorDialog(
                            "Sorry, you can not access the housing services, since you ar not resident student",
                            context,
                            buttons: [
                              {'Ok': () => context.pop()}
                            ]);
                      }
                    },
                  ),

                  Heightsizedbox(
                      h: 0.02), // Spacer with height from our design library for separation

                  // Home button with icon in right side from our design library for About Us section
                  HomeButton2(
                      icon: Icons.info_outline, // Icon for the button
                      name: "About us", // Button text
                      onPressed: () {
                        context.pushNamed('/aboutus');
                      }),

                  Heightsizedbox(
                      h: 0.02), // Spacer with height from our design library for separation

                  // Home button with icon in left side from our design library for applying for housing
                  HomeButton1(
                    icon: MdiIcons.homeImportOutline, // Icon for the button
                    name: "Apply for housing", // Button text
                    onPressed: () async {
                      bool appreq = await checkAppReqAndStatus();
                      if (!appreq) {
                        context.goNamed('/instructions');
                      } else {
                        ErrorDialog(
                            "Sorry, you have send application request, you can not send another request",
                            context,
                            buttons: [
                              {'Ok': () => context.pop()}
                            ]);
                      }
                    },
                  ),

                  Heightsizedbox(
                      h: 0.02), // Spacer with height from our design library for separation

                  // Home button with icon in right side from our design library for Contact Us section
                  HomeButton2(
                      icon: Icons.contacts_outlined, // Icon for the button
                      name: "Contact us", // Button text
                      onPressed: () async {
                        bool resident = await isResident();
                        if (resident) {
                          context.pushNamed('/contactus');
                        } else {
                          ErrorDialog(
                              "Sorry, you can not access contact us, since you ar not resident student",
                              context,
                              buttons: [
                                {'Ok': () => context.pop()}
                              ]);
                        }
                      }),
                  Heightsizedbox(h: 0.1),

                  // Small FAQ Button at the bottom
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      //color: dark1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: dark1),
                      child: IconButton(
                        onPressed: () {
                          context.pushNamed('/FAQs');
                        },
                        icon: Icon(
                          Icons.question_mark,
                          size: 25, // Smaller icon size
                          color: Colors.white, // Icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkAppReqAndStatus() async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isEmpty) return false;

    // Get the current user's document
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('student')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      final data = userSnapshot.data() as Map<String, dynamic>;

      // Check if the field exists and is a reference
      if (data.containsKey('HousingApplicationRequest') &&
          data['HousingApplicationRequest'] is DocumentReference) {
        DocumentReference ref = data['HousingApplicationRequest'];

        // Get the referenced document
        DocumentSnapshot refSnapshot = await ref.get();

        if (refSnapshot.exists) {
          final refData = refSnapshot.data() as Map<String, dynamic>;

          // Check the status field
          return refData['status'] != 'Reject';
        }
      }
    }

    return false;
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

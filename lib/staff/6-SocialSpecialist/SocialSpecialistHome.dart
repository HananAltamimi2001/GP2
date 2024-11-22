import 'package:flutter/cupertino.dart'; /*Importing Cupertino design package
is dependency in pubspec.yaml is: cupertino_icons: ^1.0.6 */
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

// Define a StatelessWidget for the Social Specialist Home page
class SocialSpecialistHome extends StatelessWidget {
  const SocialSpecialistHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget from our design library
        title: "Social Specialis Services", // Title of  AppBar
      ),
      body: SafeArea(
        // Ensuring the content is within the safe area (not overlapping with notches)
        child: Center(
          // Centering the content of the body
          child: Column(
            // Using a column to stack buttons vertically
            mainAxisAlignment:
                MainAxisAlignment.center, // Centering children vertically
            children: [
              // Home button with icon in left side from our design library for Appointments
              HomeButton1(
                icon: Icons.calendar_month, // Icon for the button
                name: "Appointments", // Button text
              ),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for Students Files
              HomeButton2(
                icon: CupertinoIcons.doc_on_doc, // Icon for the button
                name: "Students Files", // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}

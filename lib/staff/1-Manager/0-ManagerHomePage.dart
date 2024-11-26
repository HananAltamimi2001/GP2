import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
/* Importing Material Design icons
his dependency in pubspec.yaml is:  material_design_icons_flutter: 7.0.7296*/

// Defining a Stateless widget for the Manager home page
class Managerhomepage extends StatelessWidget {
  const Managerhomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget from  our design library
        title: "Housing Manager Services", // Setting the title of the AppBar
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
              // Home button with icon in left side from our design library for Search For Student
              HomeButton1(
                  icon: Icons.search, // Icon for the button
                  name: "Search For Student", //Button text
                  onPressed: () {
                    context.pushNamed('/search1');
                  }),
              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for Complaints
              HomeButton2(
                  icon: MdiIcons.chatAlertOutline, // Icon for the button
                  name: "Complaints", //Button text
                  onPressed: () {
                    context.pushNamed('/viewstudentcomplaints');
                  }),
              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation
              // Home button with icon in left side from our design library for Appointments
              HomeButton1(
                icon: Icons.calendar_month, // Icon for the button
                name: "Appointments", //Button text
                onPressed: () {
                  context.goNamed('/Appointment');
                },
              ),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation
              // Home button with icon in left side from our design library for Appointments
              HomeButton2(
                icon: Icons.people, // Icon for the button
                name: "Add Staff", //Button text
                onPressed: () {
                  context.pushNamed('/addstaff');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

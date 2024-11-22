import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Define a StatelessWidget for the Student Affairs Home page
class StudentAffairsHome extends StatelessWidget {
  const StudentAffairsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
          // Our Custom AppBar widget from  our design library
          title: "Students Affairs Services" // Setting the title of the AppBar
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
              // Home button with icon in left side from our design library for Buildings And Rooms
              HomeButton1(
                icon: MdiIcons.homeCity, // Icon for the button
                name: "Buildings And Rooms", //Button text
              ),
              Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for Housing Vacating Requests
              HomeButton2(
                // Custom button for "Housing Vacating Requests"
                icon: MdiIcons.homeExportOutline, // Icon for the button
                name: "Housing Vacating\nRequests", // Button text
              ),
              Heightsizedbox(h: 0.02),


              HomeButton1(
                // Custom button for "Housing Application Requests"
                icon: MdiIcons.homeImportOutline, // Icon for the button
                name: "Housing Application\nRequests",
                // Button text
              ),

              Heightsizedbox(h: 0.02),

              HomeButton2(
                // Custom button for setting announcements and events
                icon: MdiIcons.bullhornOutline, // Icon for the button
                name: "Set Announcements\nAnd Events", // Button text
                onPressed: () {
                  // Function to navigate to the  SetAnnouncementsAndEvents page when pressed
                  context.goNamed('/setannouncementsandavents');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

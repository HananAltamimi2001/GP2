import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:go_router/go_router.dart';

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
          child: Column(
            // Using a column to stack buttons vertically
            mainAxisAlignment:
                MainAxisAlignment.center, // Centering children vertically
            children: [
              // Home button with icon in left side from our design library for Housing Services section
              HomeButton1(
                icon: Icons.manage_accounts_outlined, // Icon for the button
                name: "Housing Services", // Button text
                onPressed: () {
                  // Function to navigate to the Housing Services page when pressed
                  context.goNamed('/housingservices');
                },
              ),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for About Us section
              HomeButton2(
                  icon: Icons.info_outline, // Icon for the button
                  name: "About us", // Button text
                  onPressed: () {}),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in left side from our design library for applying for housing
              HomeButton1(
                icon: MdiIcons.homeImportOutline, // Icon for the button
                name: "Apply for housing", // Button text
              ),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for Contact Us section
              HomeButton2(
                icon: Icons.contacts_outlined, // Icon for the button
                name: "Contact us", // Button text
             
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Creating the state for this widget
}

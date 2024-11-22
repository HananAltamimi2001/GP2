import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
/* Importing Material Design icons
his dependency in pubspec.yaml is: material_design_icons_flutter: 7.0.7296 */

// Defining a Stateless widget for the buildings Officer Home page
class buildingsOfficerHome extends StatelessWidget {
  const buildingsOfficerHome({super.key});

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
              // Home button with icon in left side from our design library for applying for Furniture Stock
              HomeButton1(
                icon: MdiIcons.archiveCogOutline, // Icon for the button
                name: "Manage Furniture Stock", //Button text
                onPressed: (){context.pushNamed('/viewfurniturestock');},
              ),
              Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

              HomeButton2(
                icon:  MdiIcons.archiveEyeOutline, // Icon for the button
                name: "View Furniture Stock", // Button text
                onPressed: (){context.pushNamed('/ManageFurnitureStock');},
              ),

              Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

              HomeButton1(
                icon: Icons.chair, // Icon for the button
                name: "Furniture Services\nRequests", //Button text
                onPressed: (){context.pushNamed('/viewfurnitureservicerequests');},
              ),

            ],
          ),
        ),
      ),
    );
  }
}

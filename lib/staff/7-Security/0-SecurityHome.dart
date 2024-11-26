import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

// Defining a Stateless widget for the Security Home page
class SecurityHome extends StatelessWidget {
  const SecurityHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Building the main scaffold of the page
      appBar: OurAppBar(
          // Custom AppBar widget from our design library
          title: "Housing Security Services" // Setting the title of the AppBar
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
                  icon: Icons.search,
                  name: "Search For Student",
                  onPressed: () {
                    context.pushNamed('/search3');
                  }),

              Heightsizedbox(
                  h: 0.02), // Spacer with height from our design library for separation

              // Home button with icon in right side from our design library for Check in/out Scanner
              HomeButton2(
                  icon: Icons.qr_code_scanner,
                  name: "Check in/out Scanner",
                  onPressed: () {
                    context.goNamed('/checkinout');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

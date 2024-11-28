import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

//import 'ViewDailyAttendance.dart';

class SupervisorHome extends StatefulWidget {
  const SupervisorHome({super.key});

  @override
  State<SupervisorHome> createState() => _SupervisorHomeState();
}

class _SupervisorHomeState extends State<SupervisorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Supervisor Services"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home button with icon in left side from our design library for Search for Student
                HomeButton1(
                    icon: Icons.search, // Icon for the button
                    name: "Search for Student", //Button text
                    onPressed: () {
                      context.pushNamed('/search2');
                    }),
                Heightsizedbox(
                    h: 0.02), // Spacer with height from our design library for separation
                // Home button with icon in right side from our design library for View Daily Attendance
                HomeButton2(
                    icon: Icons
                        .assignment_turned_in_rounded, // Icon for the button
                    name: "View Daily Attendance", //Button text
                    onPressed: () {
                      context.pushNamed('/viewdailyattendance');
                    } // Function to navigate to the View Daily Attendance page when pressed

                    ),
                Heightsizedbox(
                    h: 0.02), // Spacer with height from our design library for separation
                // Home button with icon in left side from our design library for Room Key Management
                HomeButton1(
                  icon: MdiIcons.keyChain, // Icon for the button
                  name: "Room Key Management", //Button text
                  onPressed: () {
                    context.pushNamed('/roomKey');
                  },
                ),
                Heightsizedbox(
                    h: 0.02), // Spacer with height from our design library for separation
                // Home button with icon in right side from our design library for Permission Request
                HomeButton2(
                  icon:
                      MdiIcons.fileDocumentCheckOutline, // Icon for the button
                  name: "Permission Request", //Button text
                  onPressed: () {
                    context.pushNamed('/superpermrequests');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

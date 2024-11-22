import 'package:flutter/material.dart';  // Importing Flutter's material package for UI components
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:pnustudenthousing/helpers/Design.dart';// Importing our design library


// Stateless widget to represent the Set Announcements and Events page
class SetAnnouncementsAndEvents extends StatelessWidget {
  const SetAnnouncementsAndEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea( // Ensuring the content is within the safe area (not overlapping with notches)
      child: Center(
        child: Scaffold(
          appBar: OurAppBar(// Our Custom AppBar widget  from  our design library
            title: "Set Announcements And Events", // Setting the title of the AppBar
          ),
          // Column to layout buttons for setting announcements and events
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centering the buttons vertically
            children: [
              // PagesButton from  our design library to navigate to the set Announcement page
              PagesButton(
                  name: "Set Announcements",  // Button label
                  onPressed: () {
                    // Function to navigate to the set Announcement page when pressed
                   context.pushNamed('/setannouncement');
                  }
              ),
              Heightsizedbox(h: 0.02),  // Spacer with height from our design library for separation

              PagesButton(
                  name: "Set Events",  // Button label
                  onPressed: () {
                    // Function to navigate to the Set Event page when pressed
                    context.pushNamed('/setevent');
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

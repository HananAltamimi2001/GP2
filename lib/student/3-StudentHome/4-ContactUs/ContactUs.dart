import 'package:flutter/material.dart'; // Importing Flutter's material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';// Importing our design library


// Defining a Stateless widget for the Contact Us page
class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: OurAppBar( // Our Custom AppBar widget  from  our design library
        title: "Contact us", // Setting the title of the AppBar
      ),
      body: SafeArea( // SafeArea ensures the UI doesn't overlap with system UI components
        child: Center( // Center widget centers its child widgets
          child: Column( // Using a column to stack buttons vertically
            mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
            children: [
              // PagesButton from  our design library to navigate to the Housing Staff page
              PagesButton(
                  name: "Housing Staff",
                  onPressed: () { context.pushNamed('/housingstaff');}
              ),
              Heightsizedbox(h: 0.02),// Spacer with height from our design library for separation

              // PagesButton from  our design library to navigate to the App Developers page
              PagesButton(
                  name: "App developers",
                  onPressed: () { context.pushNamed('/appdevelopers');}),
            ],
          ),
        ),
      ),
    );
  }
}

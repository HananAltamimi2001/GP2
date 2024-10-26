import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing Flutter's material design package


// Defining a Stateless widget for the Set Menus page
class SetMenus extends StatelessWidget {
  const SetMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: OurAppBar( // Our Custom AppBar widget  from  our design library
        title: "Set Menus", // Setting the title of the AppBar
      ),
      body: SafeArea( // SafeArea ensures the UI doesn't overlap with system UI components
        child: Center( // Center widget centers its child widgets
          child: Column( // Using a column to stack buttons vertically
            mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
            children: [
              // PagesButton from  our design library to navigate to the Lunch page
              PagesButton(
                name: "Lunch",
              ),

              Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

              // PagesButton from  our design library to navigate to the Dinner page
              PagesButton(
                name: "Dinner",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart'; // Importing Flutter's material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';// Importing our design library


// Defining a Stateless widget for the Furniture Service page
class FurnitureService extends StatelessWidget {
  const FurnitureService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: OurAppBar( // Our Custom AppBar widget  from  our design library
        title: "Furniture Service", // Setting the title of the AppBar
      ),
      body: SafeArea( // SafeArea ensures the UI doesn't overlap with system UI components
        child: Center( // Center widget centers its child widgets
          child: Column( // Using a column to stack buttons vertically
            mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
            children: [
              // PagesButton from  our design library to navigate to the Request And Return Furniture page
              PagesButton(
                  name: "Request And Return Furniture",
                  onPressed: () { context.pushNamed('/RequestAndReturnFurniture');}
              ),

              Heightsizedbox(h: 0.02),// Spacer with height from our design library for separation

              // PagesButton from  our design library to navigate to the View Furniture Request Status page
              PagesButton(
                  name: "View Furniture Requests",
                  onPressed: () { context.pushNamed('/ViewFurnitureRequests');}),
            ],
          ),
        ),
      ),
    );
  }
}

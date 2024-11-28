import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package to interact with Firebase Cloud Firestore for data storage and retrieval.
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';// Importing our design library


class AppDevelopers extends StatefulWidget {
  const AppDevelopers({super.key});

  @override
  State<AppDevelopers> createState() => _AppDevelopersState();
}

class _AppDevelopersState extends State<AppDevelopers> {
  // The AppDevelopers widget renders another widget 'develobers'
  @override
  Widget build(BuildContext context) {
    return develobers();
  }
}

class develobers extends StatefulWidget {
  const develobers({super.key});

  @override
  State<develobers> createState() => _develobersState();
}

class _develobersState extends State<develobers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance to interact with the database
  bool _isLoading = true; // Loading state to show progress indicator while fetching data

  // Variables to store developer names and emails fetched from Firestore
  String _name1 = " ";
  String _mail1 = " ";
  String _name2 = " ";
  String _mail2 = " ";
  String _name3 = " ";
  String _mail3 = " ";
  String _name4 = " ";
  String _mail4 = " ";
  String _name5 = " ";
  String _mail5 = " ";

  @override
  void initState() {
    super.initState();
    _fetchdata(); // Fetch data from Firestore when the widget is initialized
  }

  // Function to fetch data from Firestore
  Future<void> _fetchdata() async {
    try {
      // Reference the document from the Firestore collection 'StudentHousing'
      DocumentSnapshot document = await _firestore
          .collection('StudentHousing')
          .doc('appdevelopers')
          .get();

      // Check if the document exists and extract the names and emails
      if (document.exists) {
        setState(() {
          _name1 = document['name1'];
          _mail1 = document['mail1'];
          _name2 = document['name2'];
          _mail2 = document['mail2'];
          _name3 = document['name3'];
          _mail3 = document['mail3'];
          _name4 = document['name4'];
          _mail4 = document['mail4'];
          _name5 = document['name5'];
          _mail5 = document['mail5'];
          _isLoading = false; // Set loading state to false when data is fetched
        });
      } else {
        ErrorDialog("Document not found!", context, buttons: [
          {"OK": () async => context.pop()},
        ]);
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      // Handle any errors that occur during data fetching
      ErrorDialog("Error: $e", context, buttons: [
        {"OK": () async => context.pop()},
      ]);
      setState(() {
        _isLoading = false;
      });
    }
  }
  // A reusable function that returns a Row for displaying a developer's info
  Widget buildDeveloperRow({
    required String imagePath,
    required String name,
    required String email,
    required BuildContext context, // Add context as a required parameter
  }) {
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Row(
      children: [
        Widthsizedbox(w: 0.012), // Adds spacing on the left
        Image.asset(
          imagePath, // The path to the developer's image
          height: screenHeight * 0.09, // Set the height of the image
        ),
        Widthsizedbox(w: 0.01), // Adds spacing between the image and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start
          children: [
            Heightsizedbox(h: 0.04), // Adds vertical space above the name
            Dtext(
              // Displays the developer's name
              t: name,
              align: TextAlign.start,
              color: Colors.white,
              size: 0.035,
            ),
            Dtext(
              // Displays the developer's email
              t: email,
              align: TextAlign.start,
              color: Colors.white,
              size: 0.035,
            ),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: OurAppBar(// Our Custom AppBar widget  from  our design library
        title: "App developers", // Setting the title of the AppBar
      ),
      body: Center(
        child: _isLoading
            ?  OurLoadingIndicator() // Show loading spinner while fetching data
            : Container(
            height: screenHeight * 0.70, // Set the height of the container
            width: screenWidth * 0.90, // Set the width of the container
            decoration: BoxDecoration(
              color: light1.withOpacity(0.7), // Set container color with opacity
              borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
              children: [
                // Call the buildDeveloperRow for each developer
                buildDeveloperRow(
                  imagePath: "assets/developer.png",
                  name: _name1,
                  email: _mail1,
                  context: context,
                ),
                Heightsizedbox(h: 0.03), // Spacer with height from our design library for separation
                buildDeveloperRow(
                  imagePath: "assets/developer.png",
                  name: _name2,
                  email: _mail2,
                  context: context,
                ),
                Heightsizedbox(h: 0.03), // Spacer with height from our design library for separation
                buildDeveloperRow(
                  imagePath: "assets/developer.png",
                  name: _name3,
                  email: _mail3,
                  context: context,
                ),
                Heightsizedbox(h: 0.03), // Spacer with height from our design library for separation
                buildDeveloperRow(
                  imagePath: "assets/developer.png",
                  name: _name4,
                  email: _mail4,
                  context: context,
                ),
                Heightsizedbox(h: 0.03), // Spacer with height from our design library for separation
                buildDeveloperRow(
                  imagePath: "assets/developer.png",
                  name: _name5,
                  email: _mail5,
                  context: context,
                ),
              ],
            )),
      ),
    );
  }
}

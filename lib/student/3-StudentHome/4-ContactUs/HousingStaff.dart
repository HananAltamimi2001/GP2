import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore to interact with Firebase Cloud Firestore
import 'package:flutter/material.dart'; // Importing Flutter's material package for UI components
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Stateful widget to represent the housing staff page
class Housingstaff extends StatefulWidget {
  const Housingstaff({super.key});

  @override
  State<Housingstaff> createState() => _HousingstaffState();
}

class _HousingstaffState extends State<Housingstaff> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance to fetch data from Firebase
  List<Map<String, dynamic>> announcements = []; // Placeholder list to hold announcements if needed in the future
  String message = ""; // Variable to hold status or error messages
  bool _isLoading = true; // Loading indicator to show when data is being fetched
  String email = " "; // Variable to hold the email fetched from Firestore
  String phone = " "; // Variable to hold the phone number fetched from Firestore
  String Telephone = " "; // Variable to hold the telephone number fetched from Firestore
  String OfficeNumper = " "; // Variable to hold the office number fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchdata(); // Call function to fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get the width of the screen for responsive design

    return Scaffold(
      appBar: OurAppBar( // Our Custom AppBar widget  from  our design library
        title: "Housing Staff", // Setting the title of the AppBar
      ),
      body: SafeArea(// Ensuring the content is within the safe area (not overlapping with notches)
        child: _isLoading
            ?  OurLoadingIndicator() // Show a loading spinner if data is still being fetched
            : SingleChildScrollView(
          // Scrollable view to hold staff members' cards
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
              children: [
                Dtext(
                  // Display title for housing manager section
                  t: 'Housing Manager',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for housing manager
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
                Dtext(
                  // Display title for financial department section
                  t: 'Financial department',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for financial department
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
                Dtext(
                  // Display title for student affairs department
                  t: 'Students affairs department',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for student affairs department
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
                Dtext(
                  // Display title for housing buildings officer
                  t: 'Housing buildings officer',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for housing buildings officer
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
                Dtext(
                  // Display title for nutrition specialist
                  t: 'Nutrition Specialist',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for nutrition specialist
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
                Dtext(
                  // Display title for social specialist
                  t: 'Social Specialist',
                  color: dark1,
                  align: TextAlign.start,
                  size: 0.05,
                  fontWeight: FontWeight.w600,
                ),
                // Display card for social specialist
                StaffMemberCard(
                  email: email,
                  phone: phone,
                  telephone: Telephone,
                  officeNumber: OfficeNumper,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Function to fetch staff data from Firestore
Future<void> _fetchdata() async {
  try {
    // Fetch document from Firestore
    DocumentSnapshot document = await _firestore
        .collection('StudentHousing')
        .doc('Housing Staff')
        .get();

    // Check if the document exists and extract the fields
    if (document.exists) {
      setState(() {
        email = document["E-mail"]; // Assign the email field to the local variable
        phone = document["phone"]; // Assign the phone field to the local variable
        Telephone = document["Telephone"]; // Assign the telephone field to the local variable
        OfficeNumper = document["Office Numper"]; // Assign the office number field to the local variable
        message = ""; // Clear any message since data is successfully fetched
        _isLoading = false; // Data fetching complete, turn off loading
      });
    } else {
      setState(() {
        message = "Document not found!"; // Show an error if the document doesn't exist
        _isLoading = false; // Stop loading as data fetching is done
      });
    }
  } catch (e) {
    // Handle any errors that occur during fetching
    setState(() {
      message = "Error: $e"; // Display error message
      _isLoading = false; // Stop loading due to error
     });
   }
 }
}

// Widget to display staff member's details in a card
class StaffMemberCard extends StatelessWidget {
  const StaffMemberCard({
    super.key,
    required this.email,        // Staff member's email
    required this.phone,        // Staff member's phone number
    required this.telephone,    // Staff member's telephone number
    required this.officeNumber, // Staff member's office number
  });

  final String email;           // Email of the staff member
  final String phone;           // Phone number of the staff member
  final String telephone;       // Telephone number of the staff member
  final String officeNumber;    // Office number of the staff member

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7), // Add vertical margin to the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the card content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            // Display email
            RowInfo.buildInfoRow(
              defaultLabel: 'E-mail',
              value: email,),

            Heightsizedbox(h: 0.01), // Vertical spacing

            // Display phone
            RowInfo.buildInfoRow(
              defaultLabel: 'Phone',
              value: phone,),

            Heightsizedbox(h: 0.01), // Vertical spacing

            // Display telephone
                RowInfo.buildInfoRow(
                  defaultLabel: 'Telephone',
                  value: telephone,),
            Heightsizedbox(h: 0.01), // Vertical spacing

            // Display office number
            RowInfo.buildInfoRow(
              defaultLabel: 'Office Number',
              value: officeNumber,),

          ],
        ),
      ),
    );
  }
}



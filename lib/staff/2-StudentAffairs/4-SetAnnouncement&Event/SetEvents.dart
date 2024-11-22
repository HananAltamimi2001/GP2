import 'dart:io'; // Importing Dart's IO library to handle file operations (e.g., for uploading images)
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package to interact with the Firestore database
import 'package:firebase_storage/firebase_storage.dart'; // Importing Firebase Storage package to upload and manage files in Firebase Storage
import 'package:flutter/material.dart'; // Importing Flutter's material design package for UI components
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Defining a Stateful widget for setting or creating events
class SetEvent extends StatefulWidget {
  @override
  _SetEventState createState() =>
      _SetEventState(); // Creating the state for this stateful widget.
}

class _SetEventState extends State<SetEvent> {
  final formKey = GlobalKey<FormState>(); // Form key to validate the form.
  DateTime? selectedDate; // Variable to store the selected date for the event.
  TimeOfDay? selectedTime; // Variable to store the selected time for the event.
  File? image; // Variable to store the uploaded image.
  DateTime? uploadDate;
  TextEditingController Enamecontroller =
      TextEditingController(); // Controller for the event name.
  TextEditingController EDescriptioncontroller =
      TextEditingController(); // Controller for the  event description.
  TextEditingController Elocationcontroller =
      TextEditingController(); // Controller for the event location.


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget  from  our design library
        title: "Set Even", // Setting the title of the AppBarOurAppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding around the form
            child: Form(
              key: formKey, // Form key for validation and state management
              child: Column(
                children: [
                  // Input text form field for the event name from our Design library
                  textform(
                    controller: Enamecontroller,
                    hinttext: "Event Name",
                    lines: 1,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please write Event name";
                      }
                      return null;
                    },
                  ),

                  Heightsizedbox(h: 0.02), // Add vertical spacing using a custom spacer from the design library

                  // Input text form field for the Event Description  from our Design library
                  textform(
                    controller: EDescriptioncontroller,
                    hinttext: "Event Description",
                    lines: 5,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please Write Event Description";
                      }
                      return null;
                    },
                  ),

                  Heightsizedbox(h: 0.02),

                  // Input text form field for the event location from our Design library
                  textform(
                    controller: Elocationcontroller,
                    hinttext: "Event Location",
                    lines: 1,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please Write Event Location"; // Displays this error if field is empty
                      }
                      return null; // No error if the input is valid
                    },
                  ),

                  Heightsizedbox(h: 0.02),

                  //Input field for uploading an image from our design library
                  OurFormField(
                    fieldType: 'image',
                    imageFile: image,
                    onPickImage: () async {
                      final File? pickimage = await pickImage(context);
                      if (pickimage != null) {
                        setState(() {
                          image = pickimage; // Update the selected date
                        });
                      }
                    },
                    labelText: "Upload Picture:",
                  ),

                  Heightsizedbox(h: 0.02),

                  // Input field for selecting a date from our design library
                  OurFormField(
                    fieldType: 'date',
                    selectedDate: selectedDate,
                    onSelectDate: () async {
                      final DateTime? pickedDate = await pickDate(context);
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate; // Update the selected date
                        });
                      }
                    },
                    labelText: "Select Date:",
                  ),

                  Heightsizedbox(h: 0.02),

                  // Input field for selecting a time from our design library
                  OurFormField(
                    fieldType: 'time',
                    selectedTime: selectedTime,
                    onSelectTime: () async {
                      final TimeOfDay? pickedTime = await pickTime(context);
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime; // Update the selected time
                        });
                      }
                    },
                    labelText: "Select Time:",
                  ),

                  Heightsizedbox(h: 0.018),
                  // Row containing the submit button aligned to the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // Align button to the end of the row
                    children: [
                      // use  custom button for action such as set from our design library
                      actionbutton(
                        onPressed: _uploadData,
                        background: dark1,
                        text: 'Set',
                        fontsize: 0.047,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Method to upload event data and the image to Firebase.
  Future<void> _uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Saving the form data.
      String? imageUrl; // URL for the uploaded image.
      if (image != null) {
        // If an image is selected, upload it to Firebase Storage.
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('events/${Enamecontroller.text}.png');
        await storageRef.putFile(image!); // Uploading the image file.
        imageUrl = await storageRef
            .getDownloadURL(); // Getting the download URL of the uploaded image.
      }

      String docId = Enamecontroller.text; // Document ID for Firestore .

      // Saving the event data to Firebase Firestore.
      await FirebaseFirestore.instance.collection('events').doc(docId).set({
        'eventName': Enamecontroller.text,
        'eventDescription': EDescriptioncontroller.text,
        'location': Elocationcontroller.text,
        'date': selectedDate,
        'time': selectedTime?.format(context), // Storing the formatted time.
        'imageUrl': imageUrl, // Storing the image URL if available.
        'uploadDate': DateTime.now(),
      });

      // Clear the input field after submission
      Enamecontroller.clear();
      EDescriptioncontroller.clear();
      Elocationcontroller.clear();

      // Clear the image  , selectedDate , selectedTime and update the UI.
      setState(() {
        image = null;
        selectedDate = null;
        selectedTime = null;
      });

      // Showing a confirmation message after a successful upload.
      InfoDialog("Event created successfully", context, buttons: [
        {
          "OK": () async => context.pop(),
        }
      ]);
    }
  }
}

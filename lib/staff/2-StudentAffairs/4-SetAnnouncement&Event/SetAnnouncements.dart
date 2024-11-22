import 'dart:io'; // Importing Dart's IO library to handle file operations (e.g., for uploading images)
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package to interact with the Firestore database
import 'package:firebase_storage/firebase_storage.dart'; // Importing Firebase Storage package to upload and manage files in Firebase Storage
import 'package:flutter/material.dart'; // Importing Flutter's material design package for UI components
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Defining a Stateful widget for setting or creating announcements
class setAnnouncement extends StatefulWidget {
  const setAnnouncement({super.key});

  @override
  State<setAnnouncement> createState() => _setAnnouncementState();
}

class _setAnnouncementState extends State<setAnnouncement> {
  final formKey = GlobalKey<FormState>(); // Form key to validate the form.
  TextEditingController AnnouncementTitle =
      TextEditingController(); // Controller for the Announcement Title.
  TextEditingController AnnouncementDescription =
      TextEditingController(); // Controller for the Announcement description.
  File? image; // Variable to store the uploaded image.
  DateTime? uploadDate;

  @override
  // Design the page for setting an Announcement
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        // Our Custom AppBar widget  from  our design library
        title: "Set Announcement", // Setting the title of the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around the form
        child: Form(
          key: formKey, // Form key for validation and state management
          child: Column(
            children: [
              // Input text form field for the Announcement Title from our Design library
              textform(
                controller: AnnouncementTitle,
                hinttext: "Announcement title",
                lines: 1,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please Write Announcement title";
                  }
                  return null;
                },
              ),
              Heightsizedbox(
                  h: 0.02), // Add vertical spacing using a custom spacer from our design library

              // Input text form field for the Announcement description from our Design library
              textform(
                controller: AnnouncementDescription,
                hinttext: "Announcement Description",
                lines: 5,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please Write Announcement Description";
                  }
                  return null;
                },
              ),

              Heightsizedbox(h: 0.02),

              // Row for uploading an image
              Row(
                children: [
                  Text("Upload Picture:",
                      style: TextStyle(
                        color: dark1,
                        fontSize: 16,
                      )), // Label for image upload
                  Widthsizedbox(
                      w: 0.02), // Add horizontal spacing using a custom spacer from the design library

                  image == null
                      ? actionbutton(
                          onPressed: () async {
                            final File? pickimage = await pickImage(
                                context); // the pickImage(context) it`s the function in the bellow (20 in this Design file)
                            if (pickImage != null) {
                              setState(() {
                                image = pickimage; // Update the selected date
                              });
                            }
                          },
                          background: dark1,
                          text: 'Upload',
                          fontsize: 0.03)
                      : Image.file(image!,
                          width: MediaQuery.of(context).size.width *
                              0.2, //adjust the width
                          height: MediaQuery.of(context).size.height *
                              0.2) // Show selected image if available
                ],
              ),
              Heightsizedbox(h: 0.02),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align button to the end of the row
                children: [
                  // use  custom button for action such as set from our design library
                  actionbutton(
                      onPressed: _uploadData,
                      background: dark1,
                      text: 'Set',
                      fontsize: 0.047),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to upload Announcement data and the image to Firebase.
  Future<void> _uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Saving the form data.

      String? imageUrl; // URL for the uploaded image.
      if (image != null) {
        // If an image is selected, upload it to Firebase Storage.
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Announcements/${AnnouncementTitle.text}.png');
        await storageRef.putFile(image!); // Uploading the image file.
        imageUrl = await storageRef
            .getDownloadURL(); // Getting the download URL of the uploaded image.
      }

      String docId = AnnouncementTitle.text; // Document ID for Firestore .

      // Saving the Announcement data to Firebase Firestore.
      await FirebaseFirestore.instance
          .collection('Announcements')
          .doc(docId)
          .set({
        'AnnouncementTitle': AnnouncementTitle.text,
        'AnnouncementDescription': AnnouncementDescription.text,
        'imageUrl': imageUrl, // Storing the image URL if available.
        'uploadDate': DateTime.now(),
      });

      // Clear the input field after submission
      AnnouncementTitle.clear();
      AnnouncementDescription.clear();

      // Clear the image file and update the UI.
      setState(() {
        image = null;
      });

      // Showing a confirmation message after a successful upload.
      InfoDialog(
        "Announcement created successfully",
        context,
        buttons: [
          {
            "OK": () async => context.pop(),
          },
        ],
      );
    }
  }
}

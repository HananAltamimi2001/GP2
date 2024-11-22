import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:pnustudenthousing/helpers/Design.dart';// Importing our design library

// A stateless widget that displays the details of an Announcement
class AnnouncementsDetails extends StatelessWidget {
  final announcementData args;

  const AnnouncementsDetails({super.key, required this.args}); // Constructor to accept the announcement data

  @override
  Widget build(BuildContext context) {
    // Get screen height to adjust UI elements based on screen size
    double screenHeight = MediaQuery.of(context).size.height;
    final Map<String, dynamic> Announcement = args.Announcement;

    return Scaffold(
      // Custom AppBar from our design library, displaying the Announcement Title as the title
      appBar: OurAppBar(
         title: Announcement['AnnouncementTitle'] ?? 'Announcements Details',
      ),
      body: Padding(
        // Adds padding around the content of the page for spacing
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Aligns widgets to the center of the column horizontally
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GestureDetector to allow image tap functionality
            GestureDetector(
              onTap: () {
                // Show the image in a dialog (full-screen image) when tapped
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close the dialog on tap
                      },
                      child: Image.network(
                        Announcement['imageUrl'] ?? '', // Load image from the URL or show nothing if URL is null
                        fit: BoxFit.contain, // Image will fit inside the container with original aspect ratio
                        errorBuilder: (context, error, stackTrace) =>
                         Icon(Icons.image, size: screenHeight * 0.2), // Show a default icon if image loading fails
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                // Display the image in the announcement body
                Announcement['imageUrl'] ?? '', // Load the image URL, or show nothing if URL is null
                height: screenHeight * 0.2, // Set a fixed height for the image
                width: double.infinity, // Make the image span the full width of the screen
                fit: BoxFit.cover, // Cover the container, cropping if necessary
                errorBuilder: (context, error, stackTrace) =>
                 Icon(Icons.image, size: screenHeight * 0.2,), // Show an icon if image fails to load
              ),
            ),

            // Adds vertical spacing using a custom height spacer from our design library
            Heightsizedbox(h: 0.02),

            // Displays Announcement description using a custom sized text widget from our design library
            text(
              t:  Announcement['AnnouncementDescription'] ?? 'Announcement Description',
              color: light1,
              align: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

class announcementData {
  final Map<String, dynamic> Announcement;
  announcementData({
    required this.Announcement,
  });
}
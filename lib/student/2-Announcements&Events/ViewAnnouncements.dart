import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/AnnouncementsDetails.dart'; // Importing our design library

// Defining a Stateless widget for the View Announcements page
class ViewAnnouncements extends StatelessWidget {
  // A list of announcements, each represented as a map containing details such as title, description, and image URL
  final announcementList args;

  // Constructor that accepts 'announcements' data and a super key
  const ViewAnnouncements({super.key, required this.args});


  @override
  Widget build(BuildContext context) {
    // Get screen width and height to adjust UI elements based on screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> announcements = args.Announcements ;
    return Scaffold(
      // Custom AppBar from our design library, setting the title as 'All Announcements'
      appBar: OurAppBar(title: 'All Announcements'),
      // Check if there are announcements to display, otherwise show a message
      body: announcements.isEmpty
          ? Center(
        // Display text message when there are no announcements
        child: text(
          t: 'There are no announcements.',
          color: grey1, // Custom grey color
          align: TextAlign.center, // Center align the text
        ),
      )
          : ListView.builder(
        // Build a list of announcements if available
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the AnnouncementsDetails page with the announcement data when tapped
              context.pushNamed(
                '/announcementsdetails',
                extra: announcementData(
                    Announcement: announcement
                ),
              );
            },
            // Display each announcement in a card
            child: Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16), // Setting margin around the Card widget
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding inside the card for inner content spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligning child widgets to the start (left) of the column
                  children: [
                    // Display the announcement image; uses fallback icon if image fails
                    Image.network(
                      announcement['imageUrl'] ?? '',
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      fit: BoxFit.cover, // Ensures the image covers its bounding box
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image,
                        size: screenHeight * 0.2, // Fallback icon size
                      ),
                    ),
                    // Add vertical spacing using a custom spacer from the design library
                    Heightsizedbox(h: 0.01),

                    // Display the announcement title using a custom text widget from our design library
                    text(
                      t: announcement['AnnouncementTitle'] ??
                          'Announcement title',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Align text to the start
                    ),

                    // Add small vertical spacing using a custom spacer from the design library
                    Heightsizedbox(h: 0.001),

                    // Display announcement description using a custom dynamic text widget from our design library
                    Dtext(
                      t: announcement['AnnouncementDescription'] ??
                          'Announcement description',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Align text to the start
                      size: 0.04, // Custom text size
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// arguments for the route
class announcementList {
  final List<Map<String, dynamic>> Announcements;
  announcementList({
    required this.Announcements,
  });
}
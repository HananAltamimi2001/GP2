import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:intl/intl.dart'; // Importing the 'intl' package for DateFormat, which provides internationalization support
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing the 'cloud_firestore' package to interact with Firestore
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// Defining a Stateless widget for the Event Details page
class EventDetails extends StatelessWidget {
  // Event data is passed as a Map containing event details such as name, description, location, date, etc.
  final EventData args;


  // Constructor that accepts 'event' data and a super key
  const EventDetails({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    // Get screen height to adjust UI elements based on screen size
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, dynamic>event = args.Event;
    return Scaffold(
      // Custom AppBar from our design library, displaying the event name as the title
      appBar: OurAppBar(
        title: event['eventName'] ?? 'Event Details',
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
                        event['imageUrl'] ?? '', // Fetches image from URL
                        fit: BoxFit.contain, // Ensures the image is fully visible
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, size: screenHeight * 0.2), // Fallback icon if image fails to load
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                event['imageUrl'] ?? '', // Displays event image
                height: screenHeight * 0.2, // Adjusts height based on screen size
                width: double.infinity, // Full width of the parent container
                fit: BoxFit.cover, // Crops the image to fit within the given dimensions
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: screenHeight * 0.2, // Fallback icon if image fails to load
                ),
              ),
            ),

            // Adds vertical spacing using a custom height spacer from our design library
            Heightsizedbox(h: 0.02),

            // Displays event description using a custom sized text widget from our design library
            text(
              t: event['eventDescription'] ?? 'Event description',
              color: light1, // Custom color from design library
              align: TextAlign.start, // Aligns text to the start
            ),

            // Adds vertical spacing using a custom height spacer from our design library
            Heightsizedbox(h: 0.02),

            // Row to display event location, date, and time icons with text
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the row
              children: [
                // Sub-row for location details
                Row(
                  children: [
                    Icon(
                      Icons.location_on, // Location icon
                      color: dark1, // Custom dark color
                      size: SizeHelper.getSize(context) * 0.07, // Adjusts size dynamically
                    ),
                    // Displays event location text by using custom Dynamic text widget from our design library
                    Dtext(
                      t: event['location'] ?? 'Location',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Aligns text to the start
                      size: 0.046, // Custom size
                    ),
                  ],
                ),

                // Adds horizontal spacing using a custom width spacer from our design library
                Widthsizedbox(w: 0.03),

                // Sub-row for date details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month, // Calendar icon
                      color: dark1, // Custom dark color
                      size: SizeHelper.getSize(context) * 0.07, // Adjusts size dynamically
                    ),
                    // Formats and displays event date by using custom Dynamic text widget from our design library
                    Dtext(
                      t: event['date'] != null
                          ? DateFormat('yyyy-MM-dd').format((event['date'] as Timestamp).toDate())
                          : 'Date',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Aligns text to the start
                      size: 0.046, // Custom size
                    ),
                  ],
                ),

                // Adds horizontal spacing using a custom width spacer from our design library
                Widthsizedbox(w: 0.03),

                // Sub-row for time details
                Row(
                  children: [
                    Icon(
                      Icons.access_time, // Time icon
                      color: dark1, // Custom dark color
                      size: SizeHelper.getSize(context) * 0.07, // Adjusts size dynamically
                    ),
                    // Displays event time text by using custom Dynamic text widget from our design library
                    Dtext(
                      t: event['time'] ?? 'Time',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Aligns text to the start
                      size: 0.046, // Custom size
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class EventData {
  final Map<String, dynamic> Event;
  EventData({
    required this.Event,
  });
}
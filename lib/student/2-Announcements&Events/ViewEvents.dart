import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importing the 'intl' package for DateFormat, which provides internationalization support
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing the 'cloud_firestore' package to interact with Firestore
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/EventDetails.dart'; // Importing our design library

// Defining a Stateless widget for the View Events page
class ViewEvents extends StatelessWidget {
  // A list of events, each represented as a map containing details such as name, description, location, date, etc.
  final EventList args;


  // Constructor that accepts 'events' data and a super key
  const ViewEvents({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    // Get screen height to adjust UI elements based on screen size
    double screenHeight = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> events = args.Events;

    return Scaffold(
      // Custom AppBar from our design library, setting the title as 'All Events'
      appBar: OurAppBar(
        title: 'All Events',
      ),
      // Check if there are events to display, otherwise show a message
      body: events.isEmpty
          ? Center(
        // Display text message when there are no events
        child: text(
          t: 'There are no events.',
          color: grey1, // Custom grey color
          align: TextAlign.center, // Center align the text
        ),
      )
          : ListView.builder(
        // Build a list of events if available
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the EventDetails page with the event data when tapped
              context.pushNamed(
                '/eventdetails',
                extra: EventData(
                    Event: event
                ),);
            },
            // Display each event in a card
            child: Card(
              // Setting the margin around the Card widget to add vertical and horizontal spacing
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                // Padding around the child elements within the Card to create space inside the card
              child: Padding(padding: const EdgeInsets.all(16.0),

                // Arranging the child widgets in a vertical column
                child: Column(
                  // Aligning child widgets to the start (left) of the column
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the event image; uses fallback icon if image fails
                    Image.network(
                      event['imageUrl'] ?? '',
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image, size: screenHeight * 0.2),
                    ),
                    // Add vertical spacing using a custom spacer from the design library
                    Heightsizedbox(h: 0.01),
                    // Display event name using a custom sized text widget from our design library
                    text(
                      t: event['eventName'] ?? 'Event name',
                      color: dark1, // Custom dark color
                      align: TextAlign.start, // Align text to the start
                    ),
                    // Add small vertical spacing using a custom spacer from the design library
                    Heightsizedbox(h: 0.001),
                    // Display event description using a custom dynamic text widget from our design library
                    Dtext(
                      t: event['eventDescription'] ?? 'Event description',
                      color: light1, // Custom light color
                      align: TextAlign.start, // Align text to the start
                      size: 0.04, // Custom size
                    ),
                    // Add vertical spacing using a custom spacer from the design library
                    Heightsizedbox(h: 0.01),
                    // Row to display event location, date, and time icons with text
                    Row(
                      children: [
                        Icon(Icons.location_on, color: dark1), // Location icon
                        // Add horizontal spacing using a custom spacer from the design library
                        Widthsizedbox(w: 0.01),
                        // Display location text using a dynamic text widget from our design library
                        Dtext(
                          t: event['location'] ?? 'Location',
                          color: light1, // Custom light color
                          align: TextAlign.start, // Align text to the start
                          size: 0.03, // Custom size
                        ),
                        // Add wider horizontal spacing using a custom spacer from the design library
                        Widthsizedbox(w: 0.04),

                        Icon(Icons.calendar_month, color: dark1), // Calendar icon

                        Widthsizedbox(w: 0.01), // Add horizontal spacing using a custom spacer from the design library
                        // Display formatted event date using a dynamic text widget from our design library
                        Dtext(
                          t: event['date'] != null
                              ? DateFormat('yyyy-MM-dd').format((event['date'] as Timestamp).toDate())
                              : 'Date',
                          color: light1,
                          align: TextAlign.start,
                          size: 0.03,
                        ),

                        Widthsizedbox(w: 0.04), // Add wider horizontal spacing using a custom spacer from the design library

                        Icon(Icons.access_time, color: dark1), // Time icon

                        Widthsizedbox(w: 0.01), // Add horizontal spacing using a custom spacer from the design library
                        // Display event time text using a dynamic text widget from our design library
                        Dtext(
                          t: event['time'] ?? 'Time',
                          color: light1,
                          align: TextAlign.start,
                          size: 0.03,
                        ),
                      ],
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
class EventList {
  final List<Map<String, dynamic>> Events;
  EventList({
    required this.Events,
  });
}
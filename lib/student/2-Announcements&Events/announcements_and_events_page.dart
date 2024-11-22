import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package to interact with the database
import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importing intl package for date formatting
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/AnnouncementsDetails.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/EventDetails.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/ViewAnnouncements.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/ViewEvents.dart';// Importing our design library

// Defining a Stateful widget for displaying Announcements and Events
class AnnouncementsAndEvents extends StatefulWidget {
  const AnnouncementsAndEvents({super.key});

  @override
  State<AnnouncementsAndEvents> createState() => _AnnouncementsAndEventsState();
}

class _AnnouncementsAndEventsState extends State<AnnouncementsAndEvents> {
  // Lists to store announcements and events data fetched from Firestore
  List<Map<String, dynamic>> announcements = [];
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _deleteOldAnnouncements(); // Automatically delete old announcements
    _DeleteExpiredEvents(); // Automatically delete expired events
    _fetchAnnouncements(); // Fetch current announcements
    _fetchEvents(); // Fetch current events
  }

  // Function to delete announcements older than 3 days from Firestore
  Future<void> _deleteOldAnnouncements() async {
    try {
      final now = DateTime.now(); // Get the current date and time

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Annoucements')
          .get(); // Fetch all announcements

      for (var doc in querySnapshot.docs) {
        final announcementData = doc.data();
        if (announcementData['uploadDate'] != null) {
          // Check if the upload date exists
          DateTime uploadDate =
              (announcementData['uploadDate'] as Timestamp).toDate();
          final difference = now.difference(uploadDate).inDays;
          if (difference > 3) {
            // Delete announcements older than 3 days
            await FirebaseFirestore.instance
                .collection('Annoucements')
                .doc(doc.id)
                .delete();
            print('Deleted announcement older than 3 days: ${doc.id}');
          }
        }
      }
    } catch (e) {
      print(
          'Error deleting old announcements: $e'); // Log any errors that occur
    }
  }

  // Function to fetch announcements from Firestore and store them in a list
  Future<void> _fetchAnnouncements() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Annoucements')
          .orderBy("uploadDate", descending: true)
          .get(); // Fetch announcements ordered by upload date
      announcements = querySnapshot.docs.map((doc) => doc.data()).toList();

      setState(() {}); // Update UI with fetched data
    } catch (e) {
      print('Error fetching announcements: $e'); // Log any errors that occur
    }
  }

  // Function to delete expired events from Firestore
  Future<void> _DeleteExpiredEvents() async {
    try {
      final now = DateTime.now(); // Get the current date and time

      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .get(); // Fetch all events

      for (var doc in querySnapshot.docs) {
        final eventData = doc.data();
        if (eventData['eventDate'] != null) {
          // Check if the event date exists
          DateTime eventDate = (eventData['eventDate'] as Timestamp).toDate();
          if (eventDate.isBefore(now)) {
            // Delete events that have already occurred
            await FirebaseFirestore.instance
                .collection('events')
                .doc(doc.id)
                .delete();
            print('Deleted expired event: ${doc.id}');
          }
        }
      }
    } catch (e) {
      print('Error deleting expired events: $e'); // Log any errors that occur
    }
  }

  // Function to fetch events from Firestore and store them in a list
  Future<void> _fetchEvents() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .orderBy("uploadDate", descending: true)
          .get(); // Fetch events ordered by upload date
      events = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {}); // Update UI with fetched data
    } catch (e) {
      print('Error fetching events: $e'); // Log any errors that occur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar from our design library with title 'Announcements & Events'
      appBar: OurAppBar(
        title: 'Announcements & Events',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Padding around the main content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align widgets to the start of the column
            children: [
              // Announcements Section
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between text and button
                children: [
                  text(
                    t: 'Announcements',
                    color: dark1,
                    align: TextAlign.start,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to ViewAnnouncements page when 'View all' is tapped
                      context.pushNamed(
                        '/viewannouncements',
                        extra: announcementList(
                            Announcements: announcements
                        ),
                      );
                    },
                    child: Dtext(
                      t: 'View all',
                      color: dark1,
                      align: TextAlign.start,
                      size: 0.04,
                    ),
                  ),
                ],
              ),
              // Display a message if no announcements are available
              announcements.isEmpty
                  ? Column(
                      children: [
                        Heightsizedbox(
                            h: 0.12), // Add vertical spacing using a custom spacer from the design library
                        Center(
                          child: text(
                            t: 'There are no announcements.',
                            color: grey1,
                            align: TextAlign.center,
                          ),
                        ),
                        Heightsizedbox(
                            h: 0.12), // Add vertical spacing using a custom spacer from the design library
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap:
                          true, // Make the list view only occupy required space
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling for the list view
                      itemCount: 1, // Show only the latest announcement
                      itemBuilder: (context, index) {
                        return _buildAnnouncementCard(announcements[index]);
                      },
                    ),
              Heightsizedbox(
                  h: 0.02), // Spacer between announcements and events

              // Events Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    t: 'Events',
                    color: dark1,
                    align: TextAlign.start,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to ViewEvents page when 'View all' is tapped
                      context.pushNamed(
                        '/viewevents',
                        extra: EventList(
                            Events: events
                        ),);
                    },
                    child: Dtext(
                      t: 'View all',
                      color: dark1,
                      align: TextAlign.start,
                      size: 0.04,
                    ),
                  ),
                ],
              ),
              // Display a message if no events are available
              events.isEmpty
                  ? Column(
                      children: [
                        Heightsizedbox(
                            h: 0.12), // Add vertical spacing using a custom spacer from the design library
                        Center(
                          child: text(
                            t: 'There are no events.',
                            color: grey1,
                            align: TextAlign.center,
                          ),
                        ),
                        Heightsizedbox(
                            h: 0.12), // Add vertical spacing using a custom spacer from the design library
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap:
                          true, // Make the list view only occupy required space
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling for the list view
                      itemCount: 1, // Show only the latest event
                      itemBuilder: (context, index) {
                        return _buildEventCard(events[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build Announcement card
  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    double screenHeight = MediaQuery.of(context).size.height;
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
        margin: const EdgeInsets.symmetric(vertical: 10),
        // Vertical margin for spacing between cards
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display announcement image; uses fallback icon if image fails to load
              Image.network(
                announcement['imageUrl'] ?? '',
                height: screenHeight * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: screenHeight * 0.2,
                ),
              ),
              Heightsizedbox(
                  h: 0.01), // Add vertical spacing using a custom spacer from the design library

              // Spacer
              // Display announcement title using custom text widget from our design library
              text(
                t: announcement['AnnouncementTitle'] ?? 'Announcement title',
                color: light1,
                align: TextAlign.start,
              ),
              Heightsizedbox(
                  h: 0.01), // Add vertical spacing using a custom spacer from the design library

              // Display Announcement description using custom dynamic text widget from our design library
              Dtext(
                t: announcement['AnnouncementDescription'] ??
                    'Announcement Description',
                color: light1,
                align: TextAlign.start,
                size: 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build Event card
  Widget _buildEventCard(Map<String, dynamic> event) {
    double screenHeight = MediaQuery.of(context).size.height;
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
        margin: const EdgeInsets.symmetric(
            vertical: 10), // Vertical margin for spacing between cards
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display event image; uses fallback icon if image fails to load
              Image.network(
                event['imageUrl'] ?? '',
                height: screenHeight * 0.2,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: screenHeight * 0.2,
                ),
              ),
              Heightsizedbox(
                  h: 0.01), // Add vertical spacing using a custom spacer from the design library
              // Display event name using custom sized text widget from our design library
              text(
                t: event['eventName'] ?? 'Event name',
                color: dark1,
                align: TextAlign.start,
              ),
              Heightsizedbox(
                  h: 0.009), // Add vertical spacing using a custom spacer from the design library

              // Display event description using custom dynamic text widget from our design library
              Dtext(
                t: event['eventDescription'] ?? 'Event description',
                color: light1,
                align: TextAlign.start,
                size: 0.04,
              ),

              Heightsizedbox(
                  h: 0.01), // Add vertical spacing using a custom spacer from the design library
              // Row displaying event location, date, and time with icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: dark1), // Location icon

                  Widthsizedbox(
                      w: 0.009), // Add wider horizontal spacing using a custom spacer from the design library

                  // Display Event Location using custom dynamic text widget from our design library
                  Dtext(
                    t: event['location'] ?? 'Location',
                    color: light1,
                    align: TextAlign.start,
                    size: 0.03,
                  ),

                  Widthsizedbox(
                      w: 0.02), // Add wider horizontal spacing using a custom spacer from the design library

                  Icon(Icons.calendar_month, color: dark1), // Calendar icon

                  Widthsizedbox(
                      w: 0.009), // Add wider horizontal spacing using a custom spacer from the design library

                  // Display Event date using custom dynamic text widget from our design library
                  Dtext(
                    t: event['date'] != null
                        ? DateFormat('yyyy-MM-dd')
                            .format((event['date'] as Timestamp).toDate())
                        : 'Date',
                    color: light1,
                    align: TextAlign.start,
                    size: 0.03,
                  ),

                  Widthsizedbox(
                      w: 0.02), // Add wider horizontal spacing using a custom spacer from the design library

                  Icon(Icons.access_time, color: dark1), // Time icon

                  Widthsizedbox(
                      w: 0.009), // Add wider horizontal spacing using a custom spacer from the design library

                  // Display Event time using custom dynamic text widget from our design library
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
  }
}

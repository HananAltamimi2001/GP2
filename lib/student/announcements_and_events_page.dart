import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
//import 'ViewAnnouncements.dart';
//import 'ViewEvents.dart';

class AnnouncementsAndEvents extends StatefulWidget {
  const AnnouncementsAndEvents({super.key});

  @override
  State<AnnouncementsAndEvents> createState() => _AnnouncementsAndEventsState();
}

class _AnnouncementsAndEventsState extends State<AnnouncementsAndEvents> {
  List<Map<String, dynamic>> announcements = [];
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _deleteOldAnnouncements();
    _DeleteExpiredvents();
    _fetchAnnouncements();
    _fetchEvents();
  }

  Future<void> _deleteOldAnnouncements() async {
    try {
      final now = DateTime.now();  // Get the current date and time

      // Fetch all announcements from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Annoucements')  // Replace with your actual collection name
          .get();

      for (var doc in querySnapshot.docs) {
        final announcementData = doc.data();

        // Assuming 'uploadDate' is stored as a Timestamp in Firestore
        if (announcementData['uploadDate'] != null) {
          DateTime uploadDate = (announcementData['uploadDate'] as Timestamp).toDate();

          // Calculate the difference between current date and the upload date
          final difference = now.difference(uploadDate).inDays;

          // If the announcement is older than 3 days, delete it
          if (difference > 3) {
            await FirebaseFirestore.instance
                .collection('Annoucements')  // Replace with your actual collection name
                .doc(doc.id)
                .delete();
            print('Deleted announcement older than 3 days: ${doc.id}');
          }
        }
      }
    } catch (e) {
      print('Error deleting old announcements: $e');
    }
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Annoucements').orderBy("uploadDate",descending:true).get();
      announcements = querySnapshot.docs.map((doc) => doc.data()).toList();


      setState(() {});
    } catch (e) {
      print('Error fetching announcements: $e');
    }
  }

  Future<void> _DeleteExpiredvents() async {
    try {
      final now = DateTime.now();  // Get the current date and time

      // Fetch all events from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .get();

      // Loop through all event documents
      for (var doc in querySnapshot.docs) {
        final eventData = doc.data();

        // Assuming 'eventDate' is stored as a Timestamp in Firestore
        if (eventData['eventDate'] != null) {
          DateTime eventDate = (eventData['eventDate'] as Timestamp).toDate();

          // If the event date is in the past, delete the document
          if (eventDate.isBefore(now)) {
            await FirebaseFirestore.instance.collection('events').doc(doc.id).delete();
            print('Deleted expired event: ${doc.id}');
          }
        }
      }

    } catch (e) {
      print('Error deleting expired events: $e');
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('events').orderBy("uploadDate",descending:true).get();
      events = querySnapshot.docs.map((doc) => doc.data()).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: 'Announcements & Events',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Announcements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Announcements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:dark1,
                    ),
                  ),
                  /*TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewAnnouncements(announcements: announcements),
                          ));
                    },
                    child: const Text('View all'),
                  ),*/
                ],
              ),/*
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return _buildAnnouncementCard(announcements[index]);
                },
              ),*/
              Heightsizedbox(h: 0.02),
              // Events Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark1,
                    ),
                  ),
                  /*TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewEvents(events: events),
                          ));
                    },
                    child: const Text('View all'),
                  ),*/
                ],
              ),/*
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return _buildEventCard(events[index]);
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build Announcement card
  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              announcement['imageUrl'] ?? '', // Replace with correct image URL
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image),
            ),
            Heightsizedbox(h: 0.01),
            Text(
              announcement['AnnoucementTitle'] ?? 'Announcement title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Heightsizedbox(h: 0.01),
            Text(
              announcement['AnnoucementDescription'] ??
                  'Announcement description',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build Event card
  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event['imageUrl'] ?? '', // Replace with correct image URL
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image),
            ),
            Heightsizedbox(h: 0.01),
            Text(
              event['eventName'] ?? 'Event name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Heightsizedbox(h: 0.009),
            Text(
              event['eventDescription'] ?? 'Event description',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Heightsizedbox(h: 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Color(0xff007580),),
                Widthsizedbox(w: 0.009),
                Text(event['location'] ?? 'Location'),
                Widthsizedbox(w: 0.02),
                Icon(Icons.calendar_month, color: Color(0xff007580),),
                Widthsizedbox(w: 0.009),
                Text(
                  event['date'] != null
                      ? DateFormat('yyyy-MM-dd').format(
                          (event['date'] as Timestamp)
                              .toDate()) // Formats to "2024-09-07"
                      : 'Date', // Fallback text if date is null
                ),
                Widthsizedbox(w: 0.02),
                Icon(Icons.access_time, color: Color(0xff007580),),
                 Widthsizedbox(w: 0.009),
                Text(event['time'] ?? 'Time'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

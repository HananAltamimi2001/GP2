import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class ApplicationRequestsList extends StatefulWidget {
  const ApplicationRequestsList({Key? key}) : super(key: key);

  @override
  _ApplicationRequestsListState createState() =>
      _ApplicationRequestsListState();
}

class _ApplicationRequestsListState extends State<ApplicationRequestsList> {
  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    try {
      List<Map<String, dynamic>> requests = [];
      DeleteHousingAplication();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('HousingApplication')
          .where('status', whereNotIn: ['Final Accept', 'Reject']).get();

      for (var doc in snapshot.docs) {
        String status = doc['status'];

        Color statusColor = dark1;
        if (status == 'Pending') {
          statusColor = dark1;
        } else if (status == 'Initial Accept') {
          statusColor = blue1;
        } else if (status == 'Final Accept') {
          statusColor = green1;
        }else{
           statusColor = grey1;
        }
        requests.add({
          'fullname': '${doc['efirstName']} ${doc['elastName']}',
          'requestId': doc.id,
          'color': statusColor,
        });
      }

      return requests;
    } catch (e) {
      print("Error fetching requests: $e");
      return [];
    }
  }

  Future<void> DeleteHousingAplication() async {
    try {
      final now = DateTime.now(); // Get the current date and time

      final querySnapshot = await FirebaseFirestore.instance
          .collection('HousingApplication')
          .get(); // Fetch all announcements

      for (var doc in querySnapshot.docs) {
        final ApplicationData = doc.data();
        if (ApplicationData['createdAt'] != null &&
            (ApplicationData['status'] == 'Reject' ||
                ApplicationData['status'] == 'Final Accept')) {
          // Check if the upload date exists
          DocumentReference ref = doc.reference;
          DateTime Date = DateTime.parse(ApplicationData['createdAt']);
          final difference = now.difference(Date).inDays;
          if (difference >= 30) {
            // Delete announcements older than 3 days
            await ref.delete();
            print(
                'Deleted Application Requests more then more then 30: ${doc.id}');
          }
        }
      }
    } catch (e) {
      print(
          'Error deleting old Application Requests: $e'); // Log any errors that occur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: OurLoadingIndicator());
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: OurAppBar(title: 'Application Requests'),
            body: Center(
                child: Text("An error occurred while fetching requests")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: 'Application Requests'),
            body: Center(child: Text("No requests found")),
          );
        }

        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Application Requests'),
          body: Column(
            children: [
              // Use Expanded on OurListView to allow it to take available space
              Expanded(
                child: OurListView(
                  data: requests,
                  leadingWidget: (item) => text(
                    t: '0${requests.indexOf(item) + 1}',
                    color: dark1,
                    align: TextAlign.start,
                  ),
                  trailingWidget: (item) => Dactionbutton(
                    height: 0.044,
                    width: 0.19,
                    text: 'View',
                    padding: 0,
                    background: item['color'],
                    fontsize: 0.03,
                    onPressed: () {
                      context.pushNamed(
                        '/ApplicationRequestView',
                        extra: requestid(requestId: item['requestId']),
                      );
                    },
                  ),
                  title: (item) => item['fullname'] ?? 'No Name',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

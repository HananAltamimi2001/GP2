import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class VacateRequestsList extends StatefulWidget {
  const VacateRequestsList({super.key});

  @override
  State<VacateRequestsList> createState() =>
      _VacateRequestsListState();
}

class _VacateRequestsListState
    extends State<VacateRequestsList> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> vacateData = [];


  @override
  void initState() {
    super.initState();
    fetchRequests();
  }
  Future<List<Map<String, dynamic>>> fetchRequests() async {
    print("Fetching vacate requests...");  // Print a message before fetching

    try {
      List<Map<String, dynamic>> requests = [];
      DeleteHousingVacate(); // Assuming this doesn't need printing

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('VacateHousing')
          .where('status', isNotEqualTo: 'Completed')
          .get();

      print("Number of requests found: ${snapshot.docs.length}");  // Print number of requests

      for (var doc in snapshot.docs) {
        DocumentReference studentinfo = doc['studentInfo'];
        DocumentSnapshot studentSnapshot = await studentinfo.get();

        String firstName = studentSnapshot['efirstName'] ?? 'N/A';
        String lastName = studentSnapshot['elastName'] ?? 'N/A';
        String status = doc['status'];

        print("Processing request: ${doc.id}");  // Print ID of request being processed

        requests.add({
          'fullname': '$firstName $lastName',
          'requestId': doc.id,
          'status': status
        });
      }
      // InfoDialog(
      //   'Successfully fetched requests!',
      //   context,
      //   buttons: [
      //     {
      //       "Ok": () => context.pop(),
      //     },
      //   ],
      // );

      return requests;
    } catch (e) {
      ErrorDialog(
        'Error fetching requests',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      return [];
    }
  }
  Color getButtonColor(String status) {
    switch (status) {
      case 'Pending':
        return dark1;
      case 'Sent': // Assuming completed means sent
        return blue1;
      default:
        return Colors.grey; // Default color for unknown status
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
            appBar: OurAppBar(title: 'Vacating Requests'),
            body: Center(
                child: text(t:"An error occurred while fetching requests",align: TextAlign.center,color: grey1,)),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: 'Vacating Requests'),
            body: Center(child: text(t:"No requests found",align: TextAlign.center,color: grey1,)),
          );
        }

        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Vacating Requests'),
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
                    background: getButtonColor(item['status']),
                    fontsize: 0.03,
                    onPressed: () {
                     context.pushNamed('/VacateRequestView',
                          extra: requestid(requestId: item['requestId']));
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

Future<void> DeleteHousingVacate() async {
  try {
    final now = DateTime.now(); // Get the current date and time

    final querySnapshot = await FirebaseFirestore.instance
        .collection('VacateHousing')
        .get(); // Fetch all announcements

    for (var doc in querySnapshot.docs) {
      final ApplicationData = doc.data();
      if (ApplicationData['createdAt'] != null &&
          (ApplicationData['status'] == 'Reject' ||
              ApplicationData['status'] == 'Final Accept')) {
        // Check if the upload date exists
        DocumentReference ref = doc.reference;
      Timestamp createdAt = ApplicationData['createdAt']; // Get the timestamp
final difference = now.difference(createdAt.toDate()).inDays; // Convert to DateTime and calculate difference
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
        'Error deleting old Vacate Requests: $e'); // Log any errors that occur
  }
}

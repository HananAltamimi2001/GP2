import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/3-Viewfurnitureservicerequests/2-viewRequestDetails.dart';

class Viewfurnitureservicerequests extends StatefulWidget {
  const Viewfurnitureservicerequests({Key? key}) : super(key: key);

  @override
  _ViewfurnitureservicerequestsState createState() =>
      _ViewfurnitureservicerequestsState();
}

class _ViewfurnitureservicerequestsState extends State<Viewfurnitureservicerequests> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: OurAppBar(title: 'Furniture Requests'),
            body: Center(child: OurLoadingIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
              appBar: OurAppBar(title: 'Furniture Requests'),
              body: Center(
                  child: Text("An error occurred while fetching requests.")));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
              appBar: OurAppBar(title: 'Furniture Requests'),
              body: Center(child: Text("No requests found")));
        }

        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Furniture Requests'),
          body: OurListView(
            data: requests,
            leadingWidget: (item) => text(
              t: '0${requests.indexOf(item) + 1}',
              color: dark1,
              align: TextAlign.start,
            ),
            trailingWidget: (item) {
              final furnitureStatus = item['furnitureData']['furnitureStatus'];
              if (furnitureStatus == 'Accepted') {
                return Dactionbutton(
                  height: 0.055,
                  width: 0.15,
                  text: 'Scan',
                  background: green1,
                  fontsize: 0.035,
                  padding: 0.0,
                  onPressed: () {
                     context.pushNamed('/viewrequestdetails',
                        extra: furniturerequestsid1(requestId: item['requestId']));
                    
                  },
                );
              } else {
                return Dactionbutton(
                  height: 0.055,
                  width: 0.15,
                  text: 'View',
                  background: dark1,
                  fontsize: 0.035,
                  padding: 0.0,
                  onPressed: () {
                    context.pushNamed('/viewrequestdetails',
                        extra: furniturerequestsid1(requestId: item['requestId']));
                  },
                );
              }
            },
            title: (item)=>item['studentName'], // Pass the string key directly
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('furnitureRequest').get();
      List<Map<String, dynamic>> requests = [];

      for (var doc in snapshot.docs) {
        // Only process requests that are not rejected
        if (doc['furnitureStatus'] != 'Rejected') {
          DocumentReference studentRef = doc['studentInfo'];
          DocumentSnapshot studentSnapshot = await studentRef.get();

          if (studentSnapshot.exists) {
            var studentData = studentSnapshot.data() as Map<String, dynamic>;
            requests.add({
              'requestId': doc.id,
              'furnitureData': doc.data() as Map<String, dynamic>,
              'studentData': studentData,
              'studentName': studentData['efirstName'] +" "+ studentData['elastName'],
            });
          }
        }
      }

      return requests;
    } catch (e) {
      print("Error fetching requests: $e");
      return [];
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/staff/1-Manager/2-Complaints/replaycomplaints.dart';

class viewstudentComplaints extends StatefulWidget {
  const viewstudentComplaints({super.key});

  @override
  State<viewstudentComplaints> createState() => _viewstudentComplaintsState();
}

class _viewstudentComplaintsState extends State<viewstudentComplaints> {
  @override
  void initState() {
    super.initState();
    fetchcomplaints();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchcomplaints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: OurLoadingIndicator());
        }
        if (snapshot.hasError) {
          return Scaffold(
              appBar: OurAppBar(title: 'Complaints'),
              body: Center(
                  child: Text("An error occurred while fetching Complaints.")));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
              appBar: OurAppBar(title: 'Complaints'),
              body: Center(child: Text("No Complaints found")));
        }

        List<Map<String, dynamic>> complaints = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Complaints'),
          body: OurListView(
            data: complaints,
            leadingWidget: (item) => text(
              t: '0${complaints.indexOf(item) + 1}',
              color: dark1,
              align: TextAlign.start,
            ),
            trailingWidget: (item) => Dactionbutton(
              height: 0.044,
              width: 0.19,
              text: 'View',
              background: dark1,
              fontsize: 0.03,
              onPressed: () {
                context
                  ..pushNamed(
                    '/replaycomplaints',
                    extra: complaintstdata(
                      complaintId: item['complaintId'],
                      studentname: item['studentName'],
                    ),
                  );
              },
            ),
            title: (item) =>
                item['studentName'], // Updated to pass the string key directly
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchcomplaints() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('complaints').get();
      List<Map<String, dynamic>> complaints = [];

      for (var doc in snapshot.docs) {
        DocumentReference studentRef = doc['studentInfo'];
        DocumentSnapshot studentSnapshot = await studentRef.get();

        if (studentSnapshot.exists) {
          var studentData = studentSnapshot.data() as Map<String, dynamic>;
          complaints.add({
            'complaintId': doc.id,
            'complaintsData': doc.data() as Map<String, dynamic>,
            'studentData': studentData,
            'studentName': studentData['fullName'],
          });
        }
      }

      return complaints;
    } catch (e) {
      print("Error fetching complaints: $e");
      return [];
    }
  }
}

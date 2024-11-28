import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/complaintsdetails.dart';

class viewcomplaints extends StatefulWidget {
  const viewcomplaints({super.key});

  @override
  State<viewcomplaints> createState() =>viewcomplaintsState();
}

class viewcomplaintsState extends State<viewcomplaints> {
  final List<Map<String, dynamic>> complaints = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchUserComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "View Complaints",
      ),
      body: isLoading
          ? Center(child: OurLoadingIndicator()) // Show loading indicator
          : complaints.isEmpty
          ? Center( // Display message when no complaints
        child: Text(
          "No complaints found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : OurListView(
        data: complaints,
        leadingWidget: (item) => text(
          t: '0${complaints.indexOf(item) + 1}',
          color: dark1,
          align: TextAlign.start,
        ),
        title: (item) => item['complaintTitle'] ?? 'No Title',
        trailingWidget: (item) => Dactionbutton(padding: 0.0,
          height: 0.044,
          width: 0.19,
          text: 'View',
          background: dark1,
          fontsize: 0.03,
          onPressed: () {
            context.pushNamed(
              '/complaintsdetails',
              extra: complaintstData(complaints: item),
            );
          },
        ),
      ),
    );
  }

  Future<void> fetchUserComplaints() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference studentRef = FirebaseFirestore.instance.collection('student').doc(userId);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('studentInfo', isEqualTo: studentRef)
          .get();

      setState(() {
        complaints.addAll(querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));
        isLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      ErrorDialog(
        'Error fetching complaints: $e',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
    }
  }
}

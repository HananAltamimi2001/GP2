import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/complaintsdetails.dart';

class viewcomplaints extends StatefulWidget {
  const viewcomplaints({super.key});

  @override
  State<viewcomplaints> createState() => _viewcomplaintsState();
}

class _viewcomplaintsState extends State<viewcomplaints> {
  @override
  void initState() {
    super.initState();
    fetchUsercomplaints();
  }

  final List<Map<String, dynamic>> complaints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "View Complaints",
      ),
      body: complaints.isEmpty
          ? Center(child: OurLoadingIndicator())
          : OurListView(
        data: complaints,
        leadingWidget: (item) => text(
          t: '0${complaints.indexOf(item) + 1}',
          color: dark1,
          align: TextAlign.start,
        ),
        title: (item) => item['complaintTitle'],
        trailingWidget: (item) => Dactionbutton(
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

  Future<void> fetchUsercomplaints() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference studentRef =
      FirebaseFirestore.instance.collection('student').doc(userId);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('studentInfo', isEqualTo: studentRef)
          .get();

      setState(() {
        complaints.addAll(querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>));
      });
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:pnustudenthousing/staff/1-Manager/2-Complaints/replaycomplaints.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/viewfiles.dart';

class StudentFiles extends StatefulWidget {
  const StudentFiles({super.key});

  @override
  State<StudentFiles> createState() => _StudentFilesState();
}

class _StudentFilesState extends State<StudentFiles> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchStudentFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: OurAppBar(title: 'Student Files'),
            body: Center(child: OurLoadingIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: OurAppBar(title: 'Student Files'),
            body: Center(child: Text("An error occurred while fetching Student Files")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: 'Student Files'),
            body: Center(child: Text("No Student Files found")),
          );
        }

        List<Map<String, dynamic>> studentFiles = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Student Files'),
          body: OurListView(
            data: studentFiles,
            leadingWidget: (item) => text(
              t: '${studentFiles.indexOf(item) + 1}',
              color: dark1,
              align: TextAlign.start,
            ),
            trailingWidget: (item) => Dactionbutton(
              padding: 0.0,
              height: 0.044,
              width: 0.19,
              text: 'View',
              background: dark1,
              fontsize: 0.03,
              onPressed: () {
                context.pushNamed(
                  '/viewfiles',
                  extra: filesdata(
                    studentname: item['studentName'],
                    studentid: item['studentData']['PNUID'], // Assuming 'PNUID' is the student ID field
                    studentFiles: item['StudentFilesData'], // Adding student file data to the list
                  ),
                );
              },
            ),
            title: (item) => item['studentName'], // Passes the string key directly
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchStudentFiles() async {
    try {
      // Ensure the user is logged in
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found.");
      }

      // Get the current user's ID and fetch their document
      String docId = currentUser.uid;
      DocumentReference specialistDocRef = FirebaseFirestore.instance.collection('staff').doc(docId);

      // Fetch specialist data with null checks
      DocumentSnapshot specialistSnapshot = await specialistDocRef.get();
      if (!specialistSnapshot.exists) {
        throw Exception("Specialist data not found.");
      }

      var specialistData = specialistSnapshot.data() as Map<String, dynamic>;
      String specialistName = '${specialistData['efirstName'] ?? 'Unknown'} ${specialistData['elastName'] ?? ''}'.trim();
      if (specialistName.isEmpty) {
        throw Exception("Specialist name is incomplete.");
      }

      print(specialistName);

      // Fetch student files associated with this specialist
      QuerySnapshot studentFilesSnapshot = await FirebaseFirestore.instance
          .collection('StudentFiles')
          .where('SpecialistName', isEqualTo: specialistName)
          .get();

      List<Map<String, dynamic>> studentFiles = [];

      // Loop through each student file document
      for (var doc in studentFilesSnapshot.docs) {
        String studentId = doc['studentId'] ?? '';

        if (studentId.isEmpty) continue;  // Skip if studentId is missing

        // Fetch student data from the 'student' collection
        QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection('student')
            .where('PNUID', isEqualTo: studentId)
            .get();

        if (studentSnapshot.docs.isNotEmpty) {
          var studentData = studentSnapshot.docs.first.data() as Map<String, dynamic>;
          String studentName = '${studentData['efirstName'] ?? 'Unknown'} ${studentData['elastName'] ?? ''}'.trim();

          // Add the correct type: List<Map<String, dynamic>>
          studentFiles.add({
            'StudentFilesData': doc.data() as Map<String, dynamic>,
            'studentData': studentData,
            'studentName': studentName,
          });
        } else {
          print("No student found with PNUID: $studentId");
        }
      }

      return studentFiles; // Ensure it returns List<Map<String, dynamic>>

    } catch (e, stackTrace) {
      print("Error fetching student files: $e");
      print("Stack trace: $stackTrace");

      // Show an error dialog
      if (context.mounted) {
        ErrorDialog(
          'Error fetching student files:\n$e',
          context,
          buttons: [
            {"Ok": () => context.pop()},
          ],
        );
      }

      return [];  // Return an empty list if there's an error
    }
  }



}

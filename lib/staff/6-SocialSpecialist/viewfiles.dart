import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class viewfiles extends StatefulWidget {
  final filesdata args;

  const viewfiles({super.key, required this.args});

  @override
  State<viewfiles> createState() => viewfilesState();
}

class viewfilesState extends State<viewfiles> {
  final TextEditingController report = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: widget.args.studentname,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getstudentfilesDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            var data = snapshot.data!;
            var reportsMap = data['StudentFiles']['Reports'] ?? {};

            // Example for handling reports if the structure is nested
            List<dynamic> reportsList = reportsMap.entries.map((entry) {
              return {
                'date': entry.key, // assuming key is the date
                'content': entry.value, // assuming value is the content
              };
            }).toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Titletext(
                          t: 'Student Name:',
                          align: TextAlign.start,
                          color: dark1),
                      buildInfoContainer(widget.args.studentname),
                      Heightsizedbox(h: 0.02),
                      Titletext(
                          t: 'PNUID:', align: TextAlign.start, color: dark1),
                      buildInfoContainer(widget.args.studentid),
                      Heightsizedbox(h: 0.02),
                      // Display reports dynamically
                      ...reportsList.map((reportData) {
                        var reportDate = reportData['date'];
                        var reportContent = reportData['content'];

                        // Check for null or invalid types to avoid the TypeError
                        if (reportDate is String && reportContent is String) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text('Date: $reportDate',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: dark1)),
                                subtitle: Text(reportContent),
                              ),
                            ),
                          );
                        } else {
                          // Handle invalid data (if needed)
                          return Container(); // Return an empty container or some fallback widget
                        }
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: dark1,
        onPressed: () {
          _showAddReportDialog();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildInfoContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.circular(17.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: dark1, fontSize: 20),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getstudentfilesDetails() async {
    // Query the collection for the student document where 'pnuid' matches
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('StudentFiles')
        .where('studentId',
            isEqualTo: widget.args.studentid) // Use pnuid to query
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("Student File not found");
    }

    var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

    return {
      'StudentFiles': data,
    };
  }

  void _showAddReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Report'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: report,
              maxLines: 3,
              decoration: InputDecoration(hintText: 'Enter your report'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a report';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _addReport();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addReport() async {
    try {
      String reportContent = report.text.trim();
      if (reportContent.isEmpty) return;

      // Get the current date formatted as "yyyy-MM-dd"
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Query for the student document based on studentId
      QuerySnapshot<Map<String, dynamic>> studentDoc1 = await FirebaseFirestore
          .instance
          .collection('StudentFiles')
          .where('studentId',
              isEqualTo: widget.args.studentid) // Use studentId to query
          .get();

// Check if there are any documents returned
      if (studentDoc1.docs.isNotEmpty) {
        // Get the first document from the query result
        DocumentSnapshot<Map<String, dynamic>> document =
            studentDoc1.docs.first;

        // Get the reference to the student document
        DocumentReference studentDoc = document.reference;

        // Now you can use studentDoc for further operations
        print("Document reference: ${studentDoc.id}");

        // Update Firestore with the new report using the date as a key
        await studentDoc.set({
          'Reports': {
            formattedDate: reportContent, // Dynamic date key with content
          }
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

        report.clear();

        InfoDialog('Report added successfully', context, buttons: [
          {
            "Ok": () => {context.pop(), setState(() {})}
          }
        ]);
      } else {
        InfoDialog("No student found with the provided ID", context, buttons: [
          {"Ok": () => context.pop()}
        ]);
        print("No student found with the provided ID");
      }
    } catch (e) {
      ErrorDialog('Error adding report', context, buttons: [
        {"Ok": () => context.pop()}
      ]);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error adding report: $e')),
      // );
    }
  }
}

class filesdata {
  final String studentid; // This represents the pnuid, which is used as a field
  final String studentname;
  final Map<String, dynamic> studentFiles;

  filesdata({
    required this.studentid, // pnuid here
    required this.studentname,
    required this.studentFiles,
  });
}

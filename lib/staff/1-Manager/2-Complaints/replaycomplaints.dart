import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';

class replaycomplaints extends StatefulWidget {
  final complaintstdata args;

  const replaycomplaints({super.key, required this.args});

  @override
  State<replaycomplaints> createState() => replaycomplaintsState();
}

class replaycomplaintsState extends State<replaycomplaints> {
  final TextEditingController replyController = TextEditingController();
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
            future: getcomplaintAndStudentDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              var data = snapshot.data!;
              var complaintData = data['complaint'];
              String complaintTitle = complaintData['complaintTitle'] ?? 'N/A';
              String complaintIssues =
                  complaintData['complaintIssues'] ?? 'N/A';

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Titletext(
                          t: '$complaintTitle:',
                          align: TextAlign.start,
                          color: dark1,
                        ),
                        Heightsizedbox(h: 0.02),
                        OurContainer(
                          child: text(
                            t: complaintIssues,
                            align: TextAlign.start,
                            color: light1,
                          ),
                        ),
                        // Additional content here if needed
                        SizedBox(height: 100), // Add space to ensure scrollability
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Form(
                      key: formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: textform(
                              controller: replyController,
                              hinttext: "Reply",
                              lines: 1,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please Write the Reply";
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: dark1),
                            onPressed: submitReply,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getcomplaintAndStudentDetails() async {
    // Fetch the request details
    DocumentSnapshot requestSnapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .doc(widget.args.complaintId)
        .get();

    if (!requestSnapshot.exists) {
      throw Exception("complaint not found");
    }

    var data = requestSnapshot.data() as Map<String, dynamic>;

    // Return the complaint details
    return {
      'complaint': data,
    };
  }

  Future<void> submitReply() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save the form data.

      try {
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(widget.args.complaintId)
            .update({
          'Reply': replyController.text,
          'status':'Replied'
          // Add any other necessary fields here, like timestamps or user IDs if needed
        });

        // Clear the input field after submission
        replyController.clear();

        // Show a success message after Reply is saved.
        InfoDialog(
          "Reply send successfully",
          context,
          buttons: [
            {
              "OK": () async => {context.pop(),context.pop(),}
            },
          ],
        );
      } catch (e) {
        ErrorDialog(
          "An error occurred while sending the Reply",
          context,
          buttons: [
            {
              "OK": () async => context.pop(),
            },
          ],
        );
      }
    }
  }
}

class complaintstdata {
  final String complaintId;
  final String studentname;
  complaintstdata({
    required this.complaintId,
    required this.studentname,
  });
}

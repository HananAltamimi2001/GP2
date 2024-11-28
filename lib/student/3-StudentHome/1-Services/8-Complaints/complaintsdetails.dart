import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:flutter/material.dart';

class complaintsdetails extends StatelessWidget {
  final complaintstData args;

  const complaintsdetails({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> complaint = args.complaints;

    return Scaffold(
      appBar: OurAppBar(
        title: complaint['complaintTitle'] ?? 'Complaint Data',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OurContainer(
                child: text(
                  t:  complaint['complaintIssues'],
                  align: TextAlign.start,
                  color: light1,
                ),
              ),
              Heightsizedbox(h: 0.04),

              Titletext(
                  t: 'Reply:',
                  align: TextAlign.start,
                  color: dark1),
              Heightsizedbox(h: 0.02),
              OurContainer(borderColor: green1,
                child: text(
                  t: complaint['Reply'] ?? 'No Reply yet',
                  align: TextAlign.start,
                  color: light1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class complaintstData {
  final Map<String, dynamic> complaints;
  complaintstData({
    required this.complaints,
  });
}

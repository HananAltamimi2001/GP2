import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

class complaints extends StatelessWidget {
  const complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Complaints",
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PagesButton(
                name: 'Send Complaint',
                onPressed: () {
                  context.pushNamed('/sendcomplaint');
                }),

            Heightsizedbox(
                h: 0.02), // Spacer with height from our design library for separation

            PagesButton(
              name: 'View Complaints',
              onPressed: () {
                context.pushNamed('/viewcomplaints');
              },
            ),
          ],
        ),
      ),
    );
  }
}

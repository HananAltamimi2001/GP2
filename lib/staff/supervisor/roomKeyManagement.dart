import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';


class RoomKeyManagement extends StatefulWidget {
  const RoomKeyManagement({super.key});

  @override
  State<RoomKeyManagement> createState() => _RoomKeyManagementState();
}

class _RoomKeyManagementState extends State<RoomKeyManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Room Key Management",
      ),
      body: bodyCode(),
    );
  }
}

class bodyCode extends StatelessWidget {
  const bodyCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PagesButton(
              name: "Resident Student",
                onPressed:() {
              }
            ),
            Heightsizedbox(h: 0.02),
            PagesButton(
              name: "New Student",
                onPressed:() {}
            ),
             PagesButton(
              name: "Departing Check-in",
                onPressed:() {}
            ),
          ],
        ),
      ),
    );
  }
}
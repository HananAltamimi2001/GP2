import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PagesButton(name: "Resident Student", onPressed: () {}),
              PagesButton(
                  name: "New Students",
                  background: blue1,
                  onPressed: () {
                    context.pushNamed('/newroomKeyList');
                  }),
              Heightsizedbox(h: 0.02),

              PagesButton(
                  name: "Departing Students",
                  background: red1,
                  onPressed: () {
                    context.pushNamed('/departingroomKeyList');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

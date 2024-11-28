import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/4-QrScanner.dart';

class checkInOut extends StatefulWidget {
  const checkInOut({super.key});

  @override
  State<checkInOut> createState() => _checkInOutState();
}

class _checkInOutState extends State<checkInOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Check in/out",
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PagesButton(
                  name: "Check-in",
                  onPressed: () {
                    context.pushNamed('/QrScanner1',
                        extra: QrData(sturef: null, Ceckstatus: 'Checked-in'));
                  }),
              Heightsizedbox(h: 0.02),
              PagesButton(
                  name: "Check-out",
                  onPressed: () {
                    context.pushNamed('/QrScanner1',
                        extra: QrData(sturef: null, Ceckstatus: 'Checked-out'));
                  }),
              Heightsizedbox(h: 0.02),
              PagesButton(
                  name: "First Check-in",
                  background: blue1,
                  onPressed: () {
                    context.pushNamed('/FirstCheckInList');
                  }),
              Heightsizedbox(h: 0.02),
              PagesButton(
                  name: "Last Check-out",
                  background: red1,
                  onPressed: () {
                    context.pushNamed('/LastCheckOutList');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

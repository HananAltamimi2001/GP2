import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

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
            PagesButton(name: "Check-in", onPressed: () {}),
            Heightsizedbox(h: 0.02),
            PagesButton(name: "Check-out", onPressed: () {}),
            Heightsizedbox(h: 0.02),
            PagesButton(
              name: "First Check-in",
              background: blue1,
            ),
            Heightsizedbox(h: 0.02),
            PagesButton(
                name: "Last Check-out", background: red1, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

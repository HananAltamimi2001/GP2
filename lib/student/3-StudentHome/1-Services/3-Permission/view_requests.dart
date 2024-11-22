import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class ViewRequests extends StatefulWidget {
  const ViewRequests({super.key});

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "View Requests",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Dactionbutton(
                  text: 'Overnight request status',
                  onPressed: () {
                    context.pushNamed('/overnightstatus');
                  },
                  background: light1,
                  width: 0.9,
                  height: 0.09,
                  fontsize: 0.06,
                ),
              ),
              Heightsizedbox(
                h: 0.04,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Dactionbutton(
                  onPressed: () {
                    context.pushNamed('/visitorstatus');
                  },
                  background: light1,
                  text: "Visitor request status",
                  width: 0.9,
                  height: 0.090,
                  fontsize: 0.06,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


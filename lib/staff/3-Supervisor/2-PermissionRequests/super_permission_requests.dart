import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SuperPermissionRequests extends StatefulWidget {
  const SuperPermissionRequests({super.key});

  @override
  State<SuperPermissionRequests> createState() =>
      _SuperPermissionRequestsState();
}

class _SuperPermissionRequestsState extends State<SuperPermissionRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Permission Requests",
      ),
      body: SafeArea(
        child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 180, 15, 5),
          child: Center(
            child: Column(
              children: [
                PagesButton(
                  name: 'Overnight Request',
                  onPressed: () {
                    context.pushNamed('/superovernightlist');
                  },
                ),
                Heightsizedbox(
                  h: 0.04,
                ),
                PagesButton(
                  name: "Visitor Request",
                  onPressed: () {
                    context.pushNamed('/supervisitorlist');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

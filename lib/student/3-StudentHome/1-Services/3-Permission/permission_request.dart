import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:firebase_core/firebase_core.dart';

//*****The main page of Permission requests
class PermissionRequest extends StatelessWidget {
  const PermissionRequest({super.key});

  //Interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Permission Requests",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0),
        child: Center(
            child: Column(
          children: [
            PagesButton(
              name: "      Visitor Request",
              onPressed: () {
                context.pushNamed('/visitorrequest');
              },
            ),
            Heightsizedbox(
              h: 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: PagesButton(
                name: "Overnight Request",
                onPressed: () {
                  context.pushNamed('/overnightrequest');
                },
              ),
            ),
            Heightsizedbox(
              h: 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: PagesButton(
                name: "      View Requests",
                onPressed: () {
                  context.pushNamed('/viewrequests');
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}

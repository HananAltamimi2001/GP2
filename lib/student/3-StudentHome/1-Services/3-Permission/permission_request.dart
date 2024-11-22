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
        padding: const EdgeInsets.fromLTRB(0, 190, 0, 0),
        child: Center(
            child: Column(
          children: [
            HomeButton1(
              name: "      Visitor Request",
              onPressed: () {
                context.pushNamed('/visitorrequest');
              },
              icon: Icons.door_back_door,
            ),
            Heightsizedbox(
              h: 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: HomeButton2(
                icon: Icons.nights_stay,
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
              child: HomeButton1(
                icon: Icons.inbox,
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

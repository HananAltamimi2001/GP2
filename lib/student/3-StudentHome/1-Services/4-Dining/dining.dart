import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library


class DiningServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title:
          'Dining Services',
        ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PagesButton(
                name: 'Menu',
                onPressed: () {
                  context.pushNamed('/menu');
                }),

            Heightsizedbox(
                h: 0.02), // Spacer with height from our design library for separation

            PagesButton(
              name: 'Coupon',
              onPressed: () {
                context.pushNamed('/coupon');
              },
            ),
          ],
        ),
      ),
    );
  }
}

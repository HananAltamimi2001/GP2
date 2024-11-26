import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class ViewFurnitureStock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title:' View Furniture Stock'
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button for Remaining Furniture
            PagesButton(
              background: green1, // Button color
              onPressed: (){context.pushNamed('/remainingfurniture');},
              name: 'Remaining Furniture',

            ),
            Heightsizedbox(h: 0.02), // Add space between buttons

            // Button for Occupied Furniture
            PagesButton(
              background:red1, // Button color
              onPressed: (){context.pushNamed('/occupiedfurniture');},
              name: 'Occupied Furniture',
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library




class menu extends StatelessWidget {
  const menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: 'Menu',
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

        PagesButton(
          name: 'Lunch',
          onPressed: () {
            context.pushNamed('/viewhmenu',
                extra: "Lunch");
          },
        ),

        Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

        PagesButton(
          name: 'Dinner',
          onPressed: () {
            context.pushNamed('/viewhmenu',
                extra: "Dinner");
          },
        ),
      ]),
    );
  }
}

class menutype{
  final String type ;

  menutype({
    required this.type,
  });
}
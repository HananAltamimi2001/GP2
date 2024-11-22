import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';


class EventCard extends StatelessWidget {
  final bool isPast;
  final child;
  const EventCard({super.key , required this.isPast, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: isPast ? dark1 : Colors.grey,
          borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}

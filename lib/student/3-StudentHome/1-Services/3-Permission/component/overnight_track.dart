import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/component/eventcard.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:firebase_database/firebase_database.dart';


class OvernightTrack extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;
  const OvernightTrack(
      {super.key,
      required this.isLast,
      required this.isFirst,
      required this.isPast,
      required this.eventCard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.250,
          child: TimelineTile(
            isFirst: isFirst,
            isLast: isLast,
            //timeline style
            beforeLineStyle: LineStyle(
              color: isPast ? dark1 : Colors.grey,
            ),
            indicatorStyle: IndicatorStyle(
              width: 40,
              color: isPast ? dark1 : Colors.grey,
              iconStyle: IconStyle(
                  iconData: Icons.done, color: isPast ? Colors.white : Colors.grey),
            ),
            endChild: EventCard(isPast: isPast,child: eventCard,),
          ),
        ),
      ],
    );
  }
}

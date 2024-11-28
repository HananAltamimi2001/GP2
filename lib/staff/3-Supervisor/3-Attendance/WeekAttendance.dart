import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Custom design library

class WeekAttendance extends StatelessWidget {
  final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    // Get today's date and the day of the week
    DateTime now = DateTime.now();
    int todayIndex = now.weekday % 7; // Make Sunday = 0, Monday = 1, etc.

    return Scaffold(
      appBar: OurAppBar(title: 'Attendance for Week'),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              bool isFuture = index > todayIndex;

              // Check if it's a future day, in which case you can't check attendance
              return Column(
                children: [
                  PagesButton(
                    name: days[index],
                    onPressed: isFuture
                        ? null // Disable future days
                        : () {

                      // Pass the formatted date to the next page
                      context.pushNamed('/dayattendance', extra: days[index]);
                    },
                   isDisabled: isFuture, // Custom button property for grey-out
                  ),
                  Heightsizedbox(h: 0.01),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class viewAppointmentDetails extends StatelessWidget {
  final appointmentDatas args;
  viewAppointmentDetails({required this.args});

  @override
  Widget build(BuildContext context) {
    // Use default values if fields are null
    String date = args.appointment['Date'] ?? 'N/A';
    String time = args.appointment['Time'] ?? 'N/A';
    String reason = args.appointment['Reason'] ?? 'N/A';
    String type = args.appointment['type'] ?? ''; // Default empty string
    String name = args.appointment['name'] ?? 'N/A'; // Provide 'N/A' if null

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OurAppBar(
        title: 'Appointment Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Titletext(t: 'Date:', color: dark1, align: TextAlign.start),
            Container(
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: text(t: date, color: dark1, align: TextAlign.center),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Titletext(t: 'Time:', color: dark1, align: TextAlign.start),
            Container(
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: text(t: time, color: dark1, align: TextAlign.center),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Titletext(t: 'Reason:', color: dark1, align: TextAlign.start),
            Container(
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: text(t: reason, color: dark1, align: TextAlign.center),
              ),
            ),
            Heightsizedbox(h: 0.02),
            Titletext(t: 'With:', color: dark1, align: TextAlign.start),
            Container(
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: text(t: type, color: dark1, align: TextAlign.center),
              ),
            ),
            Heightsizedbox(h: 0.02),
            // Conditional display of name for "Social Specialist"
            if (type == "Social Specialist") ...[
              Titletext(t: 'Name:', color: dark1, align: TextAlign.start),
              Container(
                decoration: BoxDecoration(
                  color: grey2,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: text(t: name, color: dark1, align: TextAlign.center),
                ),
              ),
            ],
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class appointmentDatas {
  final Map<String, dynamic> appointment; // The appointment data

  appointmentDatas({required this.appointment});
}

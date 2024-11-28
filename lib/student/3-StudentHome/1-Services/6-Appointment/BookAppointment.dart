import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class BookAppointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Book Appointment",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color(0xFF339199)),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        // SafeArea ensures the UI doesn't overlap with system UI components
        child: Center(
          // Center widget centers its child widgets
          child: Column(
            // Using a column to stack buttons vertically
            mainAxisAlignment:
                MainAxisAlignment.center, // Center items vertically
            children: [

              PagesButton(
                  name: "With Housing Manager",
                  onPressed: () { context.pushNamed('/SetAppointmentWithHousingManager');
                  }
              ),

              Heightsizedbox(h: 0.02),

              PagesButton(
                  name: "With Social Specialist",
                  onPressed: () { context.pushNamed('/SetAppointmentWithSocialSpecialist');

                  }
              ),

              Heightsizedbox(h: 0.02),

              PagesButton(
                  name: "View Reserved Appointment",
                  onPressed: () { context.pushNamed('/ViewReservedAppointments');

                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}

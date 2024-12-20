import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/Authentication/firbase_auth_services.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SetAppointmentScreenM extends StatefulWidget {
  @override
  SetAppointmentDialogStateM createState() => SetAppointmentDialogStateM();
}

class SetAppointmentDialogStateM extends State<SetAppointmentScreenM> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final CollectionReference appoint =
      FirebaseFirestore.instance.collection("Appointments");

  Future<void> saveAppointment() async {
    if (selectedTime == null || selectedDate == null) {
      ErrorDialog(
        'Please select both date and time for the appointment',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );

      return;
    }

    try {
      // Check for existing appointment with the same date and time
      QuerySnapshot query = await appoint
          .where('Date', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate!))
          .where('Time', isEqualTo: selectedTime!.format(context))
          .get();

      if (query.docs.isNotEmpty) {
        // Appointment already exists at this date and time
        ErrorDialog(
          'An appointment is already scheduled at this time.',
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
        return;
      }

      await appoint.add({
        'Date': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'Time': selectedTime!.format(context),
        'Status': 'available',
        'type': 'manager',
      });


      Navigator.pop(context);

    } catch (e) {
      ErrorDialog(
        'Failed to save appointment',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width * 0.99, // Adjust width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Title
                Titletext(
                  t: 'Set Appointment',
                  color: dark1,
                  align: TextAlign.center,
                ),

                Heightsizedbox(h: 0.02),

                // Date Picker Field
                OurFormField(
                  fieldType: 'date',
                  selectedDate: selectedDate,
                  onSelectDate: () async {
                    final DateTime? pickedDate = await pickDate(context);
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  labelText: "Select Date:",
                ),

                Heightsizedbox(h: 0.02),

                // Time Picker Field
                OurFormField(
                  fieldType: 'time',
                  selectedTime: selectedTime,
                  onSelectTime: () async {
                    final TimeOfDay? pickedTime = await pickTime(context);
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  labelText: "Select Time:",
                ),

                Heightsizedbox(h: 0.04),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    actionbutton(
                      onPressed: () {
                        context.pop();
                      },
                      text: 'Cancel',
                      background: red1,
                    ),

                    actionbutton(
                      onPressed: saveAppointment,
                      text: 'Set',
                      background: green1,
                    ),

                  ],
                ),
              ],
            ),
          ),

          // Close Button ("X")
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
        ],
      ),
    );
  }
}

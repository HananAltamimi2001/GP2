import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class EditAppointmentMScreen extends StatefulWidget {
  final AppointmentDatae args; // This will include both appointment data and ID

  EditAppointmentMScreen({required this.args});

  @override
  _EditAppointmentMScreenState createState() => _EditAppointmentMScreenState();
}

class _EditAppointmentMScreenState extends State<EditAppointmentMScreen> {
  final CollectionReference appoint = FirebaseFirestore.instance.collection("Appointments");
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchAppointmentData();
  }

  Future<void> fetchAppointmentData() async {
    try {
      // Use the appointmentId from args
      DocumentSnapshot docSnapshot = await appoint.doc(widget.args.appointmentId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Extract and parse date field
        String dateString = data['Date'];
        selectedDate = DateTime.parse(dateString); // Ensure 'Date' is in 'yyyy-MM-dd' format

        // Extract and parse time field
        String timeString = data['Time']; // e.g., "9:56 AM"
        print("Raw Time String: $timeString");

        // Regex to extract hours, minutes, and AM/PM
        final regex = RegExp(r'(\d{1,2}):(\d{2})\s([APM]{2})');
        final match = regex.firstMatch(timeString);

        if (match != null) {
          // Extract hour, minute, and AM/PM
          int hour = int.parse(match.group(1)!);
          int minute = int.parse(match.group(2)!);
          String amPm = match.group(3)!;

          // Adjust hour for AM/PM
          if (amPm == 'PM' && hour != 12) {
            hour += 12; // Convert PM to 24-hour format
          } else if (amPm == 'AM' && hour == 12) {
            hour = 0; // Convert 12 AM to 00:00
          }

          // Create a DateTime object
          final timeParsed = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, hour, minute);

          // Convert DateTime to TimeOfDay
          selectedTime = TimeOfDay.fromDateTime(timeParsed);

          print("Parsed Time: $selectedTime");
        }

        setState(() {
          isLoading = false; // Data is fetched, stop loading
        });
      } else {
        ErrorDialog(
          'Document not found!',
          context,
          buttons: [
            {
              "Ok": () => context.pop(),
            },
          ],
        );
      }
    } catch (e) {
      ErrorDialog(
        'Error fetching appointment data',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      print("Error fetching appointment data: $e");
      setState(() {
        isLoading = false; // Stop loading even on error
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while fetching data
      return Scaffold(
        appBar: AppBar(title: Text("Edit Appointment")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Main UI once data is loaded
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
                      text: 'Save',
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

  Future<void> saveAppointment() async {
    if (selectedTime == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time for the appointment')),
      );
      return;
    }

    try {
      await appoint.doc(widget.args.appointmentId).update({
        'Date': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'Time': selectedTime!.format(context),
      });

      Navigator.pop(context, true); // Return 'true' to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
      );
    }
  }

}

class AppointmentDatae {
  final String appointmentId; // Added appointmentId field
  final Map<String, dynamic> appointment; // The appointment data

  AppointmentDatae({
    required this.appointmentId,
    required this.appointment,
  });
}

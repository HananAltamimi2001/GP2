import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SetAppointmentScreenSp extends StatefulWidget {
  @override
  SetAppointmentDialogStateSp createState() => SetAppointmentDialogStateSp();
}

class SetAppointmentDialogStateSp extends State<SetAppointmentScreenSp> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final CollectionReference appoint = FirebaseFirestore.instance.collection("Appointments");
  String? userName; // To store the user's full name

  // Fetch user data when the screen loads
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Method to fetch user data directly from Firestore
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('staff').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = '${userDoc['firstName']} ${userDoc['lastName']}';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // Save the appointment with user data
  Future<void> saveAppointment() async {
    if (selectedTime == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time for the appointment')),
      );
      return;
    }

    if (userName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data not available')),
      );
      return;
    }

    try {
      await appoint.add({
        'Date': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'Time': selectedTime!.format(context),
        'Status': 'available',
        'type': 'Social Specialist',
        'name': userName, // Use the full name of the user
      });

      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment: $e')),
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

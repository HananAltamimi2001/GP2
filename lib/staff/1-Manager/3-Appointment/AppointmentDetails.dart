import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/1-Manager/3-Appointment/EditAppointment.dart';

class AppointmentDetailsScreenM extends StatefulWidget {
  final AppointmentInfoM args;

  AppointmentDetailsScreenM({required this.args});

  @override
  _AppointmentDetailsScreenMState createState() =>
      _AppointmentDetailsScreenMState();
}

class _AppointmentDetailsScreenMState extends State<AppointmentDetailsScreenM> {
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection("Appointments");

  // State variables
  late String date;
  late String time;
  late String status;
  late String reason;
  DocumentReference? studentRef;

  @override
  void initState() {
    super.initState();
    // Set initial values from args
    date = widget.args.appointment['Date'] ?? 'N/A';
    time = widget.args.appointment['Time'] ?? 'N/A';
    status = widget.args.appointment['Status'] ?? "n/a";
    reason = widget.args.appointment['Reason'] ?? "n/a";
    studentRef = widget.args.appointment['studentInfo'] as DocumentReference?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Appointment Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('Date:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            buildInfoContainer(date),
            SizedBox(height: 20),
            Text('Time:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            buildInfoContainer(time),
            SizedBox(height: 20),
            Text('Reason:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            buildInfoContainer(reason),
            SizedBox(height: 20),
            if( status == "Reserved")
              FutureBuilder<DocumentSnapshot>(
                future: studentRef!.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('Student data not found.'));
                  } else {
                    var studentData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String studentName = studentData['efullName'] ?? 'N/A';
                    String pnuid = studentData['PNUID'] ?? 'N/A';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student Name:',
                            style: TextStyle(
                                color: Color(0xFF339199), fontSize: 25)),
                        buildInfoContainer(studentName),
                        SizedBox(height: 20),
                        Text('PNUID:',
                            style: TextStyle(
                                color: Color(0xFF339199), fontSize: 25)),
                        buildInfoContainer(pnuid),
                      ],
                    );
                  }
                },
              ),
            
            if(status == "available")
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  actionbutton(
                    onPressed: () =>
                        deleteAppointment(context, widget.args.appointmentId),
                    text: 'Delete',
                    background: red1,
                  ),
                  actionbutton(
                    onPressed: () => showEditDialog(context),
                    text: 'Edit',
                    background: dark1,
                  ),
                ],
              ),
            
          ],
        ),
      ),
    );
  }

  Widget buildInfoContainer(String text) {
    return Container(
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.circular(17.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: dark1, fontSize: 20),
        ),
      ),
    );
  }

  // Delete appointment
  Future<void> deleteAppointment(
      BuildContext context, String appointmentId) async {
    final CollectionReference appointmentsCollection =
        FirebaseFirestore.instance.collection("Appointments");
    await appointmentsCollection.doc(appointmentId).delete();
    InfoDialog(
      'Appointment deleted successfully',
      context,
      buttons: [
        {
          "Ok": () => context.pop(),
        },
      ],
    );
    Navigator.pop(context); // Navigate back after deletion
  }

  // Show Edit dialog
  void showEditDialog(BuildContext context) async {
    bool? updated = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditAppointmentMScreen(
          args: AppointmentDatae(
            appointmentId: widget.args.appointmentId,
            appointment: widget.args.appointment,
          ),
        );
      },
    );

    // If appointment was updated, update the state
    if (updated == true) {
      // Re-fetch the updated appointment data here
      final docSnapshot =
          await appointments.doc(widget.args.appointmentId).get();
      final updatedData = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        // Update state with the latest data
        date = updatedData['Date'] ?? 'N/A';
        time = updatedData['Time'] ?? 'N/A';
        status = updatedData['Status'] ?? 'n/a';
        reason = updatedData['Reason'] ?? 'n/a';
        studentRef = updatedData['studentInfo'] as DocumentReference?;
      });
    }
  }
}

class AppointmentInfoM {
  final String appointmentId;
  final Map<String, dynamic> appointment;
  AppointmentInfoM({required this.appointmentId, required this.appointment});
}

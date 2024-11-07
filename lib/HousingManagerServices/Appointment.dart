
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(HouseManager());
}

class HouseManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  final CollectionReference fetchData =
  FirebaseFirestore.instance.collection("Appointments");
  final CollectionReference appointments =
  FirebaseFirestore.instance.collection("SetAppointments");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Appointments',
            style: TextStyle(
              color: Color(0xFF339199),
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _getCombinedAppointments(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments found.'));
          } else {
            final appointmentsData = snapshot.data!;
            return ListView.builder(
              itemCount: appointmentsData.length,
              itemBuilder: (context, index) {
                final appointment = appointmentsData[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Color(0xFF007580), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      "Date: ${appointment['Date'] ?? 'N/A'} Time: ${appointment['Time'] ?? 'N/A'}",
                      style: TextStyle(
                        color: Color(0xFF339199),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF006064),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailsScreen(
                              appointmentId: appointment['id'] ?? '',
                              appointment: appointment,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF006064),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SetAppointmentScreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getCombinedAppointments() async {
    List<Map<String, dynamic>> combinedAppointments = [];

    try {
      // Fetch data from "Appointments" collection
      QuerySnapshot appointmentsSnapshot = await fetchData.get();
      combinedAppointments.addAll(
        appointmentsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add the document ID to the data
          return data;
        }).toList(),
      );

      // Fetch data from "SetAppointments" collection
      QuerySnapshot setAppointmentsSnapshot = await appointments.get();
      combinedAppointments.addAll(
        setAppointmentsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add the document ID to the data
          return data;
        }).toList(),
      );
    } catch (e) {
      print('Error fetching data: $e');
    }

    return combinedAppointments;
  }
}
class SetAppointmentScreen extends StatefulWidget {
  @override
  _SetAppointmentScreenState createState() => _SetAppointmentScreenState();
}

class _SetAppointmentScreenState extends State<SetAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  final CollectionReference setAppoint = FirebaseFirestore.instance.collection("SetAppointments");
  // Define the range limits
  final TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0); // 8 AM
  final TimeOfDay _endTime = TimeOfDay(hour: 16, minute: 0); // 4 PM

  Future<void> _selectTime(BuildContext context) async {
    // Show time picker
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? _startTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      // Convert TimeOfDay to DateTime for easy comparison
      DateTime selectedDateTime =
      DateTime(2000, 1, 1, newTime.hour, newTime.minute);
      DateTime startDateTime =
      DateTime(2000, 1, 1, _startTime.hour, _startTime.minute);
      DateTime endDateTime =
      DateTime(2000, 1, 1, _endTime.hour, _endTime.minute);

      if (selectedDateTime.isBefore(startDateTime) ||
          selectedDateTime.isAfter(endDateTime)) {
        // Notify user if the selected time is out of bounds
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a time between 8 AM and 4 PM')),
        );
      } else {
        // Update the state with the valid time
        setState(() {
          selectedTime = newTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Set Appointment',
              style: TextStyle(
                color: Color(0xFF339199),
                fontSize: 30,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('Select Date:',
                    style: TextStyle(
                      color: Color(0xFF339199),
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
                width: 420,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007580), width: 1.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 10),
                      child: Text(
                        '${selectedDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(
                          color: Color(0xFF339199),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    final DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (newDate != null && newDate != selectedDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('Select Time:',
                    style: TextStyle(
                      color: Color(0xFF339199),
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.only(top: 1, bottom: 5),
                height: 50,
                width: 420,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF007580), width: 1.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Center(
                    child: Text(
                      selectedTime != null
                          ? '${selectedTime!.format(context)}'
                          : 'Not selected',
                      style: TextStyle(
                        color: Color(0xFF339199),
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => _selectTime(context),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF339199), // Text color
            ),
            onPressed: () {
              setAppoint.add({
                'Date': DateFormat('yyyy-MM-dd').format(selectedDate).toString(),
                'Time': selectedTime!.format(context),
              });
            },
            child: Text('Save Appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }
}
class AppointmentDetailsScreen extends StatelessWidget {
  final String appointmentId; // The ID of the appointment
  final  appointment; // The appointment data
  final CollectionReference bappointments = FirebaseFirestore.instance.collection("Appointments");
  final CollectionReference appointments = FirebaseFirestore.instance.collection("SetAppointments");

  AppointmentDetailsScreen({required this.appointmentId, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // Directly access string values
    String date = appointment['Date']; // Assuming this is a string
    String time = appointment['Time']; // Assuming this is a string
    String re = appointment['RE']; // Assuming this is a string

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Appointment Details',
              style: TextStyle(
                color: Color(0xFF339199),
                fontSize: 30,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text('Date:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF339199),
                borderRadius: BorderRadius.circular(17.0),
              ),
              child: Center(
                child: Text(date,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Text('Time:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            Container(
              height: 40,

              decoration: BoxDecoration(
                color: Color(0xFF339199),
                borderRadius: BorderRadius.circular(17.0),
              ),
              child: Center(
                child: Text(time,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Text('The Reason:',
                style: TextStyle(color: Color(0xFF339199), fontSize: 25)),
            Container(
              height: 140,
              width: 420,
              decoration: BoxDecoration(
                color: Color(0xFF339199),
                borderRadius: BorderRadius.circular(17.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(re,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.only(left: 90, right: 90),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditAppointmentScreen(appointment: appointment),
                        ),
                      );
                    },
                    child: Text('Edit', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF339199)),
                  ),
                  SizedBox(width: 70,),
                  ElevatedButton(
                    onPressed: () {
                      appointments.doc(appointmentId).delete();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
            // Add buttons for Edit and Delete here (similar to previous example)
          ],
        ),
      ),
    );
  }}

class EditAppointmentScreen extends StatefulWidget {
  final DocumentSnapshot appointment;

  EditAppointmentScreen({required this.appointment,});

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late DateTime selectedDate;
  TimeOfDay? selectedTime;

  // Define the range limits
  final TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0); // 8 AM
  final TimeOfDay _endTime = TimeOfDay(hour: 16, minute: 0); // 4 PM

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.appointment['Date']); // Make sure the key matches the appointment structure
    selectedTime = TimeOfDay(
      hour: int.parse(widget.appointment['Time'].split(':')[0]),
      minute: int.parse(widget.appointment['Time'].split(':')[1].split(' ')[0]),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    // Time picker logic here...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Edit Appointment',
              style: TextStyle(
                color: Color(0xFF339199),
                fontSize: 30,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 50),
            // Date selection logic...
            // Time selection logic...
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF339199), // Button color
              ),
              onPressed: () {
                widget.appointment.reference.update({
                  'Date': DateFormat('yyyy-MM-dd').format(selectedDate),
                  'Time': selectedTime!.format(context),
                }).then((_) {
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update appointment: $error')),
                  );
                });
              },
              child: Text('Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

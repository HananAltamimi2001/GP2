import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

class RequestAndReturnFurniture extends StatefulWidget {
  const RequestAndReturnFurniture({super.key});

  @override
  State<RequestAndReturnFurniture> createState() => _RequestAndReturnFurnitureState();
}

class _RequestAndReturnFurnitureState extends State<RequestAndReturnFurniture> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  TextEditingController FurnitureService = TextEditingController();
  TextEditingController FurnitureType = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Furniture Service'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownList(
                hint: "Furniture Service",
                items: [
                  'Request Furniture',
                  'Return Furniture',
                ],
                onItemSelected: onFurnitureServiceSelected,
              ),

              Heightsizedbox(h: 0.02),

              DropdownList(
                hint: "Furniture Type",
                items: [
                  'Table',
                  'Bed',
                  'Bedside table',
                  'Curtain',
                  'Office Chair',
                ],
                onItemSelected: onFurnitureTypeSelected,
              ),

              Heightsizedbox(h: 0.02),

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

              Heightsizedbox(h: 0.02),

              OurCheckboxPledge(
                value: _isChecked,
                Pledge: 'I pledge to preserve the furniture and bear the responsibility for any damage.',
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  actionbutton(
                    onPressed: _uploadData,
                    background: dark1,
                    text: 'Submit Request',
                    fontsize: 0.047,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFurnitureServiceSelected(String service) {
    setState(() {
      FurnitureService.text = service;
    });
  }

  void onFurnitureTypeSelected(String type) {
    setState(() {
      FurnitureType.text = type;
    });
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      if (_isChecked) {
        _formKey.currentState!.save();

        String studentId = FirebaseAuth.instance.currentUser!.uid;
        DocumentReference studentDocRef =
        FirebaseFirestore.instance.collection('student').doc(studentId);

        try {
          DocumentReference furnitureRequestDocRef = await FirebaseFirestore
              .instance
              .collection('furnitureRequest')
              .add({
            'FurnitureService': FurnitureService.text,
            'FurnitureType': FurnitureType.text,
            'furnitureStatus': "pending",
            'pledged': true,
            'date': selectedDate,
            'time': selectedTime?.format(context),
            'studentInfo': studentDocRef,
            'upload date': DateTime.now(),
          });

          await studentDocRef.update({
            'furnitureRequests': FieldValue.arrayUnion([furnitureRequestDocRef])
          });

          FurnitureService.clear();
          FurnitureType.clear();

          setState(() {
            selectedDate = null;
            selectedTime = null;
            _isChecked = false;
          });

          InfoDialog("Furniture Service created successfully", context, buttons: [
            {"OK": () async => context.pop()},
          ]);
        } catch (e) {
          ErrorDialog("An error occurred while submitting the request", context, buttons: [
            {"OK": () async => context.pop()},
          ]);
        }
      } else {
        ErrorDialog("Please check the pledge to continue", context, buttons: [
          {"OK": () async => context.pop()},
        ]);
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class setLunchOrDinner extends StatefulWidget {
  const setLunchOrDinner({super.key, required this.setmenutype});
  final String setmenutype;
  @override
  State<setLunchOrDinner> createState() => setLunchOrDinnerState();
}

class setLunchOrDinnerState extends State<setLunchOrDinner> {
  final formKey = GlobalKey<FormState>(); // Form key to validate the form.
  TextEditingController mainCourse = TextEditingController();
  TextEditingController appetizers = TextEditingController();
  TextEditingController salad = TextEditingController();
  TextEditingController fruit = TextEditingController();
  TextEditingController drink = TextEditingController();
  TextEditingController additives = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: 'Set ${widget.setmenutype} Menu',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                textform(
                  controller: mainCourse,
                  hinttext: "Main Course",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write Main Course";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.02),
                textform(
                  controller: appetizers,
                  hinttext: "Appetizers",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write appetizers";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.02),
                textform(
                  controller: salad,
                  hinttext: "Salad",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write salad";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.02),
                textform(
                  controller: fruit,
                  hinttext: "Fruit",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write fruit";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.02),
                textform(
                  controller: drink,
                  hinttext: "Drink",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write drink";
                    }
                    return null;
                  },
                ),
                Heightsizedbox(h: 0.02),
                textform(
                  controller: additives,
                  hinttext: "Additives",
                  lines: 1,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Write additives";
                    }
                    return null;
                  },
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
                    return null;
                  },
                  labelText: "Select Menu Date:",
                ),
                Heightsizedbox(h: 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    actionbutton(
                      onPressed: _uploadData,
                      background: dark1,
                      text: 'Set',
                      fontsize: 0.047,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to upload data to Firebase Firestore.
  Future<void> _uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Create a unique document ID using the type and date
      String docId = "${widget.setmenutype}_${selectedDate?.toIso8601String()}";

      // Save the set lunch data to Firebase Firestore
      await FirebaseFirestore.instance.collection('dining').doc(docId).set({
        'menuType': widget.setmenutype,
        'mainCourse': mainCourse.text,
        'appetizers': appetizers.text,
        'salad': salad.text,
        'fruit': fruit.text,
        'drink': drink.text,
        'additives': additives.text,
        'menuDate': selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
      });

      // Clear the input field after submission
      mainCourse.clear();
      appetizers.clear();
      salad.clear();
      fruit.clear();
      drink.clear();
      additives.clear();

      // Show a confirmation message
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          backgroundColor: Color(0xFF339199),
          contentPadding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          children: [
            Center(
              child: Text(
                "${widget.setmenutype} Menu created successfully",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF007580),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

}

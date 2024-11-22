import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library
import 'package:intl/intl.dart';

class ViewMenu extends StatefulWidget {
  const ViewMenu({super.key, required this.menutype});
 final String menutype;

  @override
  State<ViewMenu> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {

  @override
  Widget build(BuildContext context) {
    // Get the formatted date string
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      appBar: OurAppBar(title: '$widget.menutype Menu'),
      body: FutureBuilder<QuerySnapshot>(
        future: fetchMenuData(), // Call the fetch function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: OurLoadingIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No ${widget.menutype} Menu available for today.'),
            );
          }

          // Get the first document data
          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  text(
                    t: 'For $formattedDate',
                    color: light1,
                    align: TextAlign.center,
                  ),
                  Heightsizedbox(h: 0.02),
                  Titletext(
                      t: "Main Course", align: TextAlign.center, color: dark1),
                  Heightsizedbox(h: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text(
                          t: data['mainCourse'] ?? 'N/A',
                          align: TextAlign.start,
                          color: light1),
                    ],
                  ),
                  Heightsizedbox(h: 0.02),
                  Titletext(
                      t: "Appetizers", align: TextAlign.center, color: dark1),
                  Heightsizedbox(h: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text(
                          t: data['appetizers'] ?? 'N/A',
                          align: TextAlign.start,
                          color: light1),
                    ],
                  ),
                  Heightsizedbox(h: 0.02),
                  Titletext(t: "Salad", align: TextAlign.center, color: dark1),
                  Heightsizedbox(h: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text(
                          t: data['salad'] ?? 'N/A',
                          align: TextAlign.start,
                          color: light1),
                    ],
                  ),
                  Heightsizedbox(h: 0.02),
                  Titletext(t: "Fruit", align: TextAlign.center, color: dark1),
                  Heightsizedbox(h: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text(
                          t: data['fruit'] ?? 'N/A',
                          align: TextAlign.start,
                          color: light1),
                    ],
                  ),
                  Heightsizedbox(h: 0.02),
                  Titletext(t: "Drink", align: TextAlign.center, color: dark1),
                  Heightsizedbox(h: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text(
                          t: data['drink'] ?? 'N/A',
                          align: TextAlign.start,
                          color: light1),
                    ],
                  ),
                ]),
          );
        },
      ),
    );
  }

  // Function to fetch the menu data as a Future
  Future<QuerySnapshot> fetchMenuData() {
    return FirebaseFirestore.instance
        .collection('dining')
        .where('menuType', isEqualTo: widget.menutype)
        .where(
      'menuDate',
      isEqualTo: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    ) // Change this if menuDate is Timestamp
        .get();
  }

}

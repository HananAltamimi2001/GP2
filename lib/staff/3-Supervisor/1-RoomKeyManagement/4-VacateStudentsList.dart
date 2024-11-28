import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class VacateStudentsList extends StatefulWidget {
  const VacateStudentsList({Key? key}) : super(key: key);

  @override
  _VacateStudentsListState createState() => _VacateStudentsListState();
}

class _VacateStudentsListState extends State<VacateStudentsList> {
  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    try {
      List<Map<String, dynamic>> requests = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('roomKey', isEqualTo: true)
          .where('checkStatus', isEqualTo: "Last Check-out")
          .get();

      for (var doc in snapshot.docs) {
        DocumentReference sturef = doc.reference;
        requests.add({
          'fullname': '${doc['efirstName']} ${doc['elastName']}',
          'sturef': sturef,
        });
      }

      return requests;
    } catch (e) {
      ErrorDialog(
        'Error fetching requests: $e',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: OurLoadingIndicator());
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: OurAppBar(title: "Departing Students"),
            body: Center(
                child: Text("An error occurred while fetching data")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: "Departing Students"),
            body: Center(child: Text("No Data found")),
          );
        }

        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: "Departing Students"),
          body: Column(
            children: [
              
              // Use Expanded on OurListView to allow it to take available space
              Expanded(
                child: OurListView(
                  data: requests,
                  leadingWidget: (item) => text(
                    t: '0${requests.indexOf(item) + 1}',
                    color: dark1,
                    align: TextAlign.start,
                  ),
                  trailingWidget: (item) => Dactionbutton(
                    height: 0.044,
                    width: 0.19,
                    text: 'View',
                    background: blue1,
                    fontsize: 0.03,
                    onPressed: () {
                      context.pushNamed('/VacateStudentView', extra: item['sturef']);
                    },
                  ),
                  title: (item) => item['fullname'] ?? 'No Name',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

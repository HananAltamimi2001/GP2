import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/4-QrScanner.dart';

class FirstCheckInList extends StatefulWidget {
  const FirstCheckInList({Key? key}) : super(key: key);

  @override
  _FirstCheckInListState createState() => _FirstCheckInListState();
}

class _FirstCheckInListState extends State<FirstCheckInList> {
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
          .where('checkStatus', isEqualTo: "First Check-in")
          .get();

      for (var doc in snapshot.docs) {
        DocumentReference sturef = doc.reference;
        requests.add({
          'fullname': '${doc['efirstName']} ${doc['elastName']}',
          'roomId': doc['roomref'].id,
          'PNUID': doc['PNUID'],
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

  TextEditingController _searchController = TextEditingController();
  void _performSearch() {
    String searchTerm = _searchController.text;

    print("Searching for: $searchTerm");
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
            appBar: OurAppBar(title: "First Check-in"),
            body: Center(child: Text("An error occurred while fetching data")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: "First Check-in"),
            body: Center(child: Text("No data found")),
          );
        }

        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: "First Check-in"),
          body: OurListView(
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
                padding: 0,
                background: blue1,
                fontsize: 0.03,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded corners
                          side: BorderSide(
                              color: blue1, width: 1), // Border color and width
                        ),
                        backgroundColor:
                            Colors.white, // Background color of the dialog
                        title: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: blue1.withOpacity(0.08),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Dtext(
                            t: 'Student Information',
                            align: TextAlign.center,
                            color: dark1,
                            size: 0.05,
                          ),
                        ),
                        titlePadding: EdgeInsets.zero,
                        content: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowInfo.buildInfoRow(
                                defaultLabel: 'Name',
                                value: item['fullname'] ?? 'No Name',
                              ),
                              Heightsizedbox(h: 0.01),
                              RowInfo.buildInfoRow(
                                defaultLabel: 'PNU ID',
                                value: item['PNUID'] ?? 'No ID',
                              ),
                              Heightsizedbox(h: 0.01),
                              RowInfo.buildInfoRow(
                                defaultLabel: 'Room Number',
                                value: item['roomId'] ?? 'No Room Number',
                              ),
                            ],
                          ),
                        ),
                        actionsPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                              context.pushNamed('/QrScanner1',
                                  extra: QrData(
                                      sturef: item['sturef'],
                                      Ceckstatus: 'First Check-in'));
                            },
                            child: Dtext(
                              t: "Scan",
                              align: TextAlign.center,
                              size: 0.03,
                              color: dark1,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: Dtext(
                              t: "Close",
                              align: TextAlign.center,
                              size: 0.03,
                              color: red1,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
            //     context.pushNamed('/viewk', extra: item['sturef']);
            //   },
            // ),
            title: (item) => item['PNUID'] ?? 'No Id',
          ),
        );
      },
    );
  }
}

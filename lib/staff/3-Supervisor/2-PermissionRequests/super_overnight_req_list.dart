import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SuperOvernightReqList extends StatefulWidget {
  const SuperOvernightReqList({super.key});

  @override
  State<SuperOvernightReqList> createState() => _SuperOvernightReqListState();
}

class _SuperOvernightReqListState extends State<SuperOvernightReqList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> visitorData = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> overnightData = [];
  TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    String searchTerm = _searchController.text;

    print("Searching for: $searchTerm");
  }

  @override
  void initState() {
    super.initState();
    //_fetchData();
    fetchRequests();
  }

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    print("Fetching overnight requests..."); // Print a message before fetching
    List<Map<String, dynamic>> requests = [];

    try {
      final snapshot = await _firestore
          .collection('OvernightRequest')
          .where('status', isEqualTo: 'pending')
          .get();
      overnightData = snapshot.docs;

      print(
          "Number of requests found: ${snapshot.docs.length}"); // Print number of requests
      for (var doc in snapshot.docs) {
        DocumentReference studentinfo = doc['studentInfo'];
        DocumentSnapshot studentSnapshot = await studentinfo.get();

        String firstName = studentSnapshot['firstName'] ?? 'N/A';
        String lastName = studentSnapshot['lastName'] ?? 'N/A';
        String status = doc['status'];

        print(
            "Processing request: ${doc.id}"); // Print ID of request being processed

        requests.add({
          'fullName': '$firstName $lastName',
          'requestId': doc.id,
          'status': status
        });
      }
      print("Successfully fetched requests!"); // Print success message

      return requests;
    } catch (e) {
      print("Error fetching requests: $e");
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
            appBar: OurAppBar(title: 'Permission Requests'),
            body: Center(
                child: Text("An error occurred while fetching requests")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: 'Permission Requests'),
            body: Center(child: Text("No requests found")),
          );
        }
        List<Map<String, dynamic>> requests = snapshot.data!;

        return Scaffold(
          appBar: OurAppBar(title: 'Visitor Requests'),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Color(0xFF339199)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _performSearch();
                      },
                    ),
                  ),
                ),
              ),
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
                    background: dark1,
                    fontsize: 0.03,
                    onPressed: () {
                      context.pushNamed(
                        '/superovernightview',
                        extra: overnightInfo(overnight: item['requestId']),
                      );
                    },
                  ),
                  title:(item)=> item['fullName'],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class overnightInfo {
  String overnight;

  overnightInfo({required this.overnight});
}

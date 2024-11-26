import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SearchForStudentM extends StatefulWidget {
  const SearchForStudentM({super.key});

  @override
  State<SearchForStudentM> createState() => _SearchForStudentMState();
}

class _SearchForStudentMState extends State<SearchForStudentM> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String searchTerm = _searchController.text.trim();

      if (searchTerm.isEmpty) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        return;
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('resident', isEqualTo: true)
          .where('PNUID', isEqualTo: searchTerm)
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return {
          'fullname': doc['efullName'],
          'sturef': doc.reference,
        };
      }).toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      print("Error during search: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Search for Student'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search By PNUID',
                labelStyle: TextStyle(color: Color(0xFF339199)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: OurLoadingIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: text(
                          t: "No students found.",
                          align: TextAlign.center,
                          color: grey1,
                        ),
                      )
                    : OurListView(
                        data: _searchResults,
                        trailingWidget: (item) => Dactionbutton(
                          height: 0.044,
                          width: 0.19,
                          text: 'View',
                          background: dark1,
                          fontsize: 0.03,
                          onPressed: () {
                            context.goNamed('/StudentView1',
                                extra: item['sturef']);
                          },
                        ),
                        title: (item) => item['fullname'] ?? 'No Name',
                      ),
          ),
        ],
      ),
    );
  }
}

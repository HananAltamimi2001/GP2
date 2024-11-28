import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class ViewFurnitureRequests extends StatefulWidget {
  const ViewFurnitureRequests({Key? key}) : super(key: key);

  @override
  ViewFurnitureRequestsState createState() => ViewFurnitureRequestsState();
}

class ViewFurnitureRequestsState extends State<ViewFurnitureRequests> {
  final List<Map<String, dynamic>> requests = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchUserRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'View Requests'),
      body:
          isLoading
          ? Center(child: OurLoadingIndicator()) // Show loading indicator
          :  requests.isEmpty
          ? Center( // Display message when no complaints
        child: Text(
          "No Request found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          final furnitureStatus = request['furnitureStatus'] ?? 'Pending';
          final FurnitureType = request['FurnitureType'];
          final FurnitureService = request['FurnitureService'];
          final String Service;
          if(FurnitureService == "Request Furniture"){
            Service = "Request";
          }
          else{
            Service = "Return";
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: OurContainer( borderRadius: 20 ,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                 t: '${index + 1} - $FurnitureType $Service',
                 color: light1,
                 align: TextAlign.start,
                ),
               Heightsizedbox(h: 0.01),
              Center(child: StatusStep(furnitureStatus: furnitureStatus),
               // const Divider(height: 20, thickness: 1),
              ), ],
            ),),
          );
        },
      ),
    );
  }

  Future<void> fetchUserRequests() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference studentRef = FirebaseFirestore.instance.collection('student').doc(userId);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('furnitureRequest')
          .where('studentInfo', isEqualTo: studentRef)
          .get();

      setState(() {
        List<Map<String, dynamic>> nonRejectedRequests = [];
        List<Map<String, dynamic>> rejectedRequests = [];
        isLoading = false;

        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          if (data['furnitureStatus'] == 'Reject') {
            rejectedRequests.add(data);
          } else {
            nonRejectedRequests.add(data);
          }
        }

        requests
          ..clear()
          ..addAll(nonRejectedRequests)
          ..addAll(rejectedRequests);
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      ErrorDialog(
        'Error fetching furniture requests',
        context,
        buttons: [
          {
            "Ok": () => context.pop(),
          },
        ],
      );
      print('Error fetching furniture requests: $e');
    }
  }
}

class StatusStep extends StatelessWidget {
  final String furnitureStatus;

  StatusStep({required this.furnitureStatus});

  List<Map<String, dynamic>> _getStatusInfo() {
    final steps = [
      {'step': '1', 'label': 'Pending'},
      {'step': '2', 'label': 'Accept OR Reject'},
      {'step': '3', 'label': 'Execute'},
    ];

    int activeStep;
    switch (furnitureStatus) {
      case 'Pending':
        activeStep = 1;
        break;
      case 'Accept':
        activeStep = 2;
        break;
      case 'Reject':
        activeStep = 3;
        break;
      case 'Execute':
        activeStep = 3;
        break;
      default:
        activeStep = 1;
    }

    return steps.map((step) {
      return {
        'step': step['step'],
        'label': step['label'],
        'isActive': int.parse(step['step'] as String) <= activeStep,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (furnitureStatus == 'Reject') {
      // Display "The request is rejected" in red if the status is "Reject"
      return Dtext(
        t: "The request is rejected",
        color: red1,
        align: TextAlign.center,
        size: 0.045,

      );
    }

    // Continue with the usual step indicator display for other statuses
    final statusInfo = _getStatusInfo();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: statusInfo.map((info) {
        return _buildStatusStep(
          info['step'],
          info['label'],
          info['isActive'],
          furnitureStatus,
          context,
        );
      }).toList(),
    );
  }

  Widget _buildStatusStep(String number, String label, bool isActive, String status, BuildContext context ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: status == 'Reject'
              ? red1
              : (isActive ? green1 : grey1),
          child: text(
           t: number,
           color: Colors.white,
           align: TextAlign.center,
          ),
        ),
        Heightsizedbox(h: 0.003),
        Dtext(
            t:label,
            color: isActive ? Colors.black : grey1,
            align: TextAlign.center,
            size: 0.03,
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyRequestDetails extends StatelessWidget {
  final EmregencyInfo args;

  const EmergencyRequestDetails({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('student')
          .where('PNUID', isEqualTo: args.pnuid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: OurAppBar(title: ''),
            body: Center(child: CircularProgressIndicator(color: dark1)),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: OurAppBar(title: 'Request Details'),
            body: Center(child: Text('Error loading student details')),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: OurAppBar(title: 'Request Details'),
            body: Center(child: Text('Student not found')),
          );
        }

        final studentData =
        snapshot.data!.docs.first.data() as Map<String, dynamic>;


        final String roomId = studentData['roomref'] != null
            ? (studentData['roomref'] as DocumentReference).id
            : 'N/A';


        return Scaffold(
          appBar: OurAppBar(title: studentData['efirstName'] +' '+ studentData['elastName'] ?? 'N/A'),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                text(t:"Student Info:" , align:TextAlign.start, color: dark1,),

                OurContainer(
                  child: Column(children: [
                    RowInfo.buildInfoRow(
                        defaultLabel: 'PNU ID',
                        value: studentData['PNUID'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Email',
                        value: studentData['email'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Phone',
                        value: studentData['phoneNumber'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Room ID',
                        value: roomId),
                    Row(children: [
                      Dtext(
                        t: 'Medical Report:',
                        align: TextAlign.center,
                        color: dark1,
                        size: 0.035,
                      ),

                      Widthsizedbox(w: 0.03) ,

                      Dactionbutton(
                          fontsize: 0.03,
                          onPressed:() {context.pushNamed(
                            '/pdf3',
                            extra: Pdf(
                                Url: studentData['medicalReportUrl'],
                                title: "Medical Report"),
                          );}, text: "view", background: blue1)
                    ]),
                  ]),
                ),

                Heightsizedbox(h: 0.02),

                text(t:"Emergency Contact Info:" , align:TextAlign.start, color: dark1,),

                OurContainer(
                  child: Column(children: [
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Emergency Phone One',
                        value: studentData['e1phoneNumber'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Emergency Email One',
                        value: studentData['e1email'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Emergency Phone Two',
                        value: studentData['e2phoneNumber'] ?? 'N/A'),
                    RowInfo.buildInfoRow(
                        defaultLabel: 'Emergency Email Two',
                        value: studentData['e2email'] ?? 'N/A'),
                  ]),
                ),

                Heightsizedbox(h: 0.03),

                actionbutton(
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${args.location.latitude},${args.location.longitude}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not open Google Maps.';
                    }
                  },
                  text: 'Location',
                  background: red1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmregencyInfo {
  final String pnuid;
  final String requestId;
  final GeoPoint location;

  EmregencyInfo({
    required this.pnuid,
    required this.requestId,
    required this.location,
  });
}


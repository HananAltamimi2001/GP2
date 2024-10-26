import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class HousingServices extends StatelessWidget {
  const HousingServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Housing Services"),
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(0.32),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Service_button(
                    icon: Icons.assignment_turned_in_rounded,
                    name: "Daily Attendance",
                    onPressed: () {   context.goNamed("/hi");
              },
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: Icons.medical_services,
                    name: "Emergency Service ",
                    onPressed: () {}
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: Icons.chair,
                    name: "Furniture Service",
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: Icons.construction,
                    name: "Maintenance Service",
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: MdiIcons.homeExportOutline,
                    name: "Request to vacate housing",
                  ),
                ],
              ),
              Widthsizedbox(w: 0.03),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Service_button(
                    icon: MdiIcons.fileDocumentCheckOutline,
                    name: "Permission Request ",
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: MdiIcons.silverware,
                    name: "Dining Service",
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: Icons.calendar_month,
                    name: "Book Appointment",
                  ),
                  Heightsizedbox(h: 0.015),
                  Service_button(
                    icon: MdiIcons.chatAlertOutline,
                    name: "Complaints",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Service_button extends StatelessWidget {
  const Service_button({
    super.key,
    required this.icon,
    required this.name,
    this.onPressed,
  });
  final IconData icon;
  final String name;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.20, //0.19
      width: screenHeight * 0.20, //0.20
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(children: [
        Heightsizedbox(h: 0.02),
        /* Container(
          height: screenHeight * 0.08,
          width: screenHeight * 0.08,
          decoration: BoxDecoration(
            color: dark1,
            borderRadius: BorderRadius.all(Radius.circular(90)),
          ),
          child: */
        /*Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: dark1, // Shadow color
          spreadRadius: 2, // The spread of the shadow
          blurRadius: 10,   // How soft the shadow is
          offset: Offset(4, 4), // Shadow position (x, y)
        ),
      ],
    ),
    child :*/
        /* Material(color: dark1,
          elevation: 8, // Elevation controls the shadow
          shape: CircleBorder(), // Optional, for circular shadow
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Optional, for some space around the icon
            child:*/
        Stack(children: [
          Positioned(
            top: 4, // Offset shadow position
            left: 4,
            right: 4,
            bottom: 4,
            child: Icon(
              icon,
              size: SizeHelper.getSize(context) * 0.16,
              color: dark1.withOpacity(0.9), // Shadow color and opacity
            ),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: SizeHelper.getSize(context) * 0.16,
            //shadows: [Shadow(color: dark1),BoxShadow(color: dark1, spreadRadius: 2, blurRadius: 8, ),],
          ),
        ]),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "$name",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
          ),
        ),
      ]),
    );
  }
}


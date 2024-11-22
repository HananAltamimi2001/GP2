import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class SuperPermissionRequests extends StatefulWidget {
  const SuperPermissionRequests({super.key});

  @override
  State<SuperPermissionRequests> createState() => _SuperPermissionRequestsState();
}

class _SuperPermissionRequestsState extends State<SuperPermissionRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Permission Requests",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Dactionbutton(
                  text: 'Overnight request',
                  onPressed: () {
                    context.pushNamed('/superovernightlist');
                  },
                  background: light1,
                  width: 0.9,
                  height: 0.09,
                  fontsize: 0.06,
                ),
              ),
              Heightsizedbox(
                h: 0.04,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Dactionbutton(
                  onPressed: () {
                    context.pushNamed('/supervisitorlist');
                  },
                  background: light1,
                  text: "Visitor request",
                  width: 0.9,
                  height: 0.090,
                  fontsize: 0.06,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// return Scaffold(
//   appBar: OurAppBar(
//     title: "Permission Requests",
//   ),
//   body: Padding(
//     padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
//     child: combinedData.isEmpty
//         ? Center(
//             child: text(
//               align: TextAlign.center,
//               t: 'No requests found.',
//               color: grey1,
//             ),
//           )
//         : OurListView(
//             data: combinedData,
//             title: "fullName",
//             leadingWidget: (item) => text(
//                 t: "${combinedData.indexOf(item) + 1}.",
//                 align: TextAlign.start,
//                 color: dark1),
//             trailingWidget: (item) => Dactionbutton(
//               height: 0.044,
//               width: 0.2,
//               text: 'View',
//               background: dark1,
//               fontsize: 0.04,
//               onPressed: () {
//                 if (item.reference.path.contains('OvernightRequest')) {
//                   context.pushNamed(
//                     '/superovernightview',
//                     extra: overnightInfo(overnight: overnightData),
//                   );
//                 } else {
//                   context.pushNamed(
//                     '/supervisitorview',
//                     extra: visitorInfo(visitor: visitorData),
//                   );
//                 }
//               },
//             ),
//           ),
//   ),
// );

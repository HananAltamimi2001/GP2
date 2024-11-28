import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';

class StudentNavBar extends StatefulWidget {
  final Widget child;
  const StudentNavBar({
    required this.child,
  });

  @override
  State<StudentNavBar> createState() => _StudentNavBarState();
}

class _StudentNavBarState extends State<StudentNavBar> {
  int _currentIndex = 2;
  // Holds navigation state
  @override
  Widget build(BuildContext context) {
    Future<void> _onTap(int index) async {
      // Check if the selected index is the current one to avoid unnecessary reloads
      setState(() {
        _currentIndex = index;
      });
      switch (index) {
        case 0:
          // Switch to the selected tab

          GoRouter.of(context).go('/studentprofile');
          break; // Add break to prevent fallthrough
        case 1:
          // Switch to the selected tab
          bool resident = await isResident();
          if (resident) {
            GoRouter.of(context).go('/student_announcements_and_events');
          } else {
            ErrorDialog(
                "Sorry, you don't have access to this page, since you ar not resident student",
                context,
                buttons: [
                  {'Ok': () =>{context.pop(),}}
                ]);
          }
          break; // Add break to prevent fallthrough
        case 2:
          // Switch to the selected tab
          GoRouter.of(context).go('/studenthome');
          break; // Add break to prevent fallthrough
        default:
          // Switch to the selected tab
          GoRouter.of(context).go('/studenthome');
          break; // Add break to prevent fallthrough
      }
    }

    return Scaffold(
      body: widget.child, // Displays the content of the current tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: dark1,
        unselectedItemColor: dark1,
        items: [
          // Profile tab
          BottomNavigationBarItem(
            icon: _currentIndex == 0 // If the tab is selected
                ? Icon(MdiIcons.faceWomanShimmer, size: 30) // Active icon
                : Icon(MdiIcons.faceWomanShimmerOutline, size: 30),
            // Inactive icon
            label: "",
          ),

          // Announcements tab
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Icon(MdiIcons.bullhorn, size: 30)
                : Icon(MdiIcons.bullhornOutline, size: 30),
            label: "",
          ),
          // Home tab
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? Icon(Icons.home, size: 30)
                : Icon(Icons.home_outlined, size: 30),
            label: "",
          ),
        ],
      ),
    );
  }
}

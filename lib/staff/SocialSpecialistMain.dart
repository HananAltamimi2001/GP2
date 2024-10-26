import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// 'package:studenthousing/SocialSpecialistAccount.dart';
//import 'package:studenthousing/SocialSpecialistHome.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class StaffMain extends StatefulWidget {
  final Widget
      bodyContent; // Wid, required StudentHomePage bodyContentget to display in the body

  const StaffMain({Key? key, required this.bodyContent}) : super(key: key);

  @override
  _StaffMainState createState() => _StaffMainState();
}

class _StaffMainState extends State<StaffMain> {
  int _selectedIndex = 2; // Default index for Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacementNamed(context, '/studenthome');
        case 1:
          Navigator.pushReplacementNamed(context, '/student_announcements_and_events');
        case 2:
          Navigator.pushReplacementNamed(context, '/studenthome');
        default:
          Navigator.pushReplacementNamed(context, '/studenthome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.bodyContent, // The bodyContent passed when navigating
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(
                    MdiIcons.faceWomanShimmer,
                    size: 30,
                  )
                : Icon(
                    MdiIcons.faceWomanShimmerOutline,
                    size: 30,
                  ),
            label: " ",
          ),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? Icon(
                      MdiIcons.bullhorn,
                      size: 30,
                    )
                  : Icon(
                      MdiIcons.bullhornOutline,
                      size: 30,
                    ),
              label: " "),
          BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? Icon(
                      Icons.home,
                      size: 30,
                    )
                  : Icon(
                      Icons.home_outlined,
                      size: 30,
                    ),
              label: " "),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: dark1,
        unselectedItemColor: dark1,
        onTap: _onItemTapped,
      ),
    );
  }
}

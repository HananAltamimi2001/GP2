import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';

class StaffNavBar extends StatefulWidget {
  final Widget child;
  final String staffRole;

  const StaffNavBar({required this.child, required this.staffRole});

  @override
  State<StaffNavBar> createState() => _StaffNavBarState();
}

class _StaffNavBarState extends State<StaffNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize _currentIndex based on staffRole
    if (widget.staffRole == 'Resident student supervisor' ||
        widget.staffRole == 'Housing security guard') {
      _currentIndex = 2;
    } else {
      _currentIndex = 1;
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate based on role and selected tab
    if (widget.staffRole == 'Resident student supervisor') {
      switch (index) {
        case 0:
          GoRouter.of(context).goNamed('/profile');
          break;
        case 1:
          GoRouter.of(context).goNamed('/notifications1');
          break;
        case 2:
          navigateBasedOnRole(context, widget.staffRole);
          break;
        default:
          navigateBasedOnRole(context, widget.staffRole);
          break;
      }
    } else if (widget.staffRole == 'Housing security guard') {
      switch (index) {
        case 0:
          GoRouter.of(context).goNamed('/profile');
          break;
        case 1:
          GoRouter.of(context).goNamed('/notifications2');
          break;
        case 2:
          navigateBasedOnRole(context, widget.staffRole);
          break;
        default:
          navigateBasedOnRole(context, widget.staffRole);
          break;
      }
    } else {
      switch (index) {
        case 0:
          GoRouter.of(context).goNamed('/profile');
          break;
        case 1:
          navigateBasedOnRole(context, widget.staffRole);
          break;
        default:
          navigateBasedOnRole(context, widget.staffRole);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: _currentIndex == 0
            ? Icon(MdiIcons.faceWomanShimmer, size: 30)
            : Icon(MdiIcons.faceWomanShimmerOutline, size: 30),
        label: "",
      ),
    ];

    if (widget.staffRole == 'Resident student supervisor' ||
        widget.staffRole == 'Housing security guard') {
      items.add(
        BottomNavigationBarItem(
          icon: _currentIndex == 1
              ? Icon(Icons.notifications_active, size: 30)
              : Icon(Icons.notifications_active_outlined, size: 30),
          label: "",
        ),
      );
    }

    items.add(
      BottomNavigationBarItem(
        icon: (_currentIndex ==
                (widget.staffRole == 'Resident student supervisor' ||
                        widget.staffRole == 'Housing security guard'
                    ? 2
                    : 1))
            ? Icon(Icons.home, size: 30)
            : Icon(Icons.home_outlined, size: 30),
        label: "",
      ),
    );

    return Scaffold(
      body: widget.child, // Displays the content of the current tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: dark1,
        unselectedItemColor: dark1,
        items: items,
      ),
    );
  }
}

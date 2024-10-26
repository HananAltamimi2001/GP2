import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
// Auth
import 'package:pnustudenthousing/authentication/ForgetPass.dart';
import 'package:pnustudenthousing/authentication/Login.dart';
import 'package:pnustudenthousing/authentication/Register.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';
import 'package:pnustudenthousing/authentication/SetPassword.dart';
import 'package:pnustudenthousing/authentication/SplashScreen.dart';
import 'package:pnustudenthousing/helpers/staffnavbar.dart';
// Student
import 'package:pnustudenthousing/student/HousingServices.dart';
import 'package:pnustudenthousing/student/StudentHomePage.dart';
import 'package:pnustudenthousing/helpers/StudentNavBar.dart';
import 'package:pnustudenthousing/student/StudentProfile.dart';
import 'package:pnustudenthousing/student/announcements_and_events_page.dart';
// Staff
import 'package:pnustudenthousing/staff/NutritionSpecialist.dart/SetMenus.dart';
import 'package:pnustudenthousing/staff/StaffProfile.dart';
import 'package:pnustudenthousing/staff/buildingsOfficer/buildingsOfficerHome.dart';
//import 'package:pnustudenthousing/staff/manager/AddStaff.dart';
import 'package:pnustudenthousing/staff/manager/ManagerHomePage.dart';
import 'package:pnustudenthousing/staff/security/SecurityHome.dart';
import 'package:pnustudenthousing/staff/security/checkInOut.dart';
import 'package:pnustudenthousing/staff/socialspecialist/SocialSpecialistHome.dart';
import 'package:pnustudenthousing/staff/studentaffairs/StudentsAffairsHome.dart';
import 'package:pnustudenthousing/staff/supervisor/SupervisorHome.dart';
import 'package:pnustudenthousing/staff/supervisor/roomKeyManagement.dart';

//////////////////// Routes Order ////////////////////
// 0 auth
// 1 student
// 2 staff
// 2.1 Housing manager
// 2.2 Students affairs officer
// 2.3 Resident student supervisor
// 2.4 Housing buildings officer
// 2.5 Nutrition specialist
// 2.6 Social Specialist
// 2.7 Housing security guard

// naming system will be explained with ohood or hanan
// numbring system is a
//1
//1.1
//1.1.1
// and will be explained too with ohood and hanan
//example
  //     GoRoute(
  //       path: '/A', // Manager Page
  //       builder: (context, state) => const ManagerPage(),
  //       routes: [
  //         !!! button 1 of home page !!!
  //         GoRoute(
  //           path: 'A1', // Manager Section 1
  //           builder: (context, state) => const ManagerSection1Page(),
  //           routes: [
  //             GoRoute(
  //               !!! button A1a of A1  !!!
  //               path: 'A1a', // Manager Section 1a
  //               builder: (context, state) => const ManagerSection1aPage(),
  //             ),
  //             GoRoute(
  //               !!! button A1b of A1  !!!
  //               path: 'A1b', // Manager Section 1b
  //               builder: (context, state) => const ManagerSection1bPage(),
  //             ),
  //           ],
  //         ),
  //          !!! button 2 of home page !!!
  //         GoRoute(
  //           path: 'A2', // Manager Section 2
  //           builder: (context, state) => const ManagerSection2Page(),
  //         ),
  //       ],
  //     ),
  //   ],
  // );

//////////////////// Routes ////////////////////
final staffrole = RouteUsers.staffRole;
final GoRouter router = GoRouter(
  initialLocation: '/',

  // 0
  // do not touch
  // Warning. Human proximity detected. Unauthorized touch sequence initiated. Aborting.'_'
  //////////////////// Auth ////////////////////
  routes: [
    //  initialLocation of our app
    //0
    GoRoute(
        name: '/', path: '/', builder: ((context, state) => splashScreen())),
    // 0.1
    GoRoute(
        name: '/login',
        path: '/login',
        builder: ((context, state) => LoginScreen()),
        // Inside login page we have forgetpass and registe the registe have inside it set pass
        routes: [
          // 0.1.1
          GoRoute(
              name: '/forgetpass',
              path: 'forgetpass',
              builder: ((context, state) => Forgetpass())),
          // 0.1.2
          GoRoute(
              name: '/register',
              path: 'register',
              builder: ((context, state) => RegisterScreen()),
              routes: [
                // 0.1.2.1

                GoRoute(
                    name: '/setpass',
                    path: 'setpass',
                    builder: (context, state) {
                      final args = state.extra as SetPassArguments;
                      return SetPass(args: args);
                    }),
              ]),
        ]),
    // 1
    //////////////////// Student ////////////////////
    /// Student pages has 3 tabs for naivgation
    ShellRoute(
      builder: (context, state, child) {
        return StudentNavBar(
            child: child); // Our scaffold with a navigation bar
      },
      routes: [
        // 1.1
        // do not touch gurll I see you '_'
        GoRoute(
          name: '/studentprofile',
          path: '/studentprofile',
          builder: (context, state) => const studentprofile(),
        ),
        // 1.2
        // do not touch girl I see you '_'
        GoRoute(
          name: '/student_announcements_and_events',
          path: '/student_announcements_and_events',
          builder: (context, state) => const AnnouncementsAndEvents(),
        ),

        // student home have alot of pages and here the team gonna put all their related work inside the routes
        // 1.3
        // do not touch girl I see you '_'
        GoRoute(
          name: '/studenthome',
          path: '/studenthome',
          builder: (context, state) => const StudentHomePage(),
          routes: <RouteBase>[
            // button 1 about us
            // 1.3.1
            //GoRoute(
            //     name: '/housingservices',
            //     path: 'housingservices',
            //     builder: (context, state) => const HousingServices(),),

            // button 2 contact us
            // 1.3.2
            //GoRoute(
            //     name: '/housingservices',
            //     path: 'housingservices',
            //     builder: (context, state) => const HousingServices(),
            //     routes: [
            // button 1 housing staff
            //       // 1.3.2.1
            //       // GoRoute(
            //       //   name: '/hi',
            //       //   path: 'hi',
            //       //   builder: (context, state) =>  SimpleAppBarPage(),
            //       // ),
            // button 2 app developers
            //       // 1.3.2.1
            //       // GoRoute(
            //       //   name: '/hi',
            //       //   path: 'hi',
            //       //   builder: (context, state) =>  SimpleAppBarPage(),
            //       // ),
            //     ])

            // button 3  apply for housing
            // 1.3.3
            // GoRoute(
            //     name: '/housingservices',
            //     path: 'housingservices',
            //     builder: (context, state) => const HousingServices(),
            //

            // button 4 housing services
            GoRoute(
                name: '/housingservices',
                path: 'housingservices',
                builder: (context, state) => const HousingServices(),
                // here the inner pages or the buttons of the housing services page
                // here you go girl ;) here's your runway to shine walk your beautiful pages down this digital path
                routes: [
                  // 1.3.1.2
                  // GoRoute(
                  //   name: '/hi',
                  //   path: 'hi',
                  //   builder: (context, state) =>  SimpleAppBarPage(),
                  // ),
                ]),
          ],
        ),
      ],
    ),
    // 2
    ///////////////////// Staff ////////////////////
    // staff have different home pages each has their own services so
    // I divided the staffs by role and they have one profile for all but do not touch I see you '_'
    // security and supervisor have new tab but do not touch I see you '_'

    ShellRoute(
      builder: (context, state, child) {
        return StaffNavBar(child: child, staffRole: staffrole);
      },
      routes: [
        // Warning. Human proximity detected. Unauthorized touch sequence initiated. Aborting.
        // 1
        GoRoute(
          name: '/profile',
          path: '/profile',
          builder: (context, state) => Staffprofile(),
        ),
        // do not touch I STILL see you '_'
        // Oh you are hanan ok gurl do your move
        // change the class
        // 2
        GoRoute(
          name: '/notifications',
          path: '/notifications',
          builder: (context, state) => AnnouncementsAndEvents(),
        ),

        // 2 Staff routes
        // 2.1 Housing manager
        GoRoute(
          name: '/manager',
          path: '/manager',
          builder: (context, state) => Managerhomepage(),
          routes: <RouteBase>[
            // GoRoute(
            //   name: '/addstaff',
            //   path: 'addstaff',
            //   builder: (context, state) => addStaff(),
            // ),
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),

        // 2.2 Students affairs officer
        GoRoute(
          name: '/studentsAffairs',
          path: '/studentsAffairs',
          builder: (context, state) => StudentAffairsHome(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
        // 2.3 Resident student supervisor
        GoRoute(
          name: '/supervisor',
          path: '/supervisor',
          builder: (context, state) => SupervisorHome(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
        // 2.4 Housing buildings officer
        GoRoute(
          name: '/buildingsOfficer',
          path: '/buildingsOfficer',
          builder: (context, state) => buildingsOfficerHome(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
        // 2.5 Nutrition specialist
        GoRoute(
          name: '/nutritionSpecialist',
          path: '/nutritionSpecialist',
          builder: (context, state) => SetMenus(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
        // 2.6 Social Specialist
        GoRoute(
          name: '/socialSpecialist',
          path: '/socialSpecialist',
          builder: (context, state) => SocialSpecialistHome(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
        // 2.7 Housing security guard
        GoRoute(
          name: '/security',
          path: '/security',
          builder: (context, state) => SecurityHome(),
          routes: <RouteBase>[
            GoRoute(
              name: '/checkinout',
              path: 'checkinout',
              builder: (context, state) => const checkInOut(),
            ),
            //!!!!!!! add another page if required !!!!!!!\\

            // GoRoute(
            //   name: '/example',
            //   path: '',
            //   builder: (context, state) => const classname(),
            // ),
          ],
        ),
      ],
    ),
  ],
  // error routing screen
  errorBuilder: (context, state) => const ErrorScreen(),
);

// error screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR routing'),
      ),
    );
  }
}

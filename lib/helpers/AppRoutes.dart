import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/StaffNavBar.dart';
import 'package:pnustudenthousing/helpers/DataManger.dart';
import 'package:pnustudenthousing/helpers/StudentNavBar.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';
// Auth
import 'package:pnustudenthousing/authentication/ForgetPass.dart';
import 'package:pnustudenthousing/authentication/Login.dart';
import 'package:pnustudenthousing/authentication/Register.dart';
import 'package:pnustudenthousing/authentication/SetPassword.dart';
import 'package:pnustudenthousing/authentication/SplashScreen.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/AppointmentDetailesSp.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/StudentFiles.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/viewfiles.dart';

// Student
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/0-HousingServices.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/overnight_request.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/permission_request.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/status/overnight_req_status.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/status/visitor_req_status.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/view_requests.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/3-Permission/visitor_request.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/BookAppointment.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/TakeAppointmentWthSocialSpecialistState.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/TakeAppointmentsHousingWthManager.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/ViewReservedAppointments.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/6-Appointment/viewAppointmentDetails.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/7-Maintenance.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/9-Vacate.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/2-Emegrency.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/1-DailyAttendence.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/complaints.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/complaintsdetails.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/sendcomplaint.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/8-Complaints/viewcomplaints.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/5-Furniture/Furniture%20Service.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/5-Furniture/RequestAndReturnFurniture.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/5-Furniture/ViewFurnitureRequests.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/4-Dining/ViewMenu.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/4-Dining/copun.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/4-Dining/dining.dart';
import 'package:pnustudenthousing/student/3-StudentHome/1-Services/4-Dining/menu.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/3-Files.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/2-Information.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/1-Instructions.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/4-Pledge.dart';
import 'package:pnustudenthousing/student/3-StudentHome/2-AboutUS.dart';
import 'package:pnustudenthousing/student/3-StudentHome/5-FAQs.dart';
import 'package:pnustudenthousing/student/3-StudentHome/0-StudentHomePage.dart';
import 'package:pnustudenthousing/student/3-StudentHome/4-ContactUs/AppDevelopers.dart';
import 'package:pnustudenthousing/student/3-StudentHome/4-ContactUs/ContactUs.dart';
import 'package:pnustudenthousing/student/3-StudentHome/4-ContactUs/HousingStaff.dart';
import 'package:pnustudenthousing/student/1-StudentProfile.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/AnnouncementsDetails.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/EventDetails.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/ViewAnnouncements.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/ViewEvents.dart';
import 'package:pnustudenthousing/student/2-Announcements&Events/announcements_and_events_page.dart';
// Staff

import 'package:pnustudenthousing/staff/1-Manager/1-SearchForStudent/1-Search.dart';
import 'package:pnustudenthousing/staff/1-Manager/1-SearchForStudent/2-View.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/4-SearchForStudent/1-Search.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/4-SearchForStudent/2-View.dart';
import 'package:pnustudenthousing/staff/1-Manager/3-Appointment/Appointment.dart';
import 'package:pnustudenthousing/staff/1-Manager/3-Appointment/AppointmentDetails.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/3-Attendance/DayAttendance.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/3-Attendance/StudentDetailsPage.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/3-Attendance/WeekAttendance.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/SupervisorNotifications.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/Appointmentsp.dart';
import 'package:pnustudenthousing/staff/7-Security/2-SearchForStudent/2-View.dart';
import 'package:pnustudenthousing/staff/7-Security/2-SearchForStudent/1-Search.dart';
import 'package:pnustudenthousing/staff/7-Security/EmergencyRequestDetailsPage.dart';
import 'package:pnustudenthousing/staff/7-Security/SecurityNotification.dart';
import 'package:pnustudenthousing/staff/5-NutritionSpecialist.dart/SetMenus.dart';
import 'package:pnustudenthousing/staff/0-StaffProfile.dart';
import 'package:pnustudenthousing/staff/1-Manager/0-ManagerHomePage.dart';
import 'package:pnustudenthousing/staff/7-Security/0-SecurityHome.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/1-CheckInOut.dart';
import 'package:pnustudenthousing/staff/6-SocialSpecialist/SocialSpecialistHome.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/0-StudentsAffairsHome.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/0-SupervisorHome.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/1-RoomKeyManagement/1-RoomKeyManagement.dart';
import 'package:pnustudenthousing/staff/1-Manager/4-AddStaff.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/1-RoomKeyManagement/2-NewStudentList.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/1-RoomKeyManagement/3-NewStudentView.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/1-RoomKeyManagement/4-VacateStudentsList.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/1-RoomKeyManagement/5-VacateStudentView.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_overnight_req_list.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_perm_req_view_overnight.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_perm_req_view_visit.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_permission_requests.dart';
import 'package:pnustudenthousing/staff/3-Supervisor/2-PermissionRequests/super_visitor_req_list.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/2-FirstCheckInList.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/3-LastCheck-out.dart';
import 'package:pnustudenthousing/staff/7-Security/1-CheckInOut/4-QrScanner.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/1-BuildingsRooms/2-ListRooms.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/1-BuildingsRooms/1-ListBuildings&Floors.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/1-BuildingsRooms/3-ViewRoom.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/3-Files.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/1-List.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/2-ViewAppRequest.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/2-Application/4-AssignRoom.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/3-Vacateing/1-List.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/3-Vacateing/2-View.dart';
import 'package:pnustudenthousing/staff/1-Manager/2-Complaints/replaycomplaints.dart';
import 'package:pnustudenthousing/staff/1-Manager/2-Complaints/viewstudentComplaints.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/4-SetAnnouncement&Event/SetAnnouncements.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/4-SetAnnouncement&Event/SetAnnouncementsAndEvents.dart';
import 'package:pnustudenthousing/staff/2-StudentAffairs/4-SetAnnouncement&Event/SetEvents.dart';
import 'package:pnustudenthousing/staff/5-NutritionSpecialist.dart/setLunchOrDinner.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/1-MnagaeFurintureStock/1-ManageFurnitureStock.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/1-MnagaeFurintureStock/2-QRCodeDisplay.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/2-ViewFurnitureStock/2-RemainingFurniturePage.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/2-ViewFurnitureStock/3-OccupiedFurniture.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/3-Viewfurnitureservicerequests/1-ViewFurnitureServiceRequests.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/0-buildingsOfficerHome.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/3-Viewfurnitureservicerequests/2-viewRequestDetails.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/2-ViewFurnitureStock/1-viewfurniturestouck.dart';
import 'package:pnustudenthousing/staff/4-BuildingsOfficer/3-Viewfurnitureservicerequests/3-QrCodeScanner.dart';

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
// numbring system is a comment
//1
//1.1
//1.1.1
// and will be explained too with ohood and hanan
// EXAMPLE 1
// Route without passing any data
//
//     GoRoute(
//       name: '/A'
//       path: '/A', // Manager Page
//       builder: (context, state) => const ManagerPage(),
//       routes: [
//        !!! button A of home page !!!
//         GoRoute(
//           name: '/A1'
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
//           name: '/A2'
//           path: 'A2', // Manager Section 2
//           builder: (context, state) => const ManagerSection2Page(),
//         ),
//       ],
//     ),
//   ],
// );
// how to route
// context.goNamed("/A1");

// EXAMPLE 2
// this example for passing arg between classes
// class A wants some info and class B will give him theses info C is the نقال علوم for them
// 1-set extra for class A
//    GoRoute(
//    name: '/A',
//    path: 'A',
//    builder: (context, state) {
//    define name for C
//    final args = state.extra as C;
//    pass C to A
//    return A(args: args);
//    }),
// 2-change class A that requier class c
//
// class A extends StatefulWidget {
//   final C args;
//   const A({Key? key, required this.args}) : super(key: key);
// 3-make class C
// // arguments for the route
// class c {
//   final String firstName;
//   final String middleName;
//   c({
//     required this.firstName,
//     required this.middleName,
//   });
// }
// 4-when routing from class B to A use this
//  context.goNamed(
// '/setpass',
//  extra: SetPassArguments(
//  firstName: firstNameController.text,
//  middleName:middleNameController.text,
//  );

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
          routes: <RouteBase>[
            GoRoute(
                name: '/pdf2',
                path: 'pdf2',
                builder: (context, state) {
                  final args = state.extra as Pdf;
                  return PdfViewerPage(
                    Url: args.Url,
                    title: args.title,
                  );
                }),
          ],
        ),
        // 1.2
        // do not touch girl I see you '_'
        GoRoute(
            name: '/student_announcements_and_events',
            path: '/student_announcements_and_events',
            builder: (context, state) => const AnnouncementsAndEvents(),
            routes: [
              //button 1 view announcements
              // 1.2.1
              GoRoute(
                  name: '/viewannouncements',
                  path: 'viewannouncements',
                  builder: (context, state) {
                    final args = state.extra as announcementList;
                    return ViewAnnouncements(args: args);
                  },
                  routes: [
                    //button 1 AnnouncementsDetails
                    // 1.2.1.1
                    GoRoute(
                      name: '/announcementsdetails',
                      path: 'announcementsdetails',
                      builder: (context, state) {
                        final args = state.extra as announcementData;
                        return AnnouncementsDetails(args: args);
                      },
                    ),
                  ]),
              //button 2 view events
              // 1.2.2
              GoRoute(
                  name: '/viewevents',
                  path: 'viewevents',
                  builder: (context, state) {
                    final args = state.extra as EventList;
                    return ViewEvents(args: args);
                  },
                  routes: [
                    //button 1 EventsDetails
                    // 1.2.2.1
                    GoRoute(
                      name: '/eventdetails',
                      path: 'eventdetails',
                      builder: (context, state) {
                        final args = state.extra as EventData;
                        return EventDetails(args: args);
                      },
                    ),
                  ]),
            ]),
        // student home have alot of pages and here the team gonna put all their related work inside the routes
        // do not touch girl I see you '_'
        GoRoute(
          name: '/studenthome',
          path: '/studenthome',
          builder: (context, state) => const StudentHomePage(),
          routes: <RouteBase>[
            // button about us
            GoRoute(
              name: '/aboutus',
              path: 'aboutus',
              builder: (context, state) => const AboutUs(),
            ),

            // button contact us
            GoRoute(
                name: '/contactus',
                path: 'contactus',
                builder: (context, state) => const ContactUs(),
                routes: [
                  //button housing staff
                  GoRoute(
                    name: '/housingstaff',
                    path: 'housingstaff',
                    builder: (context, state) => Housingstaff(),
                  ),
                  //button app developers
                  GoRoute(
                    name: '/appdevelopers',
                    path: 'appdevelopers',
                    builder: (context, state) => AppDevelopers(),
                  ),
                ]),
            // button apply for housing
            GoRoute(
                name: '/instructions',
                path: 'instructions',
                builder: (context, state) => const HousingInstructions(),
                routes: [
                  GoRoute(
                      name: '/information',
                      path: 'information',
                      builder: (context, state) => const HousingInformation(),
                      routes: [
                        GoRoute(
                            name: '/files',
                            path: 'files',
                            builder: (context, state) {
                              return HousingFiles();
                            },
                            routes: [
                              GoRoute(
                                name: '/pledge',
                                path: 'pledge',
                                builder: (context, state) {
                                  return Pledge();
                                },
                              ),
                            ])
                      ])
                ]),
            // button FQA
            GoRoute(
              name: '/FAQs',
              path: 'FAQs',
              builder: (context, state) => FAQs(),
            ),
            // button housing services
            GoRoute(
                name: '/housingservices',
                path: 'housingservices',
                builder: (context, state) => const HousingServices(),
                // here the inner pages or the buttons of the housing services page
                // here you go girl ;) here's your runway to shine walk your beautiful pages down this digital path
                routes: [
                  //button Daily Attendance
                  GoRoute(
                    name: '/dailyattendance',
                    path: 'dailyattendance',
                    builder: (context, state) => DailyAttendance(),
                  ),
                  //button Emergency Service
                  GoRoute(
                    name: '/emergencyservice',
                    path: 'emergencyservice',
                    builder: (context, state) => Emergency(),
                  ),
                  // Vacate
                  GoRoute(
                    name: '/vacate',
                    path: 'vacate',
                    builder: (context, state) => const HousingVacate(),
                  ),
                  // Maintenance
                  GoRoute(
                    name: '/maintenance',
                    path: 'maintenance',
                    builder: (context, state) => const Maintenance(),
                  ),
                  //button  complaints
                  GoRoute(
                      name: '/complaints',
                      path: 'complaints',
                      builder: (context, state) => complaints(),
                      routes: [
                        //button send complaint
                        GoRoute(
                          name: '/sendcomplaint',
                          path: 'sendcomplaint',
                          builder: (context, state) => sendcomplaint(),
                        ),
                        //button View Complaints
                        GoRoute(
                            name: '/viewcomplaints',
                            path: 'viewcomplaints',
                            builder: (context, state) => viewcomplaints(),
                            routes: [
                              //button complaintsdetails
                              GoRoute(
                                name: '/complaintsdetails',
                                path: 'complaintsdetails',
                                builder: (context, state) {
                                  final args = state.extra as complaintstData;
                                  return complaintsdetails(args: args);
                                },
                              ),
                            ]),
                      ]),
                  //button Furniture Service
                  GoRoute(
                      name: '/furnitureservice',
                      path: 'furnitureservice',
                      builder: (context, state) => FurnitureService(),
                      routes: [
                        //button Request And Return Furniture
                        GoRoute(
                          name: '/RequestAndReturnFurniture',
                          path: 'RequestAndReturnFurniture',
                          builder: (context, state) =>
                              RequestAndReturnFurniture(),
                        ),
                        //button View Furniture Request Status
                        GoRoute(
                          name: '/ViewFurnitureRequests',
                          path: 'ViewFurnitureRequests',
                          builder: (context, state) => ViewFurnitureRequests(),
                        ),
                      ]),
                  GoRoute(
                      name: '/diningservices',
                      path: 'diningservices',
                      builder: (context, state) => DiningServices(),
                      routes: [
                        //button Menu
                        GoRoute(
                            name: '/menu',
                            path: 'menu',
                            builder: (context, state) => menu(),
                            routes: [
                              //button view menu
                              GoRoute(
                                name: '/viewhmenu',
                                path: 'viewhmenu',
                                builder: (context, state) {
                                  final args = state.extra as String;
                                  return ViewMenu(menutype: args);
                                },
                              ),
                            ]),
                        //button coupon
                        GoRoute(
                          name: '/coupon',
                          path: 'coupon',
                          builder: (context, state) => Coupon(),
                        ),
                      ]),
                  GoRoute(
                      name: '/PermissionRequest',
                      path: 'PermissionRequest',
                      builder: (context, state) => PermissionRequest(),
                      routes: [
                        GoRoute(
                          name: '/overnightrequest',
                          path: 'overnightrequest',
                          builder: (context, state) => OvernightRequest(),
                        ),
                        GoRoute(
                          name: '/visitorrequest',
                          path: 'visitorrequest',
                          builder: (context, state) => VisitorRequest(),
                        ),
                        GoRoute(
                            name: '/viewrequests',
                            path: 'viewrequests',
                            builder: (context, state) => ViewRequests(),
                            routes: [
                              GoRoute(
                                name: '/overnightstatus',
                                path: 'overnightstatus',
                                builder: (context, state) =>
                                    OvernightReqStatus(),
                              ),
                              GoRoute(
                                name: '/visitorstatus',
                                path: 'visitorstatus',
                                builder: (context, state) => VisitorReqStatus(),
                              ),
                            ]),
                      ]),
                  GoRoute(
                      name: '/BookAppointment',
                      path: 'BookAppointment',
                      builder: (context, state) => BookAppointment(),
                      routes: [
                        GoRoute(
                          name: '/SetAppointmentWithHousingManager',
                          path: 'SetAppointmentWithHousingManager',
                          builder: (context, state) =>
                              TakeAppointmentsHousingWthManager(),
                        ),
                        GoRoute(
                          name: '/SetAppointmentWithSocialSpecialist',
                          path: 'SetAppointmentWithSocialSpecialist',
                          builder: (context, state) =>
                              TakeAppointmentWthSocialSpecialist(),
                        ),
                        GoRoute(
                            name: '/ViewReservedAppointments',
                            path: 'ViewReservedAppointments',
                            builder: (context, state) =>
                                ViewReservedAppointments(),
                            routes: [
                              GoRoute(
                                name: '/viewAppointmentDetails',
                                path: 'viewAppointmentDetails',
                                builder: (context, state) {
                                  final args = state.extra as appointmentDatas;
                                  return viewAppointmentDetails(args: args);
                                },
                              ),
                            ]),
                      ])
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
        // // 2
        GoRoute(
          name: '/notifications1',
          path: '/notifications1',
          builder: (context, state) => SupervisorNotifications(),
        ),

        // 3
        GoRoute(
          name: '/notifications2',
          path: '/notifications2',
          builder: (context, state) => SecurityNotifications(),
          routes: [
            //button 1 Emergency Request Details
            //  3.1
            GoRoute(
              name: '/EmergencyRequestDetails',
              path: 'EmergencyRequestDetails',
              builder: (context, state) {
                final args = state.extra as EmregencyInfo;
                return EmergencyRequestDetails(args: args);
              },
              routes: [
                GoRoute(
                    name: '/pdf3',
                    path: 'pdf3',
                    builder: (context, state) {
                      final args = state.extra as Pdf;
                      return PdfViewerPage(
                        Url: args.Url,
                        title: args.title,
                      );
                    }),
              ]
            ),
          ],
        ),

        // 2 Staff routes
        // 2.1 Housing manager
        GoRoute(
            name: '/manager',
            path: '/manager',
            builder: (context, state) => Managerhomepage(),
            routes: <RouteBase>[
              GoRoute(
                name: '/addstaff',
                path: 'addstaff',
                builder: (context, state) => addStaff(),
              ),
              // search button
              GoRoute(
                  name: '/search1',
                  path: 'search1',
                  builder: (context, state) => SearchForStudentM(),
                  routes: [
                    GoRoute(
                      name: '/StudentView1',
                      path: 'StudentView1',
                      builder: (context, state) {
                        final args = state.extra as DocumentReference;
                        return StudentViewM(sturef: args);
                      },
                    ),
                  ]),
              // Appointment
              GoRoute(
                name: '/Appointment',
                path: 'Appointment',
                builder: (context, state) => AppointmentsM(),
                routes: [
                  GoRoute(
                    name: '/AppointmentDetails',
                    path: 'AppointmentDetails',
                    builder: (context, state) {
                      final args = state.extra as AppointmentInfoM;
                      return AppointmentDetailsScreenM(args: args);
                    },
                  ),
                ],
              ),
              // Complaints
              GoRoute(
                name: '/viewstudentcomplaints',
                path: 'viewstudentcomplaints',
                builder: (context, state) => const viewstudentComplaints(),
                routes: [
                  GoRoute(
                    name: '/replaycomplaints',
                    path: 'replaycomplaints',
                    builder: (context, state) {
                      final args = state.extra as complaintstdata;
                      return replaycomplaints(args: args);
                    },
                  ),
                ],
              ),
            ]),

        // Students affairs officer
        GoRoute(
          name: '/studentsAffairs',
          path: '/studentsAffairs',
          builder: (context, state) => StudentAffairsHome(),
          routes: <RouteBase>[
            // building
            GoRoute(
                name: '/building',
                path: 'building',
                builder: (context, state) {
                  return Buildings();
                },
                routes: [
                  GoRoute(
                      name: '/floor',
                      path: 'floor',
                      builder: (context, state) {
                        final args = state.extra as String;
                        return Floors(
                          buildingId: args,
                        );
                      },
                      routes: [
                        GoRoute(
                          name: '/room',
                          path: 'room',
                          builder: (context, state) {
                            final args = state.extra as String;
                            return Rooms(roomId: args);
                          },
                          routes: [
                            GoRoute(
                              name: '/roomDetailes',
                              path: 'roomDetailes',
                              builder: (context, state) {
                                final args = state.extra as String;
                                return RoomDetails(roomId: args);
                              },
                            ),
                          ],
                        ),
                      ]),
                ]),
            // ApplicationRequests
            GoRoute(
              name: '/ApplicationRequestsList',
              path: 'ApplicationRequestsList',
              builder: (context, state) => const ApplicationRequestsList(),
              routes: [
                GoRoute(
                    name: '/ApplicationRequestView',
                    path: 'ApplicationRequestView',
                    builder: (context, state) {
                      final args = state.extra as requestid;
                      return ApplicationRequestView(args: args);
                    },
                    routes: [
                      GoRoute(
                          name: '/pdf',
                          path: 'pdf',
                          builder: (context, state) {
                            final args = state.extra as Pdf;
                            return PdfViewerPage(
                              Url: args.Url,
                              title: args.title,
                            );
                          }),
                      GoRoute(
                          name: '/assignroom',
                          path: 'assignroom',
                          builder: (context, state) {
                            final args = state.extra as Room;
                            return AssignRoom(args: args);
                          }),
                    ]),
              ],
            ),

            // VacateRequests
            GoRoute(
              name: '/VacateRequestsList',
              path: 'VacateRequestsList',
              builder: (context, state) => const VacateRequestsList(),
              routes: [
                GoRoute(
                    name: '/VacateRequestView',
                    path: 'VacateRequestView',
                    builder: (context, state) {
                      final args = state.extra as requestid;
                      return VacateRequestView(args: args);
                    },
                    routes: [
                      GoRoute(
                        name: '/roomDetailes1',
                        path: 'roomDetailes1',
                        builder: (context, state) {
                          final args = state.extra as String;
                          return RoomDetails(roomId: args);
                        },
                      ),
                    ])
              ],
            ),
            //button Set Announcements And Events
            GoRoute(
                name: '/setannouncementsandavents',
                path: 'setannouncementsandavents',
                builder: (context, state) => SetAnnouncementsAndEvents(),
                routes: [
                  //button set announcement
                  GoRoute(
                    name: '/setannouncement',
                    path: 'setannouncement',
                    builder: (context, state) => setAnnouncement(),
                  ),
                  //button set event
                  GoRoute(
                    name: '/setevent',
                    path: 'setevent',
                    builder: (context, state) => SetEvent(),
                  ),
                ]),
          ],
        ),

        // 2.3 Resident student supervisor
        GoRoute(
          name: '/supervisor',
          path: '/supervisor',
          builder: (context, state) => SupervisorHome(),
          routes: <RouteBase>[
            // search button
            GoRoute(
                name: '/search2',
                path: 'search2',
                builder: (context, state) => SearchForStudentU(),
                routes: [
                  GoRoute(
                    name: '/StudentView2',
                    path: 'StudentView2',
                    builder: (context, state) {
                      final args = state.extra as DocumentReference;
                      return StudentViewU(sturef: args);
                    },
                  ),
                ]),
            //     //button View Daily Attendance

            //button 2 View Daily Attendance
            // 2.3.2
            GoRoute(
                name: '/viewdailyattendance',
                path: 'viewdailyattendance',
                builder: (context, state) => WeekAttendance(),
                routes: [
                  //button 1 Day Attendance
                  //  2.3.2.1
                  GoRoute(
                    name: '/dayattendance',
                    path: 'dayattendance',
                    builder: (context, state) {
                      final args = state.extra as String;
                      return DayAttendance(day: args);
                    },
                    routes: [
                      //button 1 Student Details
                      //  2.3.2.1.1
                      GoRoute(
                        name: '/studentdetails',
                        path: 'studentdetails',
                        builder: (context, state) {
                          final args = state.extra as String;
                          return StudentDetails(pnuid: args);
                        },
                      ),
                    ],
                  ),
                ]),

            // Permission Requests
            GoRoute(
                name: '/superpermrequests',
                path: 'superpermrequests',
                builder: (context, state) => const SuperPermissionRequests(),
                routes: [
                  // Overnight
                  GoRoute(
                    name: '/superovernightlist',
                    path: 'superovernightlist',
                    builder: (context, state) => const SuperOvernightReqList(),
                    routes: [
                      GoRoute(
                          name: '/superovernightview',
                          path: 'superovernightview',
                          builder: (context, state) {
                            final args = state.extra as overnightInfo;
                            return SuperPermReqViewOvernight(args: args);
                          })
                    ],
                  ),
                  // Visitor
                  GoRoute(
                    name: '/supervisitorlist',
                    path: 'supervisitorlist',
                    builder: (context, state) => const SuperVisitorReqList(),
                    routes: [
                      GoRoute(
                          name: '/supervisitorview',
                          path: 'supervisitorview',
                          builder: (context, state) {
                            final args = state.extra as visitorInfo;
                            return SuperPermReqViewVisit(args: args);
                          })
                    ],
                  ),
                ]),
            // Room Key
            GoRoute(
              name: '/roomKey',
              path: 'roomKey',
              builder: (context, state) => RoomKeyManagement(),
              routes: [
                GoRoute(
                  name: '/departingroomKeyList',
                  path: 'departingroomKeyList',
                  builder: (context, state) => VacateStudentsList(),
                  routes: [
                    GoRoute(
                      name: '/VacateStudentView',
                      path: 'VacateStudentView',
                      builder: (context, state) {
                        final args = state.extra as DocumentReference;
                        return VacateStudentView(sturef: args);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  name: '/newroomKeyList',
                  path: 'newroomKeyList',
                  builder: (context, state) => NewStudentsList(),
                  routes: [
                    GoRoute(
                        name: '/NewStudentView',
                        path: 'NewStudentView',
                        builder: (context, state) {
                          final args = state.extra as DocumentReference;
                          return NewStudentView(sturef: args);
                        },
                        routes: [
                          GoRoute(
                              name: '/pdf4',
                              path: 'pdf4',
                              builder: (context, state) {
                                final args = state.extra as Pdf;
                                return PdfViewerPage(
                                  Url: args.Url,
                                  title: args.title,
                                );
                              }),
                        ]),
                  ],
                ),
              ],
            ),
          ],
        ),

        // 2.4 Housing buildings officer
        GoRoute(
            name: '/buildingsOfficer',
            path: '/buildingsOfficer',
            builder: (context, state) => buildingsOfficerHome(),
            routes: <RouteBase>[
              // button 1 Manage Furniture Stock
              // 2.4.1
              GoRoute(
                  name: '/ManageFurnitureStock',
                  path: 'ManageFurnitureStock',
                  builder: (context, state) => ManageFurnitureStock(),
                  routes: [
                    // button 1 QR Code Display
                    //2.4.1.1.
                    GoRoute(
                      name: '/QRCodeDisplay',
                      path: 'QRCodeDisplay',
                      builder: (context, state) {
                        final args = state.extra as List<Map<String, dynamic>>;
                        return QRCodeDisplay(qrDataList: args);
                      },
                    ),
                  ]),

              // button 2 view furniture stock
              // 2.4.2
              GoRoute(
                  name: '/viewfurniturestock',
                  path: 'viewfurniturestock',
                  builder: (context, state) => ViewFurnitureStock(),
                  routes: [
                    // button 1 Remaining Furniture
                    // 2.4.2.1
                    GoRoute(
                      name: '/remainingfurniture',
                      path: 'remainingfurniture',
                      builder: (context, state) => RemainingFurniture(),
                    ),

                    // button 2 Occupied Furniture
                    // 2.4.1.2.2
                    GoRoute(
                      name: '/occupiedfurniture',
                      path: 'occupiedfurniture',
                      builder: (context, state) => OccupiedFurniture(),
                    ),
                  ]),

              // button 3 View furniture service requests
              // 2.4.3
              GoRoute(
                  name: '/viewfurnitureservicerequests',
                  path: 'viewfurnitureservicerequests',
                  builder: (context, state) => Viewfurnitureservicerequests(),
                  routes: [
                    // button 1 View Request Details
                    // 2.4.2.1
                    GoRoute(
                      name: '/viewrequestdetails',
                      path: 'viewrequestdetails',
                      builder: (context, state) {
                        final args = state.extra as furniturerequestsid1;
                        return ViewRequestDetails(args: args);
                      },
                    ),
                    // button 2 QR scanner
                    // 2.4.2.2
                    GoRoute(
                      name: '/qrscanner3',
                      path: 'qrscanner3',
                      builder: (context, state) {
                        final args = state.extra as DocumentReference;
                        return QrCodeScanner(reqref: args);
                      },
                    ),
                  ]),
            ]),
        // 2.5 Nutrition specialist
        GoRoute(
          name: '/nutritionSpecialist',
          path: '/nutritionSpecialist',
          builder: (context, state) => SetMenus(),
          routes: <RouteBase>[
            GoRoute(
              name: '/setlunchordinner',
              path: 'setlunchordinner',
              builder: (context, state) {
                final args = state.extra as String;
                return setLunchOrDinner(setmenutype: args);
              },
            ),
          ],
        ),
        // 2.6 Social Specialist
        GoRoute(
          name: '/socialSpecialist',
          path: '/socialSpecialist',
          builder: (context, state) => SocialSpecialistHome(),
          routes: <RouteBase>[
            //!!!!!!! add another page if required !!!!!!!\\

            GoRoute(
              name: '/AppointmentsSp',
              path: 'AppointmentsSp',
              builder: (context, state) => AppointmentsSp(),
              routes: [
                GoRoute(
                  name: '/AppointmentDetailsSp',
                  path: 'AppointmentDetailsSp',
                  builder: (context, state) {
                    final args = state.extra as AppointmentInfoSp;
                    return AppointmentDetailesSp(args: args);
                  },
                  routes: [
                    GoRoute(
                        name: '/pdf5',
                        path: 'pdf5',
                        builder: (context, state) {
                          final args = state.extra as Pdf;
                          return PdfViewerPage(
                            Url: args.Url,
                            title: args.title,
                          );
                        }),
                  ]
                ),
              ],
            ),

            GoRoute(
              name: '/StudentFiles',
              path: 'StudentFiles',
              builder: (context, state) => StudentFiles(),
              routes: [
                GoRoute(
                  name: '/viewfiles',
                  path: 'viewfiles',
                  builder: (context, state) {
                    final args = state.extra as filesdata;
                    return viewfiles(args: args);
                  },
                ),
              ],
            ),

          ],
        ),
        // 2.7 Housing security guard
        GoRoute(
          name: '/security',
          path: '/security',
          builder: (context, state) => SecurityHome(),
          routes: <RouteBase>[
            // search button
            GoRoute(
                name: '/search3',
                path: 'search3',
                builder: (context, state) => SearchForStudentS(),
                routes: [
                  GoRoute(
                    name: '/StudentView3',
                    path: 'StudentView3',
                    builder: (context, state) {
                      final args = state.extra as DocumentReference;
                      return StudentViewS(sturef: args);
                    },
                  ),
                ]),
            GoRoute(
              name: '/checkinout',
              path: 'checkinout',
              builder: (context, state) => const checkInOut(),
              routes: [
                GoRoute(
                    name: '/FirstCheckInList',
                    path: 'FirstCheckInList',
                    builder: (context, state) => FirstCheckInList(),
                    routes: [
                      GoRoute(
                          name: '/QrScanner1',
                          path: 'QrScanner1',
                          builder: (context, state) {
                            final args = state.extra as QrData;
                            return QrScanner(
                              sturef: args.sturef,
                              checkStatus: args.Ceckstatus,
                            );
                          }),
                    ]),
                GoRoute(
                    name: '/LastCheckOutList',
                    path: 'LastCheckOutList',
                    builder: (context, state) => LastCheckOutList(),
                    routes: [
                      GoRoute(
                          name: '/QrScanner2',
                          path: 'QrScanner2',
                          builder: (context, state) {
                            final args = state.extra as QrData;
                            return QrScanner(
                              sturef: args.sturef,
                              checkStatus: args.Ceckstatus,
                            );
                          }),
                    ]),
              ],
            ),
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

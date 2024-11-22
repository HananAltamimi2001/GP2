import 'package:flutter/material.dart';

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            //Entry and exit
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Color(0xff007580)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "1. Times of entry and exit in the university dormitory:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "• The gates of the girls' dormitory are open daily from 6:00 AM to 12:00 PM."),
                    Text(
                        "• The times from 12:00 AM to 6:00 AM are quiet times, Delay or return during these hours are not permitted."),
                    Text(
                        "• Returning to the dormitory after 12:00 AM is considered a violation of the university dormitory instructions.")
                  ],
                ),
              ),
            ),
            // Attendance policy
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Color(0xff007580)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "2. Attendance Policy:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "• Attendance is taken once, The daily attendance time starts from 4:00 PM until 12:00 PM"),
                    Text(
                        "• Failure to mark attendance by the deadline will result in an unexcused absence."),
                  ],
                ),
              ),
            ),
            // Overnight stay
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Color(0xff007580)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "3. Overnight Stay:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "• Requests for overnight stays outside the university dormitory must be submitted through the application."),
                    Text(
                        "• Requests must be submitted before 7:00 PM on the same day. Any requests submitted after this time will not be accepted."),
                  ],
                ),
              ),
            ),
            // Visitation
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Color(0xff007580)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "4. Visitation:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "• Visitation for guests begins at 2:00 PM until 12:00 AM on Fridays and Saturdays."),
                    Text(
                        '• Visitors are prohibited from entering dormitory buildings or residential units. Visitors will be welcomed in the designated areas for visiting (outdoor area, service center "mall").'),
                    Text(
                        '• Children are not allowed to enter the Dormitory buildings.'),
                    Text(
                        '• Visitation requests must be submitted through the application.'),
                  ],
                ),
              ),
            ),
            //General Guidelines
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Color(0xff007580)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "5. General Guidelines:",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                        "• Students must conduct themselves appropriately towards all university personnel, including students, staff, and dormitory workers. Any behavior that is contrary to good manners or morals is prohibited."),
                    Text(
                        '• The dormitory room must only be used for residential purposes.'),
                    Text(
                        '• Students must reside in their assigned dormitory room. Changing rooms is not permitted without prior approval from the dormitory administration.'),
                    Text(
                        '• In case of an emergency or maintenance issue requiring entry into a room when the student is absent, the dormitory administration may enter the room to ensure the safety and security of all.'),
                    Text(
                        "• Students must present their university ID or dormitory ID upon request by authorized personnel."),
                    Text(
                        '• Students are responsible for any damage caused to dormitory facilities or the property of others. They must bear the cost of repairs within one month of notification.'),
                    Text(
                        '• Students are responsible for any damage caused by moving furniture from common areas or public facilities. It is prohibited to have furniture from common areas in individual rooms.'),
                    Text(
                        '• Students are prohibited from removing or bringing any university property into or out of their rooms.'),
                    Text(
                        '• Students are prohibited from making any alterations to their rooms, either internally or externally. Common areas must not be used for any unauthorized purposes.'),
                    Text('• Students are not allowed to keep pets.'),
                    Text(
                        "• Students must immediately vacate their rooms if they are asked to leave for any reason determined by the dean's office, whether it's a permanent eviction or a temporary one due to renovations or repairs."),
                    Text(
                        '• Students must vacate their rooms immediately upon withdrawing, transferring, deferring, or discontinuing their studies and inform the office of student affairs.'),
                    Text(
                        '• Students are responsible for keeping their rooms clean and disposing of waste in sealed plastic bags in designated areas.'),
                    Text(
                        '• Students must use electrical appliances and other equipment according to the provided instructions.'),
                    Text(
                        '• Students should conserve electricity, water, and other resources.'),
                    Text(
                        "• Students cannot use or install electrical appliances or equipment that are incompatible with the dormitory's electrical system. Students will be held responsible for any damages caused by such actions."),
                    Text(
                        "• Students must report any damages or malfunctions in their rooms to the dormitory administration immediately. Failing to do so will result in consequences."),
                    Text(
                        '• When leaving the room, students must turn off the water supply, lights, and electrical appliances, and lock the windows.'),
                    Text(
                        '• Students are solely responsible for their personal belongings. The dormitory administration is not liable for any loss or damage.'),
                    Text(
                        '• The use of incense and candles is prohibited in dormitory rooms and common areas.'),
                    Text(
                        '• Fireworks, gas appliances, and similar items are strictly prohibited in the dormitory.'),
                    Text(
                        "• Students must maintain a quiet and peaceful environment within the dormitory."),
                    Text(
                        "• Students are not allowed to hang pictures, drawings, or posters on walls, doors, or windows."),
                    Text(
                        '• Smoking is strictly prohibited in all dormitory buildings and facilities.'),
                    Text(
                        '• Students must wear appropriate attire when using common areas such as lounges, the administration office, and the dining hall.'),
                    Text(
                        '• Photography in any form or using any means is prohibited without prior permission from the dormitory administration and adherence to specific guidelines.'),
                    Text(
                        '• Any violation of these guidelines, Islamic law, state regulations, university rules, regulations, customs, or general conduct is considered a disciplinary offense. All provisions mentioned in Article 4 of the Student Conduct and Discipline Regulations at Princess Nourah bint Abdulrahman University apply.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

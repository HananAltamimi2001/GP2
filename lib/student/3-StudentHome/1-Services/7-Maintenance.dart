import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pnustudenthousing/helpers/Design.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "Maintenance",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App logo and description
                Center(
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/marafiq_pnu_logo.png')),
                ),
                Center(
                  child: Titletext(
                    t: "Marafiq PNU App",
                    color: dark1,
                    align: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text(
                      color: dark1,
                      align: TextAlign.center,
                      t: "Download the Marafiq PNU app for easy access to university maintenance services.",
                    )),
                // Instructions
                Row(
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007580),
                          fontSize: 20),
                    ),
                  ],
                ),
                // Step 1
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '1. Go to the Google Play Store\n     or the Apple App Store.',
                          style: TextStyle(
                              color: Color(0xFF007580), fontSize: 20)),
                    ),
                  ],
                ),
                // Step 2
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2. Search for "Marafiq PNU".',
                          style: TextStyle(
                              color: Color(0xFF007580), fontSize: 20)),
                    ),
                  ],
                ),
                // Step 3
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('3. Download and install the app.',
                          style: TextStyle(
                              color: Color(0xFF007580), fontSize: 20)),
                    ),
                  ],
                ),

                // Download button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            launch(
                                'https://apps.apple.com/us/app/marafiq-pnu/id1533163256');
                          },
                          child: Text(
                            'iOS Download',
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007580),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            launch(
                                'https://play.google.com/store/apps/details?id=com.pnu.maximoapp&hl=ar');
                          },
                          child: Text('Android Download',
                              style: TextStyle(fontSize: 15)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007580),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

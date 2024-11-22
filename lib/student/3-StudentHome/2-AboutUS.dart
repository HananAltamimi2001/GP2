import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart'; // Importing our design library

// AboutUs widget to display information about PNU Student Housing
class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() =>
      _AboutUsState(); // Creates the state for AboutUs
}

// State class for AboutUs
class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: "About us", // App bar title
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0), // Padding around the content
        child: Column(
          children: [
            SizedBox(
              // Take the size of the screen whatever the device
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.25, // 25% of screen height for image
              child: Center(
                child: Image.asset("assets/housing.jpg",
                        width: MediaQuery.of(context).size.width *
                            0.8, // Adjust image width to 50% of screen width
                        height: MediaQuery.of(context).size.height *
                            0.5, // Adjust image height to 50% of screen height
                        fit: BoxFit.cover, // Adjust the BoxFit if necessary
                      )
              ),
            ),

            Heightsizedbox(h: 0.02), // Spacer with height from our design library for separation

            // Title text from our design library
            Titletext(
              t: "About PNU Student Housing",
              color: dark1, // Set text color
              align: TextAlign.center, // Center align the text
            ),

            Heightsizedbox(h: 0.02),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
              children: [
                // Title text from our design library
                Titletext(
                  t: "Vision:", // Set text for Vision section
                  color: dark1, // Text color for Vision
                  align: TextAlign.start, // Text alignment for Vision
                ),

                Heightsizedbox(
                    h: 0.02), // Spacer with height from our design library for separation

                // Text for Vision from our design library
                text(
                  t: "To create transformative living and learning environments where students feel safe, involved and inspired to change the world.", // Display the fetched Vision statement
                  color: Colors.black, // Set text color to black
                  align: TextAlign.start, // Align text to start
                ),

                Heightsizedbox(h: 0.01),


                Titletext(
                  t: "Mission:",
                  color: dark1,
                  align: TextAlign.start,
                ),

                Heightsizedbox(h: 0.01),

                text(
                  t: "To cultivate learning communities that foster student engagement, growth and success.", // Display the fetched Mission statement
                  color: Colors.black, // Set text color to black
                  align: TextAlign.start, // Align text to start
                ),

                Heightsizedbox(h: 0.01),

                Titletext(
                  t: "Values:", // Set text for Values section
                  color: dark1, // Text color for Values
                  align: TextAlign.start, // Text alignment for Values
                ),

                Heightsizedbox(h: 0.01),

                text(
                  t: "Learning — A caring community, all of us students, helping one another grow.\n"
                     "\nDiscovery — Expanding knowledge and human understanding.\n"
                     "\nFreedom — To seek the truth and express it.\n"
                     "\nLeadership — The will to excel with integrity and the spirit that nothing is impossible.\n"
                     "\nIndividual Opportunity — Many options, diverse people and ideas, one university.\n"
                     "\nResponsibility — To serve as a catalyst for positive change in Texas and beyond.", // Display the fetched Values statement
                  color: Colors.black, // Set text color to black
                  align: TextAlign.start, // Align text to start
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/0-Component/-instruction_text.dart';
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/3-Files.dart';

class HousingInstructions extends StatelessWidget {
  const HousingInstructions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // safearea
      body: SafeArea(
        // to scroll
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // index for the stepper
              OurStepper(currentStep: 0),
              Padding(
                padding: const EdgeInsets.all(20),
                // container for instructions
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: InstructionText(),
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width *
                          1.25, // Adjust the multiplier as needed
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white.withOpacity(0.5),
                          border:
                              Border.all(color: Color(0xff007580), width: 1)),
                    ),
                  ],
                ),
              ),

              // sized box
              Heightsizedbox(h: 0.003),
              // row for buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back button
                    actionbutton(
                        onPressed: () {
                          context.goNamed('/studenthome');
                        },
                        text: 'Back',
                        background: dark1),
                    // forward button
                    actionbutton(
                        onPressed: () {
                          context.goNamed('/information');
                        },
                        text: 'Next Step',
                        background: dark1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:path/path.dart' as p;
import 'package:pnustudenthousing/student/3-StudentHome/3-Apply/4-Pledge.dart';

class HousingFiles extends StatefulWidget {
  // final studentInfoArgs args;
  const HousingFiles({
    Key? key,
    //required this.args
  }) : super(key: key);
  @override
  State<HousingFiles> createState() => _HousingFilesState();
}

class _HousingFilesState extends State<HousingFiles> {
  File nationalIdFile = File('');
  File medicalReportFile = File('');
  File proofOfDistanceFile = File('');
  File socialSecurityCertificateFile = File('');

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
            OurStepper(currentStep: 2),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Dtext(
                      t: 'National ID Card',
                      align: TextAlign.center,
                      color: dark1,
                      size: 0.05,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff007580), width: 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: _buildFileUploadRow(
                              nationalIdFile, UploadType.nationalId),
                        )),
                    Heightsizedbox(
                      h: 0.02,
                    ),
                    Dtext(
                      t: 'Medical Report',
                      align: TextAlign.center,
                      color: dark1,
                      size: 0.05,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff007580), width: 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Container(
                              child: _buildFileUploadRow(
                                  medicalReportFile, UploadType.medicalReport)),
                        ),
                      ),
                    ),
                    Heightsizedbox(
                      h: 0.02,
                    ),
                    Dtext(
                      t: 'Proof of distance',
                      align: TextAlign.center,
                      color: dark1,
                      size: 0.05,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff007580), width: 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Container(
                              child: _buildFileUploadRow(proofOfDistanceFile,
                                  UploadType.proofOfDistance)),
                        ),
                      ),
                    ),
                    Heightsizedbox(
                      h: 0.02,
                    ),
                    Dtext(
                      t: 'Social security certificate',
                      align: TextAlign.center,
                      color: dark1,
                      size: 0.05,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff007580), width: 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Container(
                              child: _buildFileUploadRow(
                                  socialSecurityCertificateFile,
                                  UploadType.socialSecurityCertificate)),
                        ),
                      ),
                    ),

                    // sized box
                    Heightsizedbox(h: 0.018),
                    // row for buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back button
                        actionbutton(
                            onPressed: () {
                              context.goNamed('/information');
                            },
                            text: 'Back',
                            background: dark1),
                        // forward button
                        actionbutton(
                            onPressed: () {
                              // if (nationalIdFile.path.isEmpty == false &&
                              //     medicalReportFile.path.isEmpty == false &&
                              //     proofOfDistanceFile.path.isEmpty == false &&
                              //     socialSecurityCertificateFile.path.isEmpty ==
                              //         false) {
                                DataManager.savefiles(
                                  allFliesArgs(
                                    nationalIdFile: nationalIdFile,
                                    medicalReportFile: medicalReportFile,
                                    proofOfDistanceFile: proofOfDistanceFile,
                                    socialSecurityCertificateFile:
                                        socialSecurityCertificateFile,
                                  ),
                                );
                                context.goNamed('/pledge');
                              // } else {
                              //   ErrorDialog(
                              //       "Please load all needed files", context,
                              //       buttons: [
                              //         {
                              //           'Ok': () => context.pop(),
                              //         }
                              //       ]);
                              // }
                            },
                            text: 'Next Step',
                            background: dark1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _selectFile(UploadType type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
        // , 'jpg', 'jpeg', 'png'
      ],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      setState(
        () {
          switch (type) {
            case UploadType.nationalId:
              nationalIdFile = file;
              break;
            case UploadType.medicalReport:
              medicalReportFile = file;

              break;
            case UploadType.proofOfDistance:
              proofOfDistanceFile = file;

              break;
            case UploadType.socialSecurityCertificate:
              socialSecurityCertificateFile = file;

              break;
          }
        },
      );
    }
  }

  Widget _buildFileUploadRow(File file, UploadType type) {
    return Row(
      children: [
        Expanded(
          child: Dtext(
t: file.path.isEmpty ? "No file chosen" : p.basename(file.path),
            color: Colors.grey,
            align: TextAlign.justify,
            size: 0.045,
          ),
        ),
        Dactionbutton(
          onPressed: () => _selectFile(type),
          text: 'Choose file',
          fontsize: 0.02,
          background: blue1,
          width: 0.23,
          padding: 0,
        ),
      ],
    );
  }
}

enum UploadType {
  nationalId,
  medicalReport,
  proofOfDistance,
  socialSecurityCertificate
}

class allFliesArgs {
  File nationalIdFile;
  File medicalReportFile;
  File proofOfDistanceFile;
  File socialSecurityCertificateFile;

  allFliesArgs({
    required this.nationalIdFile,
    required this.medicalReportFile,
    required this.proofOfDistanceFile,
    required this.socialSecurityCertificateFile,
  });
}

class OurStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps = 4;

  const OurStepper({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          height: SizeHelper.getSize(context) * 0.2,
          child: Container(
            width: SizeHelper.getSize(context) * 0.2,
            height: SizeHelper.getSize(context) * 0.2,
            child: Column(
              children: [
                CircleAvatar(
                  radius: SizeHelper.getSize(context) * 0.045,
                  backgroundColor: isActive ? dark1 : grey1.withOpacity(0.5),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Heightsizedbox(h: 0.01),
                Dtext(
                    t: _getStepTitle(index + 1),
                    align: TextAlign.center,
                    color: isActive ? dark1 : grey1,
                    size: 0.03)
              ],
            ),
          ),
        );
      }),
    );
  }

  String _getStepTitle(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return 'Instructions';
      case 2:
        return 'Your Information';
      case 3:
        return 'Load Files';
      case 4:
        return 'Pledge';
      default:
        return '';
    }
  }
}

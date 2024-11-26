import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  final DocumentReference reqref;

  const QrCodeScanner({super.key, required this.reqref});

  @override
  State<StatefulWidget> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(
        title: 'Scan',
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: Qr(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: actionbutton(
                            text: 'pause',
                            background: dark1,
                            onPressed: () async {
                              await controller?.pauseCamera();
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: actionbutton(
                          text: 'resume',
                          background: dark1,
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool hasScanned = false;
  Widget Qr(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onScanned,
      overlay: QrScannerOverlayShape(
          borderColor: hasScanned ? green1 : red1,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
    );
  }

  Future<void> onScanned(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        hasScanned = true;
        result = scanData;
      });

      // Pause the camera after scanning
      controller.pauseCamera();

      try {
        // Fetch the document snapshot
        DocumentSnapshot snapshot = await widget.reqref.get();

        // Check if the document exists
        if (snapshot.exists) {
          // Get all fields as a Map
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            print("Document Data: $data");

            // Access specific fields
            DocumentReference sturef = data['studentInfo'];

            String Service = data['FurnitureService'] ?? 0;

            // Extract the unique value from the scanned data
            String uniqueValue = scanData.code ?? "";
            List<String> parts = uniqueValue.split('-');

            // Get the part before the hyphen (first part)
            String beforeHyphen = parts[0];
            print("Before hyphen: $beforeHyphen"); // Debugging line

            // Query Firestore to find the document in 'furnitureStock' collection
            DocumentSnapshot snapshot = await FirebaseFirestore.instance
                .collection('furnitureStock')
                .doc(beforeHyphen)
                .get();

            if (!snapshot.exists) {
              ErrorDialog("Furniture stock document not found.", context,
                  buttons: [
                    {
                      "Ok": () {
                        context.pop();
                      }
                    }
                  ]);
              //throw Exception("Furniture stock document not found.");
            }

            // Now, check if the furniture item with the scanned unique value exists and is available
            DocumentReference furref =
                snapshot.reference.collection('stock').doc(uniqueValue);
            final furnitureSnapshot = await furref.get();

            if (!furnitureSnapshot.exists) {
              // Handle errors
              ErrorDialog("Furniture item not found.", context, buttons: [
                {
                  "Ok": () {
                    context.pop();
                  }
                }
              ]);
              // throw Exception("Furniture item not found.");
            }
            if (Service == "Request Furniture") {
              // Check if the status is available
              var furnitureData =
                  furnitureSnapshot.data() as Map<String, dynamic>;
              if (furnitureData['status'] != 'Available') {
                // Handle errors
                ErrorDialog("This furniture is not available.", context,
                    buttons: [
                      {
                        "Ok": () {
                          context.pop();
                        }
                      }
                    ]);
                //throw Exception("This furniture is not available.");
              }

              // If available, update the status and assign it
              await furref.update({
                'status': 'Occupied',
                'studentInfo':
                    sturef, // Assuming studentRef is already available
              });
              // If available, update the status and assign it
              await widget.reqref.update({
                'furnitureStatus': 'Completed',
              });

              // Optionally update the stock document (if needed)
              await snapshot.reference.update({
                'availableQuantity': FieldValue.increment(-1),
                'occupiedQuantity': FieldValue.increment(1),
              });

              // Show a confirmation dialog
              InfoDialog("Scanned and Updated", context, buttons: [
                {
                  "Ok": () {
                    context.pop();
                    context.pop();
                  }
                }
              ]);
              //return
            } else {
              // Check if the status is available
              var furnitureData =
                  furnitureSnapshot.data() as Map<String, dynamic>;
              if (furnitureData['status'] != 'Occupied') {
                // Handle errors
                ErrorDialog("This furniture is not available.", context,
                    buttons: [
                      {
                        "Ok": () {
                          context.pop();
                        }
                      }
                    ]);
                //throw Exception("This furniture is not available.");
              }

              // If available, update the status and assign it
              await furref.update({
                'status': 'Available',
                'studentInfo':
                   FieldValue.delete(), 
              });
              // If available, update the status and assign it
              await widget.reqref.update({
                'furnitureStatus': 'Completed',
              });

              // Optionally update the stock document (if needed)
              await snapshot.reference.update({
                'availableQuantity': FieldValue.increment(1),
                'occupiedQuantity': FieldValue.increment(-1),
              });

              // Show a confirmation dialog
              InfoDialog("Scanned and Updated", context, buttons: [
                {
                  "Ok": () {
                    context.pop();
                    context.pop();
                  }
                }
              ]);
            }
          }
        }
      } catch (e) {
        // Handle errors
        ErrorDialog("Error: $e", context, buttons: [
          { 
            "Ok": () {
              context.pop();
            }
          }
        ]);
      }
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

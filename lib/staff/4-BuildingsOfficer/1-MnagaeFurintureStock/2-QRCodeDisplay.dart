import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:pnustudenthousing/helpers/Design.dart';

class QRCodeDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> qrDataList; // List of {type, qrCodes}

  const QRCodeDisplay({Key? key, required this.qrDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: "Furniture QR Codes"),
      body: ListView.builder(
        itemCount: qrDataList.length,
        itemBuilder: (context, index) {
          final furnitureData = qrDataList[index];
          final furnitureType = furnitureData['type'];
          final qrCodes = furnitureData['qrCodes'] as List<String>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Titletext(
                      t: furnitureType,
                      color: light1,
                      align: TextAlign.center,
                    ),
                  ),
                  ...qrCodes.map((qrCode) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        QrImageView(
                          data: qrCode,
                          version: QrVersions.auto,
                          size: 50.0,
                        ),
                        Widthsizedbox(w: 0.02),
                        Expanded(
                          child: Text(
                            qrCode,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Heightsizedbox(h: 0.01),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Dactionbutton(
                        onPressed: () => printQRCode({furnitureType: qrCodes}),
                        text: "Print / Save",
                        background: light1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> printQRCode(Map<String, List<String>> furnitureQrData) async {
    final pdf = pw.Document();

    for (final entry in furnitureQrData.entries) {
      final furnitureName = entry.key;
      final qrCodes = entry.value;

      // Pre-generate QR images
      final qrImageBytes = await Future.wait(qrCodes.map(_generateQrImage));

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                furnitureName,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Wrap(
              spacing: 15,
              runSpacing: 15,
              children: List.generate(qrCodes.length, (index) {
                return pw.Column(
                  children: [
                    pw.Image(
                      pw.MemoryImage(qrImageBytes[index]),
                      width: 100,
                      height: 100,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      qrCodes[index],
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<Uint8List> _generateQrImage(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrPainter = QrPainter.withQr(
        qr: qrValidationResult.qrCode!,
        gapless: true,
        emptyColor: const Color(0xFFFFFFFF),
        color: const Color(0xFF000000),
      );

      final image = await qrPainter.toImage(200);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } else {
      throw Exception("QR Code generation failed.");
    }
  }
}


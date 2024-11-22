import 'package:flutter/material.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String Url; // Document ID in Firestore
  final String title;
  const PdfViewerPage({Key? key, required this.Url, required this.title})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OurAppBar(
        title: widget.title,
      ),
      body:  widget.Url != null
          ?  SfPdfViewer.network(widget.Url)
          : Center(
              child: text(
                t: "Error loading ${widget.title} file",
                align: TextAlign.center,
                color: red1,
              ),
            ),
            
    );
  }
}

import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class requestid {
  final String requestId;

  requestid({
    required this.requestId,
  });
}
class Room{
 late DocumentReference sturef;
late DocumentReference requestref;
 Room({
    required this.sturef,required this.requestref,

  });
}
class Pdf {
  final String Url;
  final String title;

  Pdf({required this.Url, required this.title});
}
String formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }



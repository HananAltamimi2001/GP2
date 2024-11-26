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


// <p style="color: #339199; font-size: 20px;">Hello,</p>
// <p>It seems like you forgot your password for PNU Housing If this is true, click the button below to reset your password.</p>
// <p style="text-align: right;">هل نسيت كلمة المرور؟ في حال نسيانك لكلمة المرور الرجاء النقر على الزر أدناه</p>
// <p  style="text-align: center;"><a href='%LINK%' style="color: #339199;">Click here|انقر هنا</a></p>
// <p>If you did not forget your password, please disregard this email.</p>
// <p style="text-align: right;">في حال لم تقم بهذا الإجراء الرجاء تجاهل هذا البريد</p>
// <p>Thank you,</p>
// <p>PNU Housing team</p>
// <p style="text-align: right;">،شكراً لك</p>
// <p style="text-align: right;">فريق سكن نورة</p>

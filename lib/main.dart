import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart'; // For Realtime Database
import 'package:pnustudenthousing/helpers/AppRoutes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//   // Replace "192.168.x.x" with your computer's local IP address.
//   // Auth
//   FirebaseAuth.instance.useAuthEmulator("192.168.8.200", 9099);

//   // Cloud Firestore
//   FirebaseFirestore.instance.useFirestoreEmulator("192.168.8.200", 8080);
//  FirebaseFirestore.instance.settings = Settings(
//   sslEnabled: false,
//   persistenceEnabled: true,
// );


//   // Cloud Storage
//   FirebaseStorage.instance.useStorageEmulator("192.168.8.200", 9199);

//   // Cloud Functions
//   FirebaseFunctions.instance.useFunctionsEmulator("192.168.8.200", 5001);

//   // Realtime Database
//   FirebaseDatabase.instance.useDatabaseEmulator("192.168.8.200", 9000);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        // primaryColor: Color(0xff007580),
        //canvasColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff007580)),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pnustudenthousing/helpers/AppRoutes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: Color(0xff007580),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff007580)),
      ),
      
      debugShowCheckedModeBanner: false, 
      routerConfig: router,
    );
  }
 
}

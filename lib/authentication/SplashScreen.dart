import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnustudenthousing/helpers/Design.dart';
import 'package:pnustudenthousing/helpers/RouteUsers.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => splashScreenState();
}

class splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () async {
      await LoginChecker.checker(context);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: OurAppBar(),
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const Heightsizedbox(
              h: 0.2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset(
                'assets/logo white.png',
              ),
            ),
            const SizedBox(
              height: 0.005,
            ),
            Dtext(
              t: "Welcome to PNU Student Housing",
              align: TextAlign.center,
              size: 0.07,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ]),
        ),
      ),
    );
  }
}
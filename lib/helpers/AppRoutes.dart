import 'package:flutter/material.dart';
import 'package:pnustudenthousing/Authentication/ForgetPass.dart';
import 'package:pnustudenthousing/Authentication/Login.dart';
import 'package:pnustudenthousing/authentication/SplashScreen.dart';
import 'package:pnustudenthousing/Authentication/SetPassword.dart';
import 'package:pnustudenthousing/Authentication/Register.dart';
import 'package:pnustudenthousing/homeScreen.dart';
import 'package:pnustudenthousing/student/StudentProfile.dart';
import 'package:pnustudenthousing/staff/manager/AddStaff.dart';
import 'package:pnustudenthousing/staff/StaffProfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const splashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgetpass':
        return MaterialPageRoute(builder: (_) => const Forgetpass());
      case '/setpass':
        if (args is SetPassArguments) {
          return MaterialPageRoute(
            builder: (_) => SetPass(args: args),
          );
        }
        return _errorRoute();
      case '/addStaff':
        return MaterialPageRoute(builder: (_) => const addStaff());
      case '/personalacc':
        return MaterialPageRoute(builder: (_) => const studentprofile());
    
      /*  if (args is String) {
          return MaterialPageRoute(
            builder: (_) => StudentDetailsPage(studentId:args),
          );
        } return _errorRoute();
       */

      /*
      case '/student':
        return MaterialPageRoute(builder: (_) => const StudentMain()); 
      case '/manager':
        return MaterialPageRoute(builder: (_) => const Managermain());
      case '/nutritionSpecialist':
        return MaterialPageRoute(builder: (_) => const NutritionSpecialisMain());
      case '/security':
        return MaterialPageRoute(builder: (_) => const Securitymain());
        case '/studentsAffairs':
        return MaterialPageRoute(builder: (_) => const  StudentsAffairsMain();
         case '/supervisor':
        return MaterialPageRoute(builder: (_) => const Supervisormain());
         case '/buildingsOfficer':
        return MaterialPageRoute(builder: (_) => const buildingsOfficermain());
         case '/socialSpecialist':
        return MaterialPageRoute(builder: (_) => const  SocialSpecialistmain());
      */
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR routing'),
        ),
      );
    });
  }
}




/*how to use 
 1-first create class of parameters you needd to pass in same class page that needs these parameters 
// arguments for the route
EXAMPLE
class SetPassArguments {
  final String firstName;
  final String middleName;
  final String lastName;
  final int NID;
  final String email;
  //final String password;
  final String phone;

  SetPassArguments({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.NID,
    required this.email,
    required this.phone,
  });
}

2-set the class that need the parameters to 
class SetPass extends StatefulWidget {
  final SetPassArguments args;

  const SetPass({Key? key, required this.args}) : super(key: key);


3-in the class that needs the paramaeter call it like this 
'firstName': '${widget.args.firstName}',
'middleName': '${widget.args.middleName}',
'lastName': '${widget.args.lastName}',
'fullname':'${widget.args.firstName}  ${widget.args.middleName}  ${widget.args.lastName}',
'PNUID': pnuid,
'email': email,
'phone': '${widget.args.phone}',
'NID': '${widget.args.NID}',

4- in the class that passes the parameters to the class that needs the parameters set it like this 
     Navigator.of(context).pushNamed('/setpass',
arguments: SetPassArguments(
firstName: firstNameController.text.capitalize,
middleName:middleNameController.text.capitalize,
lastName: lastNameController.text.capitalize,
email: emailController.text,
phone: phoneNumberController.text,
NID: int.parse(NIDController.text),
),
);


*/

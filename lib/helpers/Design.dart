import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; //if there is error here write : get: ^4.6.6 in dependencies: under the cupertino_icons on pubspec.yaml file and press pub get
import 'package:image_picker/image_picker.dart'; //if there is error here write : image_picker: ^1.1.2 in dependencies: under the cupertino_icons on pubspec.yaml file and press pub get

class Design extends StatelessWidget {
  const Design({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// 1- color palette
/// 2-Size Helper
/// 3- OurAppBar
/// 4- Heightsizedbox --> dynamic
/// 5- Widthsizedbox --> dynamic
/// 6- title text --> dynamic
/// 7- text --> dynamic
/// 8- Dtext --> dynamic
/// 9- home button1 --> dynamic
/// 10- home button2 --> dynamic
/// 11- Internal Pages Button --> dynamic
/// 12- action button --> dynamic
/// 13- Dialog --> dynamic
/// 14- Error Dialog --> dynamic
/// 15- Text Form Field --> dynamic
/// 16- Password Field --> dynamic
/// 17- custom Form Field--> dynamic
/// 18- pickTime Function
/// 19- pickDate Function

/// 1111111111111111--color palette--1111111111111111  //1
Color dark1 = Color(0xff007580); // for Titles
Color light1 = Color(0xff339199); // for Sub Titles
Color grey1 = Color(0xff98989A); // for descriptions
Color green1 = Color(0xff4ca585); // for success operation
Color blue1 = Color(0xff00a6ce); // for information
Color red1 = Color(
    0xffC83434); // for error massages , text form field not fill , reject or delete or cancel buttons
Color red2 = Color(0xffAf0303);
Color yellow1 = Color(0xffF6cf7f); // for waiting

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';;
* then just you need call color name in any color property for any component in your page
* Ex: color: red1
* i already used in this file you can see full examples in the following Widgets, functions and classes*/

/// 222222222222222--Size Helper class--22222222222222222  //2
/*A helper class to adjust dynamic sized by calculate and return the smaller of the screen's width or height
 * i invented it To ensure that the size of our texts and other page components is appropriate for different screen sizes.*/
class SizeHelper {
  static double getSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height
    return screenWidth > screenHeight
        ? screenHeight
        : screenWidth; // Return the smaller of the two dimensions (either the screen width or height)
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';;
* then just you need call SizeHelper class in any thing you need adjest his size in your page
* Ex: fontSize: SizeHelper.getSize(context) * 0.07 ,
* i already used in this file you can see full examples in the following Widgets, functions and classes*/

/// 333333333333333--OurAppBar--333333333333333  //3
// customizable AppBar with dynamic height and title handling.
class OurAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OurAppBar({super.key, this.title, this.icon, this.onIconPressed});

  final String? title; // Title text for the app bar
  final IconData? icon; // Optional icon for actions like language translation
  final VoidCallback? onIconPressed; // Action when the icon is pressed

  @override
  Widget build(BuildContext context) {
    // Default height for the app bar
    double defaultHeight = 70;

    // Text style for the title
    TextStyle textStyle = TextStyle(
      fontSize: SizeHelper.getSize(context) *
          0.07, // Dynamic font size based on SizeHelper class
      fontWeight: FontWeight.w500,
      color: dark1,
    );

    // Dynamically calculate the height of the title text
    double textHeight = _calculateTextHeight(title ?? "", textStyle, context);

    // Set app bar height to either default or adjusted based on title height
    double appBarHeight = defaultHeight > textHeight + 10
        ? defaultHeight
        : textHeight + 10; // Adjust padding here if needed

    return AppBar(
      toolbarHeight: appBarHeight, // Set the calculated height
      shadowColor: dark1,
      iconTheme: IconThemeData(
        color: dark1,
      ),
      centerTitle: true,
      title: title != null && title!.isNotEmpty
          ? Text(
              title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible, // Wrap text if long
              style: textStyle,
              softWrap: true, // Ensure text wraps to the next line if needed
            )
          : null,
      actions: [
        if (icon != null)
          IconButton(
            icon: Icon(icon, color: dark1), // Set icon for actions
            onPressed: onIconPressed, // Set Action when the icon is pressed
          ),
      ],
    );
  }

  // Helper function to calculate text height
  double _calculateTextHeight(
      String text, TextStyle style, BuildContext context) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );
    textPainter.layout(
      maxWidth:
          MediaQuery.of(context).size.width - 32, // Adjust padding if necessary
    );
    return textPainter.size.height;
  }

  // Correct placement of the preferredSize getter
  @override
  Size get preferredSize => const Size.fromHeight(70);
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call OurAppBar Widget in AppBar on the scaffold of your page and get it your title
* Ex: Scaffold(
      appBar: OurAppBar(
        title: 'Emergency Service' ), );
 */

///  444444444444444--Height sized box-- 444444444444444 //4
// Heightsizedbox dynamically scales based on screen height
class Heightsizedbox extends StatelessWidget {
  const Heightsizedbox({super.key, required this.h});
  final double h; // Proportional height factor

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height
    return SizedBox(
      height: screenHeight * h, // Set proportional height
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call Heightsizedbox Widget in your page and get it your size value
* Ex: Heightsizedbox(h: 0.10),
* it not work in rows */

/// 555555555555555--width sized box--555555555555555  //5
// Widthsizedbox dynamically scales based on screen width
class Widthsizedbox extends StatelessWidget {
  const Widthsizedbox({super.key, required this.w});
  final double w; // Proportional width factor

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    return SizedBox(
      width: screenWidth * w, // Set proportional width
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call Widthsizedbox Widget  in your page and get it your size value
* Ex: Widthsizedbox(w: 0.05),
* it not work in columns */

/// 66666666666666--Titletext--66666666666666  //6
//Title text with dynamic sizing based on SizeHelper class
class Titletext extends StatelessWidget {
  const Titletext({
    super.key,
    required this.t,
    required this.align,
    required this.color,
  });
  final String t; // The Text
  final TextAlign align; // Text alignment
  final Color color; // Text color
  @override
  Widget build(BuildContext context) {
    return Text(
      "$t",
      textAlign: align,
      style: TextStyle(
          fontSize: SizeHelper.getSize(context) *
              0.067, // Dynamic font size based on SizeHelper class
          fontWeight: FontWeight.w500,
          color: color),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call Titletext Widget in your page and get it your title , color  values and manage text Alignment
* Ex: Titletext(t: "NOTE:",
                color: red1,
                align: TextAlign.start, ),
*/

/// 777777777777777--text--7777777777777777777  //7
// Text with dynamic sizing based on SizeHelper class
class text extends StatelessWidget {
  const text({
    super.key,
    required this.t,
    required this.align,
    required this.color,
  });
  final String t; // The Text
  final TextAlign align; // Text alignment
  final Color color; // Text color
  @override
  Widget build(BuildContext context) {
    return Text(
      "$t",
      textAlign: align,
      style: TextStyle(
        fontSize: SizeHelper.getSize(context) *
            0.05, // Dynamic font size based on SizeHelper class
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call text Widget in your page and get it your text , color  values and manage text Alignment
* Ex: text( t: "If you need help with your health, click the following button.",
            align: TextAlign.center,
            color: Colors.black, ),
*/

/// 888888888888888--Dtext--8888888888888888888  //8
// Text with dynamic sizing based on SizeHelper class and the entered size
class Dtext extends StatelessWidget {
  const Dtext({
    super.key,
    required this.t,
    required this.align,
    required this.color,
    required this.size,
    this.fontWeight,
  });

  final String t; // The Text
  final TextAlign align; // Text alignment
  final Color color; // Text color
  final double size; // Text size
  final FontWeight? fontWeight; // Font weight

  @override
  Widget build(BuildContext context) {
    return Text(
      "$t",
      textAlign: align,
      style: TextStyle(
        fontSize: SizeHelper.getSize(context) *
            size, // Dynamic font size based on SizeHelper class and the entered size
        fontWeight:
            (fontWeight ?? FontWeight.w500), // Use the entered font weight
        color: color,
      ),
    );
  }
}
/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call Dtext Widget in your page and get it your text , color,size values and manage text Alignment
* Ex: Dtext(
              t: 'Emergency Contact Information',
              align: TextAlign.center,
              color: dark1,
              size: 0.05,)
*/

/// 9999999999999-- home button1--999999999999999  //9
// Dynamic Button with icon in left side used in the home screens
class HomeButton1 extends StatelessWidget {
  const HomeButton1({
    super.key,
    required this.icon,
    required this.name,
    this.onPressed,
  });

  final IconData icon; // Icon to display
  final String name; // Button text
  final VoidCallback? onPressed; // Action triggered when the button is pressed
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Container(
      height: screenHeight *
          0.09, // Set Dynamic Container height based on screen height
      width:
          screenWidth * 0.9, //Set Dynamic Container width based on screen width
      decoration: BoxDecoration(
        color: light1,
        borderRadius: BorderRadius.all(Radius.circular(50)), // Rounded corners
      ),
      child: Row(children: [
        Container(
          height: screenHeight *
              0.09, //Set Dynamic icon container height based on screen height
          width: screenHeight *
              0.09, //Set Dynamic icon container width based on screen height
          decoration: BoxDecoration(
            color: dark1,
            borderRadius: BorderRadius.all(
                Radius.circular(90)), // Rounded icon container corners
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: SizeHelper.getSize(context) *
                0.09, //Set Dynamic icon size based on based on SizeHelper class
          ),
        ),
        Widthsizedbox(w: 0.05), //Set Dynamic space between icon and text
        TextButton(
          onPressed: onPressed,
          child: AutoSizeText(
            name,
            textAlign: TextAlign.start,
            maxLines: 2, // Allow up to 2 lines of text
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeHelper.getSize(context) *
                  0.06, // Slightly reduced initial font size
            ),
            minFontSize: 18, // Minimum font size to maintain readability
            maxFontSize: 20,
          ),
        ),
      ]),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call HomeButton1 Widget in your page and get it your icon , button name  values and manage onPressed
* the on pressed can be rout or call method
* Ex: HomeButton1(
              icon: Icons.manage_accounts_outlined,
              name: "Housing Services",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HousingServices()));
*/

/// 101010101010101010101010--Home Button2--1010101010101010101010  //10
// Dynamic Button with icon in right side used in the home screens
class HomeButton2 extends StatelessWidget {
  const HomeButton2({
    super.key,
    required this.icon,
    required this.name,
    this.onPressed,
  });

  final IconData icon; // Icon to display
  final String name; // Button text
  final VoidCallback? onPressed; // Action triggered when the button is pressed

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Center(
      child: Container(
        height: screenHeight *
            0.09, // Set Dynamic Container height based on screen height
        width: screenWidth *
            0.9, //Set Dynamic Container width based on screen width
        decoration: BoxDecoration(
          color: light1,
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Rounded corners
        ),
        child: Row(
          mainAxisSize: MainAxisSize
              .min, // ensures the Row only takes up as much space as its contents require
          children: [
            Widthsizedbox(w: 0.05), //Set Dynamic space before text
            Spacer(),
            TextButton(
              onPressed: onPressed,
              child: AutoSizeText(
                name,
                textAlign: TextAlign.start,
                maxLines: 2, // Allow up to 2 lines of text
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeHelper.getSize(context) *
                      0.06, // Slightly reduced initial font size
                ),
                minFontSize: 18, // Minimum font size to maintain readability
                maxFontSize: 20,
              ),
            ),
            Spacer(), //Set Dynamic space between text and icon
            Container(
              height: screenHeight *
                  0.09, //Set Dynamic icon container height based on screen height
              width: screenHeight *
                  0.09, //Set Dynamic icon container width based on screen height
              decoration: BoxDecoration(
                color: dark1,
                borderRadius: BorderRadius.all(
                    Radius.circular(90)), // Rounded icon container corners
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: SizeHelper.getSize(context) *
                    0.09, // Set Dynamic icon size based on SizeHelper class
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call HomeButton2 Widget in your page and get it your icon , button name  values and manage onPressed
* the on pressed can be rout or call method
* Ex: HomeButton2(
              icon: Icons.manage_accounts_outlined,
              name: "Housing Services",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HousingServices()));
*/

/// 1111111111111111111111--Internal Pages Button -111111111111111111111111  //11
// A customizable button used for navigating between internal pages.
class PagesButton extends StatelessWidget {
  const PagesButton({
    super.key,
    required this.name,
    this.onPressed,
  });
  final String name; // Button text to display
  final VoidCallback? onPressed; // Action triggered when the button is pressed

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context)
        .size
        .width; // Get screen width for dynamic sizing
    double screenHeight = MediaQuery.of(context)
        .size
        .height; // Get screen height for dynamic sizing

    return Center(
      child: Container(
        height: screenHeight *
            0.09, // Set dynamic container height based on the screen height
        width: screenWidth *
            0.9, // Set dynamic container width based on the screen width
        decoration: BoxDecoration(
          color: light1, // Background color for the button
          borderRadius: BorderRadius.all(
              Radius.circular(40)), // Rounded corners for a softer look
        ),
        child: TextButton(
          onPressed:
              onPressed, // Assign the passed action to the button's onPressed event
          child: AutoSizeText(
            "$name", // Display the name text
            style: TextStyle(
              color: Colors.white,
              fontSize:
                  SizeHelper.getSize(context) * 0.07, // Set dynamic font size
            ),
            textAlign: TextAlign.center,
            minFontSize: 16, // Minimum font size to maintain readability
            maxFontSize: 22, // Maximum font size to maintain readability
          ),
        ),
      ),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call PagesButton widget in your page and get it your button name and your on preseed
* the on pressed can be rout or call method
* Ex:PagesButton(
              name: "App developers",
                onPressed:() {Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AppDevelopers(),
                ),
              );
*/

/// 1212121212121212121212--action button--1212121212121212121212  //12
// button for cancel , reject , accept , set, login and register buttons
class actionbutton extends StatelessWidget {
  const actionbutton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.background,
    this.fontsize,
  });

  final VoidCallback? onPressed; // Action triggered when the button is pressed
  final String text; // Button text to display
  final Color background; // Background color of the button
  final double? fontsize; // Font size of the button text

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            background), // Custom button background color
      ),
      onPressed:
          onPressed, // Assign the passed action to the button's onPressed event
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 11,
            horizontal: 5), // Vertical and horizontal padding inside the button
        child: Text(
          '${text}', // Display the button text
          style: TextStyle(
            color: Colors.white, // Button text color set to white
            fontSize: SizeHelper.getSize(context) *
                (fontsize ??
                    0.04), // Set the font size for the text dynamically
          ),
        ),
      ),
    );
  }
}
/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call actionbutton widget in your page and get it your button name , background color  , font size  and your on preseed
* the on pressed can be rout or call method
* Ex: actionbutton( onPressed: _uploadData,
                    background: dark1,
                    text: 'Set',
                    fontsize: 0.05),
* to mange button alignment in your page warp it in Row
*/

/// 13131313131313131313--Dialog--13131313131313131313  //13
// A reusable function to display a InfoDialog box with a message and an "OK" button.
// The dialog box takes in a message and a callback function that triggers when the "OK" button is pressed.
Future<dynamic> InfoDialog(String message, BuildContext context,
    {required VoidCallback onPressed}) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: light1, // Sets the background color of the dialog
      contentPadding: const EdgeInsets.fromLTRB(
          20, 30, 20, 30), // Padding around the dialog content
      children: [
        Center(
          child: Text(
            "$message", // Displays the message passed to the dialog
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              10, 20, 10, 0), // Padding for the button
          child: TextButton(
            onPressed:
                onPressed, // Executes the callback when the button is pressed
            child: Text("OK",
                style: TextStyle(color: Colors.white)), // Button text
            style: TextButton.styleFrom(
              backgroundColor: dark1, // Background color of the button
            ),
          ),
        ),
      ],
    ),
  );
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call dialog method in your page and get it your massege , context  values and manage onPressed
* Ex: dialog("Event created successfully", context, onPressed: () {
      Navigator.of(context).pop();
      },);
*/

/// 141414141414141414--Error Dialog--141414141414141414  //14
// A reusable function to display a custom error dialog box with a message and an "OK" button.
// The dialog box takes in a message and a callback function that triggers when the "OK" button is pressed.
Future<dynamic> ErrorDialog(String message, BuildContext context,
    {required VoidCallback onPressed}) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor:
          red1, // Sets the background color of the dialog to signify an error
      contentPadding: const EdgeInsets.fromLTRB(
          20, 30, 20, 30), // Padding around the dialog content
      children: [
        Center(
          child: Text(
            "$message", // Displays the error message passed to the dialog
            style: TextStyle(
                color: Colors
                    .white), // Text color to ensure readability against red background
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              10, 20, 10, 0), // Padding for the button
          child: TextButton(
            onPressed:
                onPressed, // Executes the callback when the button is pressed
            child: Text("OK",
                style: TextStyle(color: Colors.white)), // Button text
            style: TextButton.styleFrom(
              backgroundColor:
                  red2, // Background color of the button to match error theme
            ),
          ),
        ),
      ],
    ),
  );
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call dialog method in your page and get it your massege , context  values and manage onPressed
* Ex: ErrorDialog("An unexpected error occurred", context,
///   onPressed: () {
//       Navigator.of(context).pop();
//       },);
*/

/// 151515151515151515--Text Form Field--151515151515151515  //15
// A reusable text form field widget for handling user input.
//It supports customization of the input controller, hint text, number of lines, and validator function.
class textform extends StatelessWidget {
  textform({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.lines,
    required this.validator,
    this.icon,
    this.iconColor,
  });
  final TextEditingController
      controller; // TextEditingController for managing the input value
  final String hinttext; // Placeholder text for the input field
  final int lines; // Number of lines the text field can display
  final FormFieldValidator validator; // Validator function for form validation
  final IconData? icon; // Optional icon to display in the input field
  final Color? iconColor; // Optional color for the icon

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:
          controller, // Bind the text field's input to the provided controller
      cursorColor: dark1, // Set the cursor color
      validator:
          validator, // Attach the validator function for validation logic
      decoration: InputDecoration(
        hintText: hinttext, // Display hint text
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: red1,
            ), // Border color when the input is invalid
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: red2),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: green1), // Border when the input is focused
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: light1), // Border when the input is enabled
            borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, // Horizontal padding for input content
          vertical: 6, // Vertical padding for input content
        ),
        fillColor: Colors.white, // Background color of the input field
        filled: true, // Enable background color fill
        prefixIcon: icon != null
            ? Icon(
                icon, // Display the optional icon if provided
                color: iconColor ??
                    dark1, // Use provided icon color or default to dark1
              )
            : null, // No icon if none is provided
      ),
      maxLines: lines, // Maximum number of lines for text input
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call textform Widget in your page and get it your controller , hinttext , numbers of lines   values and manage validator
* you need unique controller for each text form in your page and don`t forget definition the controller before used it in text form
* EX for definition controller : TextEditingController Enamecontroller =TextEditingController(); // Controller for the event name.
* Ex for used text form :
  textform(
     controller: Elocationcontroller,
     hinttext: "Event Location",
     lines: 1,
     validator: (val) {
         if (val == null || val.trim().isEmpty) {
              return "Please Write Event Location"; // Displays this error if field is empty
                  }
              return null; // No error if the input is valid
        },
      ),

* ex for use controller in save data method: eventName': Enamecontroller.text,
*/

/// 161616161616161616--Password Field--161616161616161616  //16
/* A specialized text form field for password input with an "obscure text" toggle,
It hides the password by default and allows the user to toggle the visibility.*/
class PasswordField extends StatelessWidget {
  final TextEditingController
      passwordController; // Controller for password input
  final String hintText; // Hint text for password field
  final FormFieldValidator<String>
      validator; // Validator for password validation

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isObsecure = true
        .obs; // Create an observable variable to control password visibility

    return Obx(
      () => TextFormField(
        controller: passwordController, // Bind input to the password controller
        obscureText: isObsecure
            .value, // Hide or show the password based on isObsecure's value
        validator:
            validator, // Attach the validator function for validation logic
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.vpn_key_sharp, // Icon for password input
            color: Color(0xff007580), // Color of the icon
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              isObsecure.value =
                  !isObsecure.value; // Toggle password visibility on tap
            },
            child: Icon(
              isObsecure.value
                  ? Icons.visibility_off
                  : Icons
                      .visibility, // Icon changes based on password visibility
              color: const Color(0xff007580),
            ),
          ),
          hintText: hintText, // Display hint text
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: red1, // Border color when there is a validation error
              ),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red2),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: green1), // Border when the input is focused
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: light1), // Border when the input is enabled
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, // Horizontal padding for input content
            vertical: 6, // Vertical padding for input content
          ),
          fillColor: Colors.white, // Background color of the input field
          filled: true, // Enable background color fill
        ),
      ),
    );
  }
}

/// 171717171717171717--custom Form Field--171717171717171717  //17
/* A reusable custom form field widget that supports image upload, date selection,
  and time selection functionalities.
 * Returns a FormField widget with validation based on the field type. */
Widget customFormField({
  File? imageFile, // For image upload
  DateTime? selectedDate, // For date picker
  TimeOfDay? selectedTime, // For time picker
  Future<void> Function()? onPickImage, // Callback for image picker
  Future<DateTime?> Function()? onSelectDate, // Callback for date picker
  Future<TimeOfDay?> Function()? onSelectTime, // Callback for time picker
  required String labelText, // Label for the form field
  String fieldType = 'text', // 'image', 'date', 'time'
}) {
  return FormField<dynamic>(
    validator: (val) {
      switch (fieldType) {
        case 'image':
          if (imageFile == null) {
            return "Please upload an image";
          }
          break;
        case 'date':
          if (selectedDate == null) {
            return "Please select a date";
          }
          break;
        case 'time':
          if (selectedTime == null) {
            return "Please select a time";
          }
          break;
      }
      return null;
    },
    builder: (FormFieldState<dynamic> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(labelText, style: TextStyle(color: dark1)),
              Widthsizedbox(w: 0.02),
              if (fieldType == 'image') ...[
                imageFile == null
                    ? actionbutton(
                        onPressed: () async {
                          if (onPickImage != null) {
                            await onPickImage(); // Trigger image picker
                            state
                                .didChange(imageFile); // Update FormField state
                          }
                        },
                        background: dark1,
                        text: 'Upload',
                        fontsize: 0.04)
                    : Image.file(imageFile!, height: 100),
              ] else if (fieldType == 'date') ...[
                actionbutton(
                    onPressed: () async {
                      if (onSelectDate != null) {
                        await onSelectDate(); // Trigger date picker
                        state.didChange(selectedDate); // Update FormField state
                      }
                    },
                    background: dark1,
                    text: selectedDate == null
                        ? 'Date'
                        : '${selectedDate!.day}/${selectedDate.month}/${selectedDate.year}',
                    fontsize: 0.04)
              ] else if (fieldType == 'time') ...[
                actionbutton(
                    onPressed: () async {
                      if (onSelectTime != null) {
                        await onSelectTime(); // Trigger time picker
                        state.didChange(selectedTime); // Update FormField state
                      }
                    },
                    background: dark1,
                    text: selectedTime == null
                        ? 'Time'
                        : selectedTime!.format(state.context),
                    fontsize: 0.04)
              ]
            ],
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Text(
                state.errorText ?? "",
                style: TextStyle(color: red1),
              ),
            ),
        ],
      );
    },
  );
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call customFormField Widget in your page and get it your field Type , your object based on field type(imageFile or selectedDate or selectedTime) ,
* label text values and your function based on field type(onPickImage or onSelectDate or onSelectTime)
* Ex for used customFormField for pick image :
* for image dont forget the import:import 'dart:io';
  customFormField(
                fieldType: 'image',
                imageFile: _image,
                onPickImage:() async {
                  final File? pickimage = await pickImage(context);  // the pickImage(context) it`s the function in the bellow (20 in this Design file)
                  if (pickImage != null) {
                    setState(() {
                      _image = pickimage; // Update the selected date
                    });
                  }
                },
                labelText: "Upload Picture:",
              ),
 * Ex for used customFormField for select date :
  customFormField(
                fieldType: 'date',
                selectedDate: selectedDate,
                onSelectDate: () async {
                  final DateTime? pickedDate = await pickDate(context); // the pickDate(context) it`s the function in the bellow (19 in this Design file)
                  if (pickDate != null) {
                    setState(() {
                      selectedDate = pickedDate; // Update the selected date
                    });
                  }
                },
                labelText: "Select Date:",
              ),
 * Ex for used customFormField for select time :
  customFormField(
                fieldType: 'time',
                selectedTime: selectedTime,
                onSelectTime: () async {
                  final TimeOfDay? pickedTime = await pickTime(context); // the pickTime(context) it`s the function in the bellow (18 in this Design file)
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime; // Update the selected time
                    });
                  }
                },
                labelText: "Select Time:",
              ),

*/

/// 181818181818181818--pickTime Function--181818181818181818  //18
Future<TimeOfDay?> pickTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(), // Use current time if no time selected
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          primaryColor: dark1, // Custom primary color
          timePickerTheme: TimePickerThemeData(
            dialHandColor: dark1, // Custom dial hand color
            entryModeIconColor: dark1, // Custom entry mode icon color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: dark1, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked; // Return the picked time
}

/*use same the customFormField for pickTime example
*/

/// 191919191919191919--pickDate Function--191919191919191919  //19
Future<DateTime?> pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // The default date is today's date.
    firstDate: DateTime(2021), // The earliest selectable date.
    lastDate: DateTime(2101), // The latest selectable date.
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: dark1, // Custom primary color for the date picker.
          colorScheme: ColorScheme.light(primary: dark1),
        ),
        child: child!, // Embedding the date picker in the custom theme.
      );
    },
  );

  return picked; // Return the picked date
}

/*use same the customFormField for pickDate example*/

/// 202020202020202020--pickImage Function--202020202020202020  //20
// Picks an image from the gallery and returns a File object.
// If no image is picked, returns null.
Future<File?> pickImage(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path); // Return the File object
  }

  return null; // Return null if no image was picked
}

/* example for used it :
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart'; and import:import 'dart:io';
* then just you need definition file? variable then asign pickimage function to it
* if you need validator the image use same the customFormField for pick image example
* if you don`t need to validator the image use in action button
* EX for use pick image in action button:
* _image == null ? actionbutton(
                          onPressed: () async {
                            final File? pickimage = await pickImage(context);  // the pickImage(context) it`s the function in the bellow (20 in this Design file)
                            if (pickImage != null) {
                              setState(() {
                                _image = pickimage; // Update the selected date
                              });
                            }
                          },
                          background: dark1,
                          text: 'Upload',
                          fontsize: 0.03)
                      : Image.file(_image!,
                      width: MediaQuery.of(context).size.width * 0.2, //adjust the width
                      height: MediaQuery.of(context).size.height * 0.2) // Show selected image if available

*  _image i definition in up my code as : File? _image;
*/

class TextCapitalizer {
  static String CtextS(String string) {
    if (string.isEmpty) {
      return string;
    }

    List<String> words = string.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }
}

/*String fullname = firstNameController.text +
        " " +
        middleNameController.text +
        " " +
        lastNameController.text;
    print(fullname);
    fullname = TextCapitalizer.CtextS(fullname);
    print(fullname); */

class RowInfo {
  static Row buildInfoRow({
    required String? defaultLabel,
    String? value,
    String Function(String?)? customLabelLogic,
  }) {
    String label = customLabelLogic != null
        ? (customLabelLogic(value) ?? defaultLabel ?? 'N/A')
        : (defaultLabel ?? 'N/A');

    return Row(
      children: [
        Dtext(
          t: '$label: ',
          align: TextAlign.center,
          color: dark1,
          size: 0.035,
        ),
        Dtext(
          t: value ?? 'N/A',
          align: TextAlign.center,
          color: light1,
          size: 0.035,
        ),
      ],
    );
  }
}

/*
RowInfo.buildInfoRow(
                      defaultLabel: 'Email',
                      value: studentData?['email']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'Phone Number',
                      value: studentData?['phone']?.toString(),
                    ),
                    RowInfo.buildInfoRow(
                      defaultLabel: 'ID Type:',
                      value: studentData?['NID']?.toString(),
                      customLabelLogic: (value) {
                        if (value != null && value.startsWith('2')) {
                          return 'Iqama';
                        } else if (value != null && value.startsWith('1')) {
                          return 'National ID';
                        } else {
                          return 'Unknown ID Type';
                        }
                      },
                    ),
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; //if there is error here write : auto_size_text: ^3.0.0 in dependencies: under the cupertino_icons on pubspec.yaml file and press pub get
import 'package:get/get.dart'; //if there is error here write : get: ^4.6.6 in dependencies: under the cupertino_icons on pubspec.yaml file and press pub get
import 'package:image_picker/image_picker.dart'; //if there is error here write : image_picker: ^1.1.2 in dependencies: under the cupertino_icons on pubspec.yaml file and press pub get

class Design extends StatelessWidget {
  const Design({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// 1 - color palette
/// 2 - Size Helper
/// 3 - OurAppBar
/// 4 - Heightsizedbox --> dynamic
/// 5 - Widthsizedbox --> dynamic
/// 6 - title text --> dynamic
/// 7 - text --> dynamic
/// 8 - Dtext --> dynamic
/// 9 - home button1 --> dynamic
/// 10 - home button2 --> dynamic
/// 11 - Internal Pages Button --> dynamic
/// 12 - action button --> dynamic
/// 13 - Dynamic action button --> dynamic
/// 14 - Information Dialog --> dynamic
/// 15 - Error Dialog --> dynamic
/// 16 - Text Form Field --> dynamic
/// 17 - Password Field --> dynamic
/// 18 - Our Form Field--> dynamic
/// 19 - pickTime Function
/// 20 - pickDate Function
/// 21 - pickImage Function
/// 22 - TextCapitalizer
/// 23 - RowInfo
/// 24 - DropdownList
/// 25 - Our List View Widget
/// 26 - Our Loading Indicator
/// 27 - Our Container
/// 28 - Our Checkbox Pledge
/// 29 - Our Status

/// ------------------ color palette -------------------  //1
Color dark1 = Color(0xff007580); // for Titles
Color light1 = Color(0xff339199); // for Sub Titles
Color grey1 = Color(0xff98989A); // for descriptions
Color grey2 = grey1.withOpacity(0.1);
Color green1 = Color(0xff4ca585); // for success operation
Color blue1 = Color(0xff00a6ce); // for information
Color red1 = Color(
    0xffC83434); // for error massages , text form field not fill , reject or delete or cancel buttons
Color red2 = Color(0xffAf0303);
Color pink1 =Color.fromARGB(255, 200, 52, 178);
Color yellow1 = Color(0xffF6cf7f); // for waiting
Color yellow2 = Color.fromARGB(255, 253, 195, 78); // for waiting


/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call color name in any color property for any component in your page
* Ex: color: red1
* i already used in this file you can see full examples in the following Widgets, functions and classes */

/// ------------------ Size Helper class -------------------  //2
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
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call SizeHelper class in any thing you need adjest his size in your page
* Ex: fontSize: SizeHelper.getSize(context) * 0.07 ,
* i already used in this file you can see full examples in the following Widgets, functions and classes*/

/// ------------------ Our AppBar -------------------  //3
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

/// ------------------ Height sized box -------------------  //4
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

/// ------------------ width sized box -------------------  //5
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

/// ------------------ Title text -------------------  //6
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
              0.057, // Dynamic font size based on SizeHelper class
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

/// ------------------ text -------------------  //7
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

/// ------------------ Dynamic text -------------------  //8
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

/// ------------------ home button1 -------------------   //9
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
            textAlign: TextAlign.center,
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

/// ------------------ Home Button2 -------------------  //10
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
                textAlign: TextAlign.center,
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

/// ------------------ Internal Pages Button -------------------  //11
// A customizable button used for navigating between internal pages.
class PagesButton extends StatelessWidget {
  const PagesButton({
    super.key,
    required this.name,
    this.onPressed,
    this.background,
    
  });
  final String name; // Button text to display
  final VoidCallback? onPressed; // Action triggered when the button is pressed
  final Color? background;
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
          color: (background ?? light1), // Background color for the button
          borderRadius: const BorderRadius.all(
              Radius.circular(40)), // Rounded corners for a softer look
        ),
        child: TextButton(
          onPressed:
              onPressed, // Assign the passed action to the button's onPressed event
          child: AutoSizeText(
            name, // Display the name text
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

/// ----------------- action button -------------------  //12
// button for cancel , reject , accept , set, login and register buttons
class actionbutton extends StatelessWidget {
  const actionbutton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.background,
    this.fontsize,
    this.padding,
  });

  final VoidCallback? onPressed; // Action triggered when the button is pressed
  final String text; // Button text to display
  final Color background; // Background color of the button
  final double? fontsize; // Font size of the button text
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            background), // Custom button background color
        padding: padding != null
            ? MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: padding!,
                horizontal: padding!,
              ))
            : null,
      ),
      onPressed:
          onPressed, // Assign the passed action to the button's onPressed event
      child: // Vertical and horizontal padding inside the button
          Text(
        '${text}', // Display the button text
        style: TextStyle(
          color: Colors.white, // Button text color set to white
          fontSize: SizeHelper.getSize(context) *
              (fontsize ?? 0.04), // Set the font size for the text dynamically
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

/// ------------------ Dynamic action button -------------------  //13
// A custom action button widget that adapts its size based on screen dimensions.
class Dactionbutton extends StatelessWidget {
  const Dactionbutton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.background,
    this.fontsize,
    this.height,
    this.width,
    this.padding,
  });

  final VoidCallback? onPressed; // Action triggered when the button is pressed
  final String text; // Button text to display
  final Color background; // Background color of the button
  final double? fontsize; // Font size of the button text
  final double? height; // Height ratio of the button relative to screen height
  final double? width; // Width ratio of the button relative to screen width
  final double? padding;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return SizedBox(
      height: screenHeight * (height ?? 0.033), // Set button height
      width: screenWidth * (width ?? 0.25), // Set button width
      child: actionbutton(
        text: text, // Display button text
        background: background, // Set button background color
        onPressed: onPressed, // Define button action
        fontsize: fontsize, // Optional font size
        padding: padding,
      ),
    );
  }
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call Dactionbutton widget in your page and get it your button text , background color  , font size and your on preseed
* the mange your on pressed method
* Ex:  Dactionbutton(
                     text: 'View File',
                     background: dark1,
                     fontsize: 0.03,
                      padding: 0.0,
                     onPressed: () {},  // you need Define what happens when the button is pressed
                      ),

* to mange button alignment in your page warp it in Row
*/

/// ------------------ Information Dialog -------------------  //14
// A reusable function to display a InfoDialog box with a message and an "OK" button.
// The dialog box takes in a message and a callback function that triggers when the "OK" button is pressed.
Future<dynamic> InfoDialog(String message, BuildContext context,
    {required List<Map<String, VoidCallback>> buttons}) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            backgroundColor: light1, // Sets the background color of the dialog
            contentPadding: const EdgeInsets.fromLTRB(
                20, 30, 20, 30), // Padding around the dialog content
            children: [
              Center(
                child: Dtext(
                  t: message,
                  color: Colors.white,
                  align: TextAlign.center,
                  size: 0.03,
                ), // Dialog message text
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buttons.map((button) {
                    return ElevatedButton(
                      onPressed: button.values.first,
                      child: Dtext(
                        t: button.keys.first,
                        color: Colors.white,
                        align: TextAlign.center,
                        size: 0.03,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: dark1,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ));
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call info  dialog method in your page and get it your massege , context  values and manage onPressed
* Ex: infoDialog(

                    "Confirm logout",
                    context,
                    buttons: [
                      {
                        "Confirm": () async => _auth.signout(context),
                      },
                      {
                        "Cancel": () async => context.pop(),
                      }
                      ],
                  );
*/

/// ------------------ Error Dialog -------------------  //15
// A reusable function to display a custom error dialog box with a message and an "OK" button.
// The dialog box takes in a message and a callback function that triggers when the "OK" button is pressed.
Future<dynamic> ErrorDialog(String message, BuildContext context,
    {required List<Map<String, VoidCallback>> buttons}) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            backgroundColor: red1, // Sets the background color of the dialog
            contentPadding: const EdgeInsets.fromLTRB(
                20, 30, 20, 30), // Padding around the dialog content
            children: [
              Center(
                child: Dtext(
                  t: message,
                  color: Colors.white,
                  align: TextAlign.center,
                  size: 0.03,
                ), // Dialog message text
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buttons.map((button) {
                    return ElevatedButton(
                      onPressed: button.values.first,
                      child: Dtext(
                        t: button.keys.first,
                        color: Colors.white,
                        align: TextAlign.center,
                        size: 0.03,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: red2,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ));
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call dialog method in your page and get it your massege , context  values and manage onPressed
* Ex:    ErrorDialog(
                    "Confirm logout",
                    context,
                    buttons: [
                      {
                        "Confirm": () async => _auth.signout(context),
                      },
                      {
                        "Cancel": () async => context.pop(),
                      }
                    ],
                  );
*/

/// ------------------ Text Form Field -------------------  //16
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

/// ------------------ Password Field -------------------  //17
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

/// ------------------ Our Form Field -------------------  //18
/* A reusable custom form field widget that supports image upload, date selection,
  and time selection functionalities.
 * Returns a FormField widget with validation based on the field type. */
Widget OurFormField({
  File? imageFile,
  DateTime? selectedDate,
  DateTime? selectedDate1, // For the new date picker
  TimeOfDay? selectedTime,
  Future<void> Function()? onPickImage,
  Future<DateTime?> Function()? onSelectDate,
  Future<DateTime?> Function()? onSelectDate1, // Callback for the new date picker
  Future<TimeOfDay?> Function()? onSelectTime,
  required String labelText,
  String fieldType = 'text',
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
          } else if (selectedDate!.isBefore(DateTime.now())) {
            return "Please select a future date";
          }
          break;
        case 'date1':
          if (selectedDate1 == null) {
            return "Please select a valid date";
          }
          break;
        case 'time':
          if (selectedTime == null) {
            return "Please select a time";
          } else if (selectedTime.hour >= 0 && selectedTime.hour < 6) {
            return "Time cannot be between 12 AM and 6 AM";
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
              Dtext(
                t: labelText,
                color: dark1,
                align: TextAlign.start,
                size: 0.045,
              ),
              Widthsizedbox(w: 0.02),
              if (fieldType == 'image') ...[
                imageFile == null
                    ? actionbutton(
                        onPressed: () async {
                          if (onPickImage != null) {
                            await onPickImage();
                            state.didChange(imageFile);
                          }
                        },
                        padding: 5,
                        background: dark1,
                        text: 'Upload',
                        fontsize: 0.035)
                    : Image.file(imageFile!, height: 100),
              ] else if (fieldType == 'date') ...[
                actionbutton(
                    onPressed: () async {
                      if (onSelectDate != null) {
                        await onSelectDate();
                        state.didChange(selectedDate);
                      }
                    },
                    padding: 5,
                    background: dark1,
                    text: selectedDate == null
                        ? 'Date'
                        : '${selectedDate!.day}/${selectedDate.month}/${selectedDate.year}',
                    fontsize: 0.035)
              ] else if (fieldType == 'date1') ...[
                actionbutton(
                    onPressed: () async {
                      if (onSelectDate1 != null) {
                        await onSelectDate1();
                        state.didChange(selectedDate1);
                      }
                    },
                    padding: 5,
                    background: dark1,
                    text: selectedDate1 == null
                        ? 'Date'
                        : '${selectedDate1!.day}/${selectedDate1.month}/${selectedDate1.year}',
                    fontsize: 0.035)
              ] else if (fieldType == 'time') ...[
                actionbutton(
                    onPressed: () async {
                      if (onSelectTime != null) {
                        await onSelectTime();
                        state.didChange(selectedTime);
                      }
                    },
                    padding: 5,
                    background: dark1,
                    text: selectedTime == null
                        ? 'Time'
                        : selectedTime!.format(state.context),
                    fontsize: 0.035)
              ]
            ],
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Dtext(
                t: state.errorText ?? "",
                color: red1,
                align: TextAlign.center,
                size: 0.04,
              ),
            ),
        ],
      );
    },
  );
}

/* example for used it :
* first don`t forget the import: import 'package:pnustudenthousing/Design.dart';
* then just you need call OurFormField Widget in your page and get it your field Type , your object based on field type(imageFile or selectedDate or selectedTime) ,
* label text values and your function based on field type(onPickImage or onSelectDate or onSelectTime)
* Ex for used OurFormField for pick image :
* for image dont forget the import:import 'dart:io';
  OurFormField(
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
                labelText: "Upload Picture:", // if you don`t need labelText make it  empty : labelText: "",
              ),
 * Ex for used OurFormField for select date :
  OurFormField(
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
                labelText: "Select Date:", // if you don`t need labelText make it  empty : labelText: "",
              ),
 * Ex for used OurFormField for select time :
  OurFormField(
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
                labelText: "Select Time:", // if you don`t need labelText make it  empty : labelText: "",
              ),

*/
/// ------------------ pickTime Function -------------------  //19
Future<TimeOfDay?> pickTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(), // Use current time if no time selected
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          // primary color
          primaryColor: Color(0xff007580),

          // custom theme
          timePickerTheme: TimePickerThemeData(
            // background
            backgroundColor: Colors.white,
            // dial handler
            dialHandColor: Color(0xff339199),
            // icon color
            entryModeIconColor: Color(0xff339199),
            // dial background
            dialBackgroundColor: grey2,
            // seprator color
            timeSelectorSeparatorColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? Color(0xff007580)
                  : Color.fromARGB(141, 0, 117, 128),
            ),
            // H M text color
            hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? Color(0xff339199)
                    : Color.fromARGB(195, 0, 117, 128)),
            // H M background color
            hourMinuteColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? Color.fromARGB(100, 51, 144, 153)
                  : Color.fromARGB(15, 51, 144, 153),
            ),

            dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? Color(0xff339199)
                    : Color.fromARGB(195, 0, 117, 128)),
            // day Period Color
            dayPeriodColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? Color.fromARGB(100, 51, 144, 153)
                  : Color.fromARGB(15, 51, 144, 153),
            ),
            helpTextStyle: TextStyle(color: dark1, fontWeight: FontWeight.w500),
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

/* use same the OorFormField for pickTime example */

/// ------------------ pickDate Function -------------------  //20
Future<DateTime?> pickDate(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime lastSelectableDate = DateTime(now.year + 20, now.month, now.day);
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate:now, // The default date is today's date.
    firstDate:now, // The earliest selectable date.
    lastDate:lastSelectableDate, // The latest selectable date.
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
// pick date 1
Future<DateTime?> pickDate1(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime firstSelectableDate = DateTime(now.year - 25, now.month, now.day);
  final DateTime lastSelectableDate = DateTime(now.year - 15, now.month, now.day);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: lastSelectableDate, // Default to the latest possible date (15 years before now).
    firstDate: firstSelectableDate, // Earliest date (25 years before now).
    lastDate: lastSelectableDate, // Latest date (15 years before now).
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

/*use same the OurFormField for pickDate example*/

/// ------------------ pickImage Function -------------------  //21
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
* if you need validator the image use same the OurFormField for pick image example
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

/// ------------------ Text Capitalizer class -------------------  //22
// This class contains a static method to capitalize the first letter of each word in a string.
class TextCapitalizer {
  // Method to capitalize the first letter of each word in a given string.
  //If the string is empty, it returns the original string.
  static String CtextS(String string) {
    if (string.isEmpty) {
      return string;
    }

    // Split the string by spaces to get individual words.
    List<String> words = string.split(' ');

    // Capitalize the first letter of each word, and convert the rest to lowercase.
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Return empty word if found.
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Join the capitalized words back into a single string.
    return capitalizedWords.join(' ');
  }
}

/* Example usage of TextCapitalizer:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* EX:
   String fullname = firstNameController.text +
       " " +
       middleNameController.text +
       " " +
       lastNameController.text;
   print(fullname);
   fullname = TextCapitalizer.CtextS(fullname);
   print(fullname); */

/// ------------------ RowInfo class -------------------  //23
// This class builds a row widget displaying a label and its corresponding value.
class RowInfo {
  // Builds a row with a label and value using custom logic.
  // - defaultLabel: The default label to display.
  // - value: The value to display next to the label.
  // - customLabelLogic: Optional function to apply custom logic to determine the label.
  static Row buildInfoRow({
    required String? defaultLabel,
    String? value,
    String Function(String?)? customLabelLogic,
  }) {
    // Determine the label using the custom logic or the default label if no custom logic is provided.
    String label = customLabelLogic != null
        ? (customLabelLogic(value) ?? defaultLabel ?? 'N/A')
        : (defaultLabel ?? 'N/A');

    return Row(
      children: [
        // Display the label.
        Dtext(
          t: '$label: ',
          align: TextAlign.center,
          color: dark1,
          size: 0.035,
        ),
        // Display the value.
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

/* Example usage of RowInfo:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* EX1:
RowInfo.buildInfoRow(
  defaultLabel: 'Email',
  value: studentData?['email']?.toString(),
),
* EX2:
RowInfo.buildInfoRow(
  defaultLabel: 'Phone Number',
  value: studentData?['phone']?.toString(),
),
* EX3:
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

/// ------------------ DropdownList class -------------------  //24
// This class represents a custom dropdown list widget with validation and customization.
class DropdownList extends StatefulWidget {
  final List<String> items; // The list of dropdown items.
  final ValueChanged<String>
      onItemSelected; // Callback when an item is selected.
  final String hint; // Placeholder hint text.

  // Constructor to initialize the dropdown list.
  const DropdownList({
    Key? key,
    required this.items,
    required this.onItemSelected,
    required this.hint,
  }) : super(key: key);

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? selectedItem; // The selected item.

  @override
  Widget build(BuildContext context) {
    return Container(
      // Dropdown button form field with validation and item selection logic.
      child: DropdownButtonFormField<String>(
        hint: Text(widget.hint), // Display hint.
        value: selectedItem, // Currently selected item.
        
        onChanged: (String? newValue) {
          setState(() {
            selectedItem = newValue; // Update selected item.
          });

          widget.onItemSelected(newValue!); // Trigger the callback.
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select'; // Validation message
          }
          return null;
        }, // Validation function.
        dropdownColor: Colors.white, // Dropdown menu color.
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: red1, // Border color when there's an error.
              ),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red), // Error border.
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: green1), // Border color when focused.
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: light1), // Normal border color.
              borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          fillColor: Colors.white, // Fill color for the dropdown field.
          filled: true,
        ),
        // Dropdown menu items.
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 2, ),
          );
        }).toList(),
        menuMaxHeight: 200.0, // Maximum height for the dropdown menu.
      ),
    );
  }
}

/* Example usage of DropdownList:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* ----set the value----
void onRoleSelected(String role) {
  if (role.isNotEmpty) {
    setState(() {
      selectedRole = role; // Set the selected role.
    });
  }
}

*EX of DropdownList widget call:
DropdownList(
  hint: "Staff Role",
  items: [
    'Students affairs officer',
    'Resident student supervisor',
    'Housing security guard',
    'Housing buildings officer',
    'Nutrition specialist',
    'Social Specialist'
  ],
  onItemSelected: onRoleSelected,
),
*/

/// ------------------ Our List View Widget -------------------  //25
// A custom ListView widget that displays a list of items with customizable
// leading and trailing widgets, and allows actions when tapping on the title.
Widget OurListView({
  required List<dynamic> data,
  Widget Function(dynamic item)? leadingWidget,
  Widget Function(dynamic item)? trailingWidget,
  Function(dynamic item)? onTap, // Made onTap optional
  required dynamic title, // Can be a string or a function
}) {
  return ListView.builder(
    itemCount: data.length, // Number of items in the list
    itemBuilder: (context, index) {
      final item = data[index]; // Get the current item based on the index

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: grey2, // Background color for the list item container
          borderRadius: BorderRadius.circular(3), // Rounded corners
        ),
        child: ListTile(
          // Leading widget: Optional, can be customized for each item
          leading: leadingWidget != null ? leadingWidget(item) : null,
          // Title: Check if title is a function or string
          title: GestureDetector(
            onTap: onTap != null
                ? () => onTap(item)
                : null, // Trigger onTap if provided
            child: text(
              t: title is String ? title : title(item), // Handle both cases
              align: TextAlign.start,
              color: dark1,
            ),
          ),
          // Trailing widget: Optional, can be customized for each item
          trailing: trailingWidget != null ? trailingWidget(item) : null,
        ),
      );
    },
  );
}


/* Example usage of OurListView:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* EX of used with circle Avatar color (view daily attendance page):
   OurListView(
            data: studentData,
            trailingWidget: (item) => CircleAvatar(
              radius: 15,
              backgroundColor: item['color'],
            ),
            onTap: (item) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailsPage(
                    pnuid: item['PNUID'],
                  ),
                ),
              );
            },
            title: 'name',
          );
* EX of used with Button:
     OurListView(
            data: requests,
            leadingWidget: (item) => text(
              t: '0${requests.indexOf(item) + 1}',
              color: dark1,
              align: TextAlign.start,
            ),
            trailingWidget: (item) => Dactionbutton(
              height: 0.044 ,
              width: 0.19,
              text: 'View',
              background: dark1,
              fontsize: 0.03,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRequestDetails(item['requestId']),
                  ),
                );
              },
            ),
            title: 'studentName', // Updated to pass the string key directly
          ),
        );
* EX of used with Icon such as arrow :
          OurListView(
            data: studentData,
            trailingWidget: (item) => IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: dark1,
                size: SizeHelper.getSize(context) * 0.09,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage(
                      pnuid: item['PNUID'],
                    ),
                  ),
                );
              },
            ),
            title: 'name',
          );

* if  you want numpring the list writ your numpring finction in  leadingWidget EX:
    leadingWidget: (item) => text(t:'0${remainingFurniture.indexOf(item) + 1}',color: dark1 , align: TextAlign.start,),

*/

/// ------------------ Our Loading Indicator -------------------  //26
// A custom loading indicator widget that displays a circular progress indicator.
class OurLoadingIndicator extends StatelessWidget {
  const OurLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: dark1, // Custom color for the loading indicator
    );
  }
}

/* Example usage of OurListView:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* just you need call OurLoadingIndicator
* EX:
*       OurLoadingIndicator()
*/

/// ------------------ Our Container -------------------  //27
// A custom container widget that applies a consistent decoration style.
class OurContainer extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color backgroundColor;
  final Color borderColor;
  final double? wdth;
  final double? hight;
  final double pddng;
  final double? borderRadius;
  // Constructor with default values
  const OurContainer({
    Key? key,
    required this.child,
    this.pddng = 15,
    this.wdth,
    this.hight,
    this.borderRadius = 30,
    this.borderWidth = 1.0, // Default border width
    this.backgroundColor = Colors.white, // Default background color
    this.borderColor = const Color(0xFF007580), // Default border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wdth != null ? SizeHelper.getSize(context) * wdth! : null,
      height: hight != null ? SizeHelper.getSize(context) * hight! : null,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius:
            BorderRadius.circular(borderRadius ?? 30), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(pddng), // Inner padding around the child widget
        child: child,
      ),
    );
  }
}

/* Example usage of OurListView:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* just you need call OurContainer and giv your child
* EX:
*       OurContainer(
          wdth: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: []),),
*/

/// ------------------ Our Checkbox Pledge -------------------  //28
// A custom checkbox widget that displays a pledge with a checkbox.
class OurCheckboxPledge extends StatefulWidget {
  // Holds the current checked state of the checkbox.
  final bool value;

  // The text of the pledge that will be displayed next to the checkbox.
  final String Pledge;

  // Callback function triggered when the checkbox state changes.
  final ValueChanged<bool> onChanged;

  // Constructor with required parameters and default values.
  const OurCheckboxPledge({
    Key? key,
    required this.value,
    required this.Pledge,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OurCheckboxPledge> createState() => _OurCheckboxPledgeState();
}

class _OurCheckboxPledgeState extends State<OurCheckboxPledge> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkbox widget with custom active color and dynamic state management.
        Checkbox(
          activeColor: dark1,
          value: widget.value,
          onChanged: (bool? newValue) {
            // Update the state of the checkbox and trigger the callback.
            setState(() {
              widget.onChanged(newValue ?? false);
            });
          },
        ),

        // Expanded widget to display the pledge text beside the checkbox.
        Expanded(
          child: Dtext(
            t: widget.Pledge,
            color: dark1,
            align: TextAlign.start,
            size: 0.035,
          ),
        ),
      ],
    );
  }
}

/* Example usage of OurListView:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* just you need call OurCheckboxPledge and giv your value , pledge  and onChanged
* EX:
*      OurCheckboxPledge(
                value: _isChecked,
                Pledge: 'I pledge to preserve the furniture and bear the responsibility for any damage.',
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
*/

/// ------------------ Our Status -------------------  //29
// A custom widget that displays a status container for tracking the progress of a request.
Widget OurStatusContainer({
  required String requestStatus, // Current status of the request
  required String title, // Title for the status container
  required List<String> labels, // List of status labels for each step
}) {
  // Function to generate information for each status step.
  // It returns a list of maps with step number, label, and active status for each step.
  List<Map<String, dynamic>> getStatusInfo() {
    // Generate a list of steps with indices for each label
    final steps = List.generate(
        labels.length,
        (stepIndex) => {
              'step': '${stepIndex + 1}', // Step number as a string
              'label': labels[stepIndex], // Label corresponding to each step
            });

    // Determine the current active step based on the position of requestStatus in labels
    int activeStep = labels.indexOf(requestStatus) + 1;
    if (activeStep == 0)
      activeStep = 1; // Default to step 1 if status is not found

    // Return list of steps with active status set based on current activeStep
    return steps.map((step) {
      return {
        'step': step['step'],
        'label': step['label'],
        'isActive': int.parse(step['step'] as String) <=
            activeStep, // Mark step as active or inactive
      };
    }).toList();
  }

  // Function to build the UI for each status step, including a circle indicator and label.
  Widget buildStatusStep(String number, String label, bool isActive) {
    return Column(
      children: [
        // Circle to show the step number, with color depending on active status
        CircleAvatar(
          radius: 16,
          backgroundColor:
              isActive ? green1 : grey1, // Green if active, grey otherwise
          child: text(
            t: number, // Display step number
            color: Colors.white, // Step number text color
            align: TextAlign.center,
          ),
        ),
        Heightsizedbox(h: 0.003), // Small spacer between circle and label
        Dtext(
          t: label, // Display step label
          color: isActive
              ? Colors.black
              : grey1, // Text color depends on active status
          align: TextAlign.center,
          size: 0.03,
        ),
      ],
    );
  }

  // Generate the status information for each step
  final statusInfo = getStatusInfo();

  // Main widget layout, wrapped in a container with rounded corners
  return OurContainer(
    borderRadius: 20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the title of the status container
        text(
          t: '$title',
          color: light1,
          align: TextAlign.start,
        ),
        Heightsizedbox(h: 0.01), // Spacer below the title

        // Show rejection message if requestStatus is "Reject"
        if (requestStatus == 'Reject')
          Center(
            child: Dtext(
              t: "The request is rejected", // Rejection message
              color: red1, // Red color for rejection
              align: TextAlign.center,
              size: 0.045,
            ),
          )
        else
          // Otherwise, display the step progress as a row of status steps
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: statusInfo.map((info) {
                return buildStatusStep(
                  info['step'], // Step number
                  info['label'], // Step label
                  info['isActive'], // Whether the step is active
                );
              }).toList(),
            ),
          ),
      ],
    ),
  );
}

/* Example usage of OurListView:
* first don`t forget the imports: import 'package:pnustudenthousing/Design.dart';
* just you need call OurStatusContainer and giv your Status filed , title and labels
* EX:
*       OurStatusContainer(
              requestStatus: furnitureStatus, // Current status of the request (e.g., "Pending", "Accept", "Reject", "Execute")
              title: '${index + 1} - $FurnitureType $Service', // Title to display in the container
              labels: ['Pending', 'Accept', 'Execute'], // List of statuses in order
            ),
*/




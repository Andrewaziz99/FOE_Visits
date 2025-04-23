import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visits/modules/Visits/visits_screen.dart';
import 'constants.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

Widget myDivider({
  Color color = Colors.amber,
}) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: color,
      ),
    );

Widget myVerticalDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Container(
        width: 1.0,
        color: Colors.amberAccent,
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.white,
  bool isUpperCase = true,
  bool isClicked = false,
  double radius = 0.0,
  double? fSize,
  Color tColor = Colors.black,
  required Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isClicked? background : Colors.amberAccent,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: background,
        elevation: 0.8,
        hoverColor: Colors.amberAccent,
        hoverElevation: 0.8,
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: tColor, fontSize: fSize),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? onTap,
  Color labelColor = Colors.white60,
  Color textColor = Colors.white,
  Color prefixColor = Colors.white,
  Color suffixColor = Colors.white,
  double labelSize = 20,
  double textSize = 20,
  bool isPassword = false,
  IconData? prefix,
  IconData? suffix,
  bool isClickable = true,
  BorderRadius radius = BorderRadius.zero,
  TextDirection textDirection = TextDirection.ltr,
  int? maxLength,
}) =>
    TextFormField(
      maxLength: maxLength,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: TextStyle(
        color: textColor,
        fontSize: textSize
      ),
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.greenAccent,
          ),
        ),
        alignLabelWithHint: true,
        label: Text(label, textDirection: textDirection, textAlign: TextAlign.right, style: TextStyle(fontSize: labelSize)),
        labelStyle: TextStyle(
          color: labelColor,
        ),
        prefixIcon: Icon(prefix, color: prefixColor),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix, color: suffixColor),
              )
            : null,
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: Colors.black)),
      ),
    );

Widget defaultArabicFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? onTap,
  Color labelColor = Colors.white60,
  Color textColor = Colors.white,
  double labelSize = 20,
  double textSize = 20,
  bool isPassword = false,
  IconData? prefix,
  IconData? suffix,
  bool isClickable = true,
  BorderRadius radius = BorderRadius.zero,
  TextDirection textDirection = TextDirection.ltr,
}) =>
    TextFormField(
      inputFormatters: [ArabicNumbersInputFormatter()],
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: TextStyle(
        color: textColor,
        fontSize: textSize
      ),
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.greenAccent,
          ),
        ),
        alignLabelWithHint: true,
        label: Text(label, textDirection: textDirection, textAlign: TextAlign.right, style: TextStyle(fontSize: labelSize)),
        labelStyle: TextStyle(
          color: labelColor,
        ),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(borderRadius: radius),
      ),
    );

Widget newFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? prefixPressed,
  Function()? onTap,
  bool isPassword = false,
  IconData? prefix,
  IconData? suffix,
  bool isClickable = true,
  Color labelColor = Colors.black,
  Color textColor = Colors.black,
  Color prefixColor = Colors.white,
  BorderRadius radius = BorderRadius.zero,
  int? maxLines,
  TextDirection textDirection = TextDirection.ltr,
  TextAlign textAlign = TextAlign.left,
}) =>
    TextFormField(
      inputFormatters: [ArabicNumbersInputFormatter()],
      scrollPhysics: const BouncingScrollPhysics(),
      maxLines: maxLines,
      textDirection: textDirection,
      textAlign: textAlign,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
        ),
        // prefixIcon: Icon(prefix, color: prefixColor),
        prefixIcon: IconButton(onPressed: prefixPressed, icon: Icon(prefix, color: prefixColor)),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
      ),
    );

Future showLoadingDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(loading),
          ],
        ),
      ),
    );



class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu(
      {super.key,
        required this.title,
        required this.controller,
        required this.screenWidth,
        required this.screenRatio,
        required this.entries,
        required this.onSelected,
        this.textColor = Colors.black,
        this.titleColor = Colors.black,
        this.textSize = 20,
        this.titleSize = 20,
        this.space = 10,
      });

  final String title;
  final Color textColor;
  final Color titleColor;
  final double textSize;
  final double titleSize;
  final TextEditingController controller;
  final double screenWidth;
  final double screenRatio;
  final List<DropdownMenuEntry> entries;
  // ignore: prefer_typing_uninitialized_variables
  final onSelected;
  final double space;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(margin: const EdgeInsets.all(5), child: Text(title, style: TextStyle(fontSize: titleSize, color: titleColor))),
        SizedBox(
          height: space,
        ),
        SizedBox(
          width: max(screenWidth * screenRatio, 300),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: DropdownMenu(
                textStyle: TextStyle(fontSize: textSize, fontFamily: "Cairo", color: textColor),
                requestFocusOnTap: true,
                controller: controller,
                menuHeight: 200,
                enableFilter: true,
                onSelected: onSelected,
                width: screenWidth * screenRatio - 2 * 10,
                dropdownMenuEntries: entries,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

// No internet connection Alert dialog

Future<void> showNoInternetDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection and try again.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget NotificationDialog(context, String title) => AlertDialog(
      title: Text(title),
      content: const Text(notificationMsg),
      actions: <Widget>[
        TextButton(
          child: const Text(back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(width: 10.0,),
        TextButton(
          child: const Text(view),
          onPressed: () {
            navigateTo(context, VisitsScreen());
          },
        ),
      ],
    );
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
var defaultColor = Colors.blue;
Widget TextFieldComponent({
  required TextEditingController controller,
  TextInputType? keyType,
  required String label,
  Icon? picon,
  bool autoFocus = false,
  onTap,
  //required onChanged,
  TextStyle? labelStyle,
  validator,
  onChanged,
  IconButton? sicon,
  bool isPassword = false,
  //onSubmit,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyType,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      autofocus: autoFocus,
      //onChanged: onChanged,
      //onFieldSubmitted: onSubmit,
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        //label: label,
        labelStyle: labelStyle,
        focusColor: defaultColor,
        hoverColor: defaultColor,
        prefixIcon: picon,
        suffixIcon: sicon != null ? sicon : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: defaultColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: defaultColor,
            width: 2.0,
          ),
        ),
      ),
    );
Widget defaultButton({
  required String text,
  required onpressed,
  double? width_,
}) =>
    Container(
      width: width_ != null ? width_ : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: defaultColor,
      ),
      child: MaterialButton(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          ),
        ),
        onPressed: onpressed,
      ),
    );
Widget defaultTextButton({
  required color,
  required String text,
  required onpressed,
  double? textFontSize,
}) =>
    TextButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: textFontSize!=null ? textFontSize : 14,
          fontFamily:
              'assets/fonts/IBMPlexArabic/IBMPlexSansArabic-SemiBold.ttf',
        ),
      ),
    );



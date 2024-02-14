import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  // final String labelText;
  // final String hintText;
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final Color? cursorColors;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool autofocus;
  // final bool autocorrect;

  const MyCustomTextField({
    Key? key,
    required this.textInputAction,
    required this.controller,
    required this.decoration,
    this.cursorColors,
    // required this.labelText,
    // required this.hintText,
    this.obscureText = false,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.autofocus = false,
    required this.keyboardType,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: cursorColors,
      controller: controller,
      decoration: decoration,

      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: 50,
      maxLines: 1,
      obscureText: false, // Set to true for password input
      autocorrect: true,
      enableSuggestions: true,
      autofocus: false,
    );
  }
}

import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final Function onPress;
  const SecondaryButton(
      {super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.blue),
        ));
  }
}

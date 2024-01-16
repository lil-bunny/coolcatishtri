import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String labelText;
  final String hintText;
  // final String value = "";
  // final Function func;
  const CustomText(this.labelText, this.hintText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) {
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            filled: true,
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }
}

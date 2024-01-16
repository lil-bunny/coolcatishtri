import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;

  CustomTextWidget({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Toast extends StatelessWidget {
  // const Toast({super.key});
  final String ToastText;
  const Toast(this.ToastText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: Text(
        ToastText,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
    );
  }
}

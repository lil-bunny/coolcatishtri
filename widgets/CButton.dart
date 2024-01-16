import 'package:ishtri_db/services/global.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Function buttonAction;
  final double btnWidth;
  final Color bgColor;
  final Color textColor;
  const ActionButton(this.title, this.buttonAction, this.btnWidth, this.bgColor,
      this.textColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: 40,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      child: TextButton(
        onPressed: () => {buttonAction()},
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

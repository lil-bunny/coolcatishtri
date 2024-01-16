import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextQuestion extends StatefulWidget {
  final String? questionText;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? size;
  final String? star;
  final Color? starColor;
  const TextQuestion(this.questionText, this.fontWeight, this.size, this.star,
      this.starColor, this.textColor,
      {super.key});

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  var primaryColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: widget.questionText,
              style: TextStyle(
                color: widget.textColor,
                fontWeight: widget.fontWeight,
                fontSize: widget.size,
              ),
            ),
            TextSpan(
              text: widget.star,
              style: TextStyle(
                color: widget.starColor,
                fontWeight: widget.fontWeight,
                fontSize: widget.size,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

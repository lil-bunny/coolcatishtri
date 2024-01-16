import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextInputField extends StatefulWidget {
  final TextInputType? textInputType;
  final String? hintText;
  final Widget? prefixIcon;
  final String? defaultText;
  final FocusNode? focusNode;
  final bool? obscureText;
  final TextEditingController? controller;
  final Function? functionValidate;
  final String? parametersValidate;
  final TextInputAction? actionKeyboard;
  final Function? onSubmitField;
  final int? maxLen;
  final Function? onFieldTap;
  final Color? color;

  const TextInputField(
      {this.hintText,
      this.focusNode,
      this.textInputType,
      this.defaultText,
      this.obscureText = false,
      this.controller,
      this.functionValidate,
      this.maxLen,
      this.parametersValidate,
      this.actionKeyboard = TextInputAction.next,
      this.onSubmitField,
      this.onFieldTap,
      this.prefixIcon,
      this.color});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  var primaryColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
      ),
      child: TextFormField(
        cursorColor: primaryColor,
        obscureText: widget.obscureText!,
        keyboardType: widget.textInputType,
        textInputAction: widget.actionKeyboard,
        // focusNode: widget.focusNode,
        maxLength: widget.maxLen,
        style: TextStyle(
          color: widget.color,
          fontSize: 16.0,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.2,
        ),
        initialValue: widget.defaultText,
        decoration: InputDecoration(
          // prefixIcon: widget.prefixIcon,
          suffixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            // letterSpacing: 1.2,
          ),
          contentPadding:
              const EdgeInsets.only(top: 12, left: 0.0, right: 8.0, bottom: 17),
          isDense: true,
          errorStyle: const TextStyle(
            // color: colorRed,
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}

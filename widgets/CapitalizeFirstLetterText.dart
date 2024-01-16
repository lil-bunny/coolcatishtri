import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class CapitalizeFirstLetterTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String capText = '';
    String temp = '';
    List<dynamic> words = newValue.text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
        capText = words[i][0].toUpperCase() + words[i].substring(1);
      }
      temp = temp + capText;
    }
    log('@@@ ${capText}');

    if (newValue.text.isNotEmpty) {
      return TextEditingValue(
        text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}

import 'package:flutter/services.dart';

class SinglePeriodInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if ('.'.allMatches(newText).length <= 1) {
      return newValue;
    }

    return oldValue;
  }
}

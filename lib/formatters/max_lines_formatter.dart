import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MaxLinesTextInputFormatter extends TextInputFormatter {
  final int maxLines;
  final VoidCallback onLinesExceeded;

  MaxLinesTextInputFormatter(this.maxLines, this.onLinesExceeded);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newLineCount = '\n'.allMatches(newValue.text).length + 1;

    if(newLineCount > maxLines) {
      if(onLinesExceeded != null) {
        onLinesExceeded();
      }

      return oldValue;
    }

    return newValue;
  }
}
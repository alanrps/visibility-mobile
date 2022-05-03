import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MaxLengthPerLineFormatter extends TextInputFormatter {
  final int maxLength;
  final VoidCallback onMaxLengthExceeded;

  MaxLengthPerLineFormatter(this.maxLength, this.onMaxLengthExceeded);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final texts = newValue.text.split('\n');
    final maxLengthExceeded = texts.any((text) => text.length > maxLength);


    if(maxLengthExceeded) {
      if(onMaxLengthExceeded != null) {
        onMaxLengthExceeded();
      }

      return oldValue;
    }

    return newValue;
  }
}
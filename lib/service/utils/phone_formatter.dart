import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Yalnızca rakamları al
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format (5XX-XXX-XXXX) olacak şekilde dönüştür
    if (newText.length > 3 && newText.length <= 6) {
      newText = '${newText.substring(0, 3)}-${newText.substring(3)}';
    } else if (newText.length > 6) {
      newText = '${newText.substring(0, 3)}-${newText.substring(3, 6)}-${newText.substring(6, 10)}';
    }

    // Yeni metni geri döndür
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

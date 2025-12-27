import 'package:flutter/material.dart' show FormFieldValidator;

import '../../core.dart';

FormFieldValidator<String> iranianNationalCodeValidator() => (final String? value) {
  if (value == null || value.isEmpty) {
    return s.requiredField;
  }

  final code = value.trim();

  // فقط عدد و دقیقاً ۱۰ رقم
  if (!RegExp(r'^\d{10}$').hasMatch(code)) {
    return s.nationalIdIsShort;
  }

  // رد کردن کدهای تکراری مثل 1111111111
  final invalidCodes = [
    '0000000000',
    '1111111111',
    '2222222222',
    '3333333333',
    '4444444444',
    '5555555555',
    '6666666666',
    '7777777777',
    '8888888888',
    '9999999999',
  ];
  if (invalidCodes.contains(code)) {
    return s.invalidNationalId;
  }

  final digits = code.split('').map(int.parse).toList();

  final checkDigit = digits[9];
  int sum = 0;

  for (int i = 0; i < 9; i++) {
    sum += digits[i] * (10 - i);
  }

  final remainder = sum % 11;

  final isValid = remainder < 2 ? checkDigit == remainder : checkDigit == 11 - remainder;

  if (!isValid) {
    return s.invalidNationalId;
  }

  return null; // ✅ معتبر
};

import 'dart:ui';

import '../core.dart';

TextDirection getDirection(final String v) {
  final String string = v.trim().replaceAll('0', '').replaceAll('1', '').replaceAll('2', '')
      .replaceAll('3', '').replaceAll('4', '').replaceAll('5', '').replaceAll('6', '').replaceAll('7', '').replaceAll('8', '')
      .replaceAll('9', '')
      .replaceAll(',', '')
      .replaceAll(')', '')
      .replaceAll('(!)', '')
      .replaceAll('!', '')
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('_', '')
      .replaceAll('#', '')
      .replaceAll('@', '')
      .replaceAll('*', '')
      .replaceAll('\n', '')
      .replaceAll('.', '').trim();
  const String param = 'ض ص ث ق ف غ ع ه خ ح ج چ پ ش س ی ب ل ا ت ن م ک گ ظ ط ز ر ذ د ئ و';
  if (string.isEmpty) {
    return isPersianLang?TextDirection.rtl : TextDirection.ltr;
  } else {
    final String f=string.length>2?string[2]:string[0];
    if (param.split(' ').contains(f)) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }
}
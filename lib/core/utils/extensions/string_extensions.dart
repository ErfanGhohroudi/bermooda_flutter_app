extension StringExtensions<T> on String {
  /// Splits the string into groups of 4 characters from the left,
  /// separated by a single space.
  ///
  /// Example:
  /// ```dart
  /// print("123456789012".groupedBy4); // "1234 5678 9012"
  /// print("98765".groupedBy4);       // "9876 5"
  /// ```
  String get groupedBy4 {
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(this[i]);
    }
    return buffer.toString();
  }
}
import 'package:u/utilities.dart';

extension FileSizeExtentions<T> on File {
  /// Example:
  /// ```dart
  /// final fileSizeInMB = await file.convertSizeFromByteToMB;
  /// ```
  Future<double> get convertSizeFromByteToMB async {
    final inByte = await length() / (1024 * 1024);
    final inMB = inByte / (1024 * 1024);
    return inMB;
  }
}

extension PlatformFileSizeExtentions<T> on PlatformFile {
  /// Example:
  /// ```dart
  /// final fileSizeInMB = platformFile.convertSizeFromByteToMB;
  /// ```
  double get convertSizeFromByteToMB {
    final inByte = size / (1024 * 1024);
    final inMB = inByte / (1024 * 1024);
    return inMB;
  }
}

extension XFileSizeExtentions<T> on XFile {
  /// Example:
  /// ```dart
  /// final fileSizeInMB = await xFile.convertSizeFromByteToMB;
  /// ```
  Future<double> get convertSizeFromByteToMB async {
    final inByte = await length() / (1024 * 1024);
    final inMB = inByte / (1024 * 1024);
    return inMB;
  }
}

extension FileSizeDoubleExtentions<T> on num {
  /// Example:
  /// ```dart
  /// final fileSizeInMB = 125564668.convertSizeFromMBToByte;
  /// ```
  double get convertSizeFromMBToByte {
    final inByte = this * (1024 * 1024);
    return inByte.toDouble();
  }

  /// Example:
  /// ```dart
  /// final fileSizeInMB = 125564668.convertSizeFromByteToMB;
  /// ```
  double get convertSizeFromByteToMB {
    final inMB = this / (1024 * 1024);
    return inMB;
  }
}

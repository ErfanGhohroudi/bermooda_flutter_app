import 'package:dio/dio.dart';
import 'package:u/utilities.dart';

import '../core.dart';
import '../navigator/navigator.dart';

class OpenFileHelpers {
  static Future<String?> getFilePath(final String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return "${dir.path}/$fileName";
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isExist(final String fileName) async {
    final filePath = await getFilePath(fileName);
    if (filePath == null) return false;
    final file = File(filePath);

    if (await file.exists()) {
      return true; // اگر فایل موجود بود مستقیماً باز شود
    }
    return false;
  }

  /// get Directory path and search fileName.
  /// if could not found directory path return null and show error snackbar.
  /// if file exist; return local file path.
  /// else download file then return local file path
  static Future<String?> showDownloadDialog(final String url, final String fileName) async {
    final filePath = await getFilePath(fileName);
    if (filePath == null) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.directoryCouldNotBeFound);
      return null;
    }
    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    final result = await showDialog<String?>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // جلوگیری از بسته شدن دیالوگ هنگام لمس بیرون
      builder: (final context) {
        Rx<double> progress = 0.0.obs;

        return StatefulBuilder(
          builder: (final context, final setState) {
            downloadFile(
              url: url,
              fileName: fileName,
              onProgress: (final value) {
                progress(value); // به‌روزرسانی progress با استفاده از setState
              },
            ).then((final filePath) {
              delay(
                1000,
                () {
                  Navigator.pop(context, filePath);
                },
              );
            }).catchError((final error) {
              Navigator.pop(context);
              AppNavigator.snackbarRed(title: s.error, subtitle: error.toString());
            });

            return AlertDialog(
              title: Text(s.downloading).bodyMedium(),
              backgroundColor: navigatorKey.currentContext!.theme.cardColor,
              content: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: progress.value / 100,
                      color: navigatorKey.currentContext!.theme.primaryColor,
                      backgroundColor: navigatorKey.currentContext!.theme.scaffoldBackgroundColor,
                    ),
                    const SizedBox(height: 10),
                    Text("${progress.value.toStringAsFixed(1)}%").bodyMedium(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return result;
  }

  static Future<String?> downloadFile({
    required final String url,
    required final String fileName,
    required final Function(double progress) onProgress,
  }) async {
    final filePath = await getFilePath(fileName);
    if (filePath == null) return null;
    final file = File(filePath);

    if (await file.exists()) {
      return filePath; // اگر فایل موجود بود مستقیماً باز شود
    }

    try {
      final Dio dio = Dio();

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (final received, final total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            onProgress(progress);
          }
        },
      );
      return filePath;
    } on DioException catch (e) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.errorDownloadingFile);
      debugPrint("Download error: $e");
      return null;
    }
  }

  static Future<int> cleanupOldFiles({
    final Duration? olderThan,
    final int? maxSizeInMB,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir.listSync().whereType<File>().toList();

      int deletedCount = 0;
      int totalSize = 0;
      final cutoffDate = DateTime.now().subtract(olderThan ?? const Duration(days: 30));
      final maxSizeInBytes = (maxSizeInMB ?? 500) * 1024 * 1024;

      // محاسبه حجم کل فایل‌ها
      for (final file in files) {
        totalSize += await file.length();
      }

      // اگر حجم بیشتر از حد مجاز بود یا فایل قدیمی است، پاک کن
      if (totalSize > maxSizeInBytes || olderThan != null) {
        // مرتب‌سازی بر اساس تاریخ آخرین تغییر
        files.sort((final a, final b) {
          final statA = a.statSync();
          final statB = b.statSync();
          return statA.modified.compareTo(statB.modified);
        });

        for (final file in files) {
          final stat = file.statSync();
          final shouldDelete = (olderThan != null && stat.modified.isBefore(cutoffDate)) || (maxSizeInMB != null && totalSize > maxSizeInBytes);

          if (shouldDelete) {
            try {
              totalSize -= await file.length();
              await file.delete();
              deletedCount++;
            } catch (e) {
              debugPrint("Error deleting file ${file.path}: $e");
            }
          }

          // اگر حجم به حد مجاز رسید، متوقف کن
          if (maxSizeInMB != null && totalSize <= maxSizeInBytes) break;
        }
      }

      return deletedCount;
    } catch (e) {
      debugPrint("Cleanup error: $e");
      return 0;
    }
  }

  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir.listSync().whereType<File>().toList();

      int totalSize = 0;
      int fileCount = files.length;
      DateTime? oldestFile;
      DateTime? newestFile;

      for (final file in files) {
        final size = await file.length();
        totalSize += size;
        final stat = file.statSync();

        if (oldestFile == null || stat.modified.isBefore(oldestFile)) {
          oldestFile = stat.modified;
        }
        if (newestFile == null || stat.modified.isAfter(newestFile)) {
          newestFile = stat.modified;
        }
      }

      return {
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'fileCount': fileCount,
        'oldestFile': oldestFile,
        'newestFile': newestFile,
      };
    } catch (e) {
      debugPrint("Error getting storage info: $e");
      return {'totalSize': 0, 'totalSizeMB': '0', 'fileCount': 0};
    }
  }
}

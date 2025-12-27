part of '../data.dart';

class UploadCustomerExelDatasource {
  final ApiClient _apiClient = Get.find();
  dio.CancelToken? _cancelToken;

  Future<void> uploadFile({
    required final PlatformFile file,
    required final String categoryId,
    required final Function(double progress) onProgress,
    required final Function(ExelUploadResultReadDto result) onFileUploaded,
    required final Function(PlatformFile file, dio.Response? response) onError,
    final Function()? onCancel,
  }) async {
    _cancelToken = dio.CancelToken();

    try {
      // ساخت FormData برای آپلود
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(file.path ?? '', filename: file.name),
        'group_crm_id': categoryId,
      });

      // آپلود فایل با استفاده از ApiClient
      final response = await _apiClient.uploadFile<Map<String, dynamic>>(
        '/v1/CrmManager/import/upload-analyze/',
        formData,
        skipRetry: true,
        onSendProgress: (final sent, final total) {
          final progress = sent / total;
          onProgress(progress);
        },
        cancelToken: _cancelToken,
      );

      // بررسی موفقیت آمیز بودن response
      if (response.isOk) {
        onFileUploaded(ExelUploadResultReadDto.fromMap(response.data?['data']));
      } else {
        onError(file, response);
      }
    } on dio.DioException catch (e) {
      if (dio.CancelToken.isCancel(e)) {
        debugPrint("Upload cancelled");
        if (onCancel != null) onCancel();
      } else {
        onError(file, e.response);
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      onError(file, null);
    }
  }

  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("Upload cancelled by user.");
      _cancelToken = null;
    }
  }
}

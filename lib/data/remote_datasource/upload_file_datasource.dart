part of '../data.dart';

class UploadFileDatasource {
  final ApiClient _apiClient = Get.find();
  final core = Get.find<Core>();

  dio.CancelToken _cancelToken = dio.CancelToken();

  Future<void> uploadFile({
    required final MainFileReadDto file,
    final bool isSignUpAvatar = false,
    final dio.CancelToken? cancelToken,
    required final Function(double progress) onProgress,
    required final Function(MainFileReadDto file) onFileUploaded,
    required final Function(MainFileReadDto file, dio.Response? response) onError,
    final Function()? onCancel,
  }) async {
    dio.Response? response;

    try {
      // آپلود فایل و بروزرسانی پیشرفت
      response = await _upload(
        file: file,
        isSignUpAvatar: isSignUpAvatar,
        cancelToken: cancelToken,
        onProgress: onProgress,
      );

      if (response.isOk) {
        onFileUploaded(MainFileReadDto.fromMap(response.data['data']));
      }
    } on dio.DioException catch (e) {
      if (dio.CancelToken.isCancel(e)) {
        debugPrint("Upload cancelled");
        onCancel?.call(); // 👈 فراخوانی کال‌بک لغو
      } else {
        debugPrint("Upload error => $e");
        onError(file, response);
      }
    } catch (e2) {
      debugPrint("Upload error => $e2");
      onError(file, response);
    }
  }

  Future<dio.Response> _upload({
    required final MainFileReadDto file,
    final bool isSignUpAvatar = false,
    final dio.CancelToken? cancelToken,
    required final Function(double progress) onProgress,
  }) async {
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.url ?? '', filename: file.originalName),
    });

    final urlPath = isSignUpAvatar ? "/v1/Core/UploadProfileImage" : "/v1/Core/UploadFile";

    return await _apiClient.uploadFile(
      urlPath,
      formData,
      cancelToken: cancelToken ?? _cancelToken,
      skipRetry: true,
      onSendProgress: (final sent, final total) {
        final progress = sent / total;
        onProgress(progress);
      },
    );
  }

  void cancelUpload() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel("Upload cancelled by user.");
      _cancelToken = dio.CancelToken();
    }
  }
}

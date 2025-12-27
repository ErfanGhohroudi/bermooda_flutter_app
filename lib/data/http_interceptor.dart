// part of 'data.dart';
//
// Future<void> httpRequest({
//   required final String url,
//   required final EHttpMethod httpMethod,
//   required final Function(Response<dynamic> response) action,
//   required final Function(Response<dynamic> response) error,
//   required final VoidCallback? retryCallback,
//   final dynamic body,
//   final String? contentType,
//   final Function(double percent)? uploadProgress,
//   final bool encodeBody = true,
//   final bool clearHeader = false,
//   final Map<String, String>? headers,
//   final bool withLoading = true,
//   final Duration timeout = const Duration(seconds: 20),
//   final DateTime? cacheExpireDate,
// }) async {
//   Response<dynamic> response = const Response<dynamic>();
//   try {
//     if (withLoading) {
//       AppLoading.showLoading();
//     }
//
//     final Map<String, String> header = <String, String>{
//       "Authorization": await SecureStorageService.getAccessToken() ?? "",
//     };
//
//     if (headers != null) {
//       // header.clear();
//       header.addAll(headers);
//     }
//
//     if (clearHeader) {
//       header.clear();
//     }
//
//     dynamic params;
//     if (body != null) {
//       if (encodeBody) {
//         params = body.toJson();
//       } else {
//         params = body;
//       }
//     }
//
//     final GetConnect connect = GetConnect(timeout: timeout);
//
//     if (httpMethod == EHttpMethod.get) {
//       if (cacheExpireDate != null) {
//         if (ULocalStorage.getString(url).isNullOrEmpty()) {
//           response = await connect.get(url, headers: header);
//           ULocalStorage.set(url, response.bodyString);
//           ULocalStorage.set("${url}___ExpireDate", cacheExpireDate.toIso8601String());
//         } else {
//           if (DateTime.parse(ULocalStorage.getString("${url}___ExpireDate")!).isBefore(DateTime.now())) {
//             ULocalStorage.set(url, null);
//             ULocalStorage.set("${url}___ExpireDate", null);
//             await httpRequest(
//               url: url,
//               httpMethod: EHttpMethod.get,
//               action: action,
//               error: error,
//               retryCallback: retryCallback,
//               headers: headers,
//               timeout: timeout,
//               cacheExpireDate: cacheExpireDate,
//             );
//           } else {
//             action(Response<dynamic>(statusCode: 200, bodyString: ULocalStorage.getString(url)));
//             return;
//           }
//         }
//       } else {
//         response = await connect.get(url, headers: header);
//       }
//     }
//     if (httpMethod == EHttpMethod.post) response = await connect.post(url, params, headers: header, contentType: contentType, uploadProgress: uploadProgress);
//     if (httpMethod == EHttpMethod.put) response = await connect.put(url, params, headers: header, contentType: contentType, uploadProgress: uploadProgress);
//     if (httpMethod == EHttpMethod.patch) response = await connect.patch(url, params, headers: header);
//     if (httpMethod == EHttpMethod.delete && params == null) response = await connect.delete(url, headers: header);
//
//     /// for Bulk Delete
//     if (httpMethod == EHttpMethod.delete && params != null) response = await connect.request(url, 'DELETE', body: params, headers: header);
//
//     if (kDebugMode) {
//       response.prettyLog(
//           params: body == null
//               ? ""
//               : encodeBody
//                   ? body.toJson()
//                   : body.toString());
//     }
//
//     /// For when you want to call something for a response's message
//     if (!clearHeader) {
//       if (response.body != null && response.unauthorized) {
//         if (url != "${AppConstants.baseUrl}/api/token/refresh/" && url != "${AppConstants.baseUrl}/v1/UserManager/LoginUser") {
//           final status = await Get.find<AccessTokenDatasource>().buildNewToken();
//
//           if (status == true) {
//             bool hasNetworkConnection = await UNetwork.hasNetworkConnection();
//             if (hasNetworkConnection) {
//               return await httpRequest(
//                 url: url,
//                 httpMethod: httpMethod,
//                 action: action,
//                 error: error,
//                 body: body,
//                 timeout: timeout,
//                 retryCallback: retryCallback,
//                 withLoading: withLoading,
//                 cacheExpireDate: cacheExpireDate,
//                 headers: headers,
//                 encodeBody: encodeBody,
//               );
//             } else {
//               return;
//             }
//           } else {
//             logout();
//             return;
//           }
//         }
//       }
//     }
//
//     if (response.isOk && response.statusCode != null) {
//       action(response);
//     } else {
//       if (response.statusCode == 400 || response.statusCode == 200) {
//         AppNavigator.snackbarRed(title: s.error, subtitle: response.body["message"].toString());
//       }
//       if (retryCallback != null && !(response.statusCode == 400 || response.statusCode == 200)) {
//         RetryDialogService().show(context: navigatorKey.currentContext!, retryCallback: retryCallback, isTimeOut: response.status.connectionError, response: response);
//       }
//       error(response);
//     }
//   } catch (e, stackTrace) {
//     AppLoading.dismissLoading();
//     error(response);
//
//     if (response.statusCode == null) {
//       if (retryCallback != null) {
//         RetryDialogService().show(context: navigatorKey.currentContext!, retryCallback: retryCallback, isTimeOut: true, response: response);
//       }
//     } else {
//       if (retryCallback != null) {
//         RetryDialogService().show(context: navigatorKey.currentContext!, retryCallback: retryCallback, response: response);
//       }
//
//       // ثبت خطا در کنسول firebase
//       if (response.isServerError() || response.statusCode == 200) {
//         FirebaseCrashlytics.instance.recordError(
//           e,
//           stackTrace,
//           reason: 'خطا در API',
//         );
//       }
//     }
//   }
//   AppLoading.dismissLoading();
// }
//
// enum EHttpMethod { get, post, put, patch, delete }
//
// extension HTTP on Response<dynamic> {
//   bool isSuccessful() => (statusCode ?? 0) >= 200 && (statusCode ?? 0) <= 299 ? true : false;
//
//   bool isServerError() => (statusCode ?? 0) >= 500 && (statusCode ?? 0) <= 599 ? true : false;
//
//   void prettyLog({final String params = ""}) {
//     developer.log(
//       "${request?.method} - ${request?.url} - $statusCode \nPARAMS: $params \nHEADERS: ${request?.headers} \nRESPONSE: $body",
//     );
//   }
// }

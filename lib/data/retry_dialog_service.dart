import 'package:bermooda_business/data/api_client.dart';
import 'package:u/utilities.dart';
import 'package:dio/dio.dart' as dio;

import '../core/widgets/widgets.dart';
import '../core/core.dart';
import '../core/theme.dart';

class RetryDialogService {
  static final RetryDialogService _instance = RetryDialogService._internal();

  factory RetryDialogService() => _instance;

  RetryDialogService._internal();

  bool _isDialogShowing = false;

  void show({
    required final VoidCallback retryCallback,
    final bool isTimeOut = false,
    final bool barrierDismissible = true,
    final dio.Response<dynamic>? response,
  }) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;

      String getTitleText({required final dio.Response<dynamic> response}) {
        String title = "";
        switch (response.statusCode) {
          case 400:
            title = s.error400;
            break;
          case 404:
            title = s.error404;
            break;
          case 422:
            title = s.error422;
            break;
          case 500:
            title = s.error500;
            break;
          default:
            title = s.errorNetConnection;
            break;
        }
        if (response.isServerError) title = s.error500;
        return title;
      }

      showAppDialog(
        useSafeArea: true,
        barrierDismissible: barrierDismissible,
        PopScope(
          canPop: barrierDismissible,
          child: Builder(
            builder: (final context) {
              return AlertDialog(
                title: Center(
                  child: Column(
                    children: [
                      const UImage(AppLottie.error, size: 100),
                      if (isTimeOut)
                        Text(
                          s.errorNetConnection,
                          textAlign: TextAlign.center,
                        ).titleMedium(color: context.theme.hintColor)
                      else
                        Text(
                          getTitleText(response: response ?? dio.Response(requestOptions: dio.RequestOptions())),
                          textAlign: TextAlign.center,
                        ).titleMedium(color: context.theme.hintColor)
                    ],
                  ),
                ),
                actions: <Widget>[
                  Center(
                    child: UElevatedButton(
                      width: 150,
                      titleWidget: Text(s.tryAgain).bodyMedium(color: Colors.white),
                      backgroundColor: Colors.red,
                      onTap: () {
                        Navigator.of(context).pop();
                        retryCallback();
                      },
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ).whenComplete(() {
        _isDialogShowing = false;
      },);
    }
  }
}

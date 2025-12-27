import 'package:u/utilities.dart';

import '../../data/data.dart';
import '../widgets/widgets.dart';
import '../core.dart';
import '../theme.dart';

void checkAppUpdate({required final VoidCallback action}) {
  Get.find<UpdateDatasource>().getAppUpdate(
    onResponse: (final response) {
      final AppUpdateReadDto result = response.result!;
      final int lastVersion = int.tryParse(result.lastVersion ?? '') ?? 100;
      final int appVersion = int.tryParse(UApp.buildNumber) ?? 100;

      if (lastVersion > appVersion) {
        showAppDialog(
          barrierDismissible: false,
          AlertDialog(
            title: SizedBox(
              width: 300,
              child: const UImage(AppImages.logoSplash).marginSymmetric(horizontal: 50),
            ).marginOnly(bottom: 10),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.updateTitle).bodyMedium().bold(),
                  Text(s.updateSubTitle).bodyMedium().marginOnly(bottom: 24),
                  if ((result.cafebazarLink ?? '') != '' || (result.myketLink ?? '') != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if ((result.cafebazarLink ?? '') != '')
                          UImage(
                            isPersianLang ? AppImages.cafebazaarBadgeFa : AppImages.cafebazaarBadgeEn,
                            height: 40,
                          ).onTap(
                            () {
                              ULaunch.launchURL(result.cafebazarLink!, mode: LaunchMode.externalApplication);
                            },
                          ).expanded(),
                        if ((result.cafebazarLink ?? '') != '' && (result.myketLink ?? '') != '') const SizedBox(width: 10),
                        if ((result.myketLink ?? '') != '')
                          UImage(
                            isPersianLang ? AppImages.myketBadgeFa : AppImages.myketBadgeEn,
                            height: 40,
                          ).onTap(
                            () {
                              ULaunch.launchURL(result.myketLink!, mode: LaunchMode.externalApplication);
                            },
                          ).expanded(),
                      ],
                    ).marginOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if ((result.downloadLink ?? '') != '')
                        SizedBox(
                          height: 37,
                          child: UElevatedButton(
                            title: s.directLink,
                            backgroundColor: Colors.black,
                            borderRadius: 4,
                            borderWidth: 1,
                            onTap: () {
                              ULaunch.launchURL(result.downloadLink!, mode: LaunchMode.externalApplication);
                            },
                          ),
                        ).expanded(),
                      if ((result.downloadLink ?? '') != '') const SizedBox(width: 10),
                      SizedBox(
                        height: 37,
                        child: UElevatedButton(
                          title: result.isForce ? s.cancel : s.notNow,
                          backgroundColor: result.isForce ? AppColors.red : navigatorKey.currentContext!.theme.hintColor,
                          borderRadius: 4,
                          onTap: () {
                            if (result.isForce) {
                              UNavigator.back();
                              if (UApp.isAndroid) {
                                exit(1);
                              } else {
                                SystemNavigator.pop();
                              }
                            } else {
                              UNavigator.back();
                              action();
                            }
                          },
                        ),
                      ).expanded(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        action();
      }
    },
  );
}

import 'package:phone_form_field/phone_form_field.dart';
import 'package:u/utilities.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

import '../app_config.dart';
import 'constants.dart';
import 'di/dependency_injection.dart';
import 'services/vpn_listener_service.dart';
import 'theme.dart';
import '../firebase_options.dart';
import '../generated/l10n.dart';
import '../view/modules/rout/rout_controller.dart';
import '../view/modules/splash/splash_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(final RemoteMessage message) async {
  // اگر از پکیج‌های دیگری در اینجا استفاده می‌کنید، باید Firebase را initialize کنید
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");
  UNotification.showLocalNotification(
    message,
    channelId: channelId,
    channelName: channelName,
    icon: notificationIcon,
  );
  // در اینجا می‌توانید منطق مورد نظر خود را برای پیام پس‌زمینه پیاده‌سازی کنید
  // مثلاً ذخیره پیام در دیتابیس محلی یا نمایش یک نوتیفیکیشن محلی
}

class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  factory AppInitializer() => _instance;
  AppInitializer._internal();

  static AppInitializer get instance => _instance;

  Future<void> initializeApp(final Flavor flavor) async {
    // بارگذاری فایل .env
    await dotenv.load(fileName: ".env");
    
    // تنظیم flavor در AppConfig
    AppConfig.instance.setFlavor(flavor);

    await initUtilities(
      channelId: channelId,
      channelName: channelName,
      notificationIcon: notificationIcon,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      easyLoadingPrimaryColor: AppColors.primaryColor,
      easyLoadingIndicatorType: EasyLoadingIndicatorType.ring,
      safeDevice: true,
      onNotificationTap: (final NotificationResponse notificationResponse) {
        dynamic data;
        if (notificationResponse.payload != null) {
          data = jsonDecode(notificationResponse.payload ?? '');
        }
        developer.log("notifLog onNotificationTap notificationResponse.payload => $data");

        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            final type = data?["type"] as String?;
            if (Get.isRegistered<RoutController>()) {
              Get.find<RoutController>().handleNotificationTap(type);
            }
            break;
          case NotificationResponseType.selectedNotificationAction:
            // برای زمانی که نوتیفیکیشن دکمه اکشن داشته باشد

            // if (notificationResponse.actionId == Core.navigationActionId) {
            //   Core.selectNotificationStream.add(notificationResponse.payload);
            // }

            break;
        }
      },
    );

    // await di.init();
    await DependencyInjector.init();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..indicatorSize = 45.0
      ..radius = 10.1
      ..backgroundColor = Colors.white
      ..indicatorColor = AppThemes.lightTheme(locale: defaultLocale).hintColor
      ..textStyle = AppThemes.lightTheme(locale: defaultLocale).textTheme.bodyMedium?.copyWith(color: AppThemes.lightTheme(locale: defaultLocale).hintColor)
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.grey.withValues(alpha: 0.3)
      ..loadingStyle = EasyLoadingStyle.light
      ..userInteractions = false
      ..boxShadow = <BoxShadow>[]
      ..userInteractions = false
      ..dismissOnTap = false;

    runApp(const _ReactiveApp());

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      VpnListenerService().initialize();
    });

    // Dispose services when app is terminated
    // SystemChannels.platform.setMethodCallHandler((final call) async {
    //   if (call.method == 'SystemNavigator.pop') {
    //     VpnListenerService().dispose();
    //     WebSocketService().dispose();
    //   }
    // });
  }
}

class _ReactiveApp extends StatelessWidget {
  const _ReactiveApp();

  @override
  Widget build(final BuildContext context) {
    // Use GetBuilder to rebuild when locale controller updates
    return GetBuilder<LocaleController>(
      init: LocaleController(),
      builder: (final controller) {
        // Get current locale from GetX or fallback to default
        final currentLocale = Get.locale ?? defaultLocale;

        return UMaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            ...PhoneFieldLocalization.delegates,
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          supportedLocales: const <Locale>[Locale("fa"), Locale("en")],
          locale: defaultLocale,
          lightTheme: AppThemes.lightTheme(locale: currentLocale),
          darkTheme: AppThemes.darkTheme(locale: currentLocale),
          home: const SplashPage(),
        );
      },
    );
  }
}

class LocaleController extends GetxController {
  Locale? _lastLocale;

  @override
  void onInit() {
    super.onInit();
    _lastLocale = Get.locale ?? defaultLocale;
    // Periodically check for locale changes (every 200ms)
    _checkLocaleChanges();
  }

  void _checkLocaleChanges() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isClosed) {
        final currentLocale = Get.locale ?? defaultLocale;
        if (_lastLocale != currentLocale) {
          _lastLocale = currentLocale;
          update();
        }
        _checkLocaleChanges();
      }
    });
  }
}


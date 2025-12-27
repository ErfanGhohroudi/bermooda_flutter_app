import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// enum BaseUrlType { main, test, cursor, local }

// GlobalKey برای RoutPage
final GlobalKey<ScaffoldState> routPageScaffoldKey = GlobalKey<ScaffoldState>();
const Locale defaultLocale = Locale("fa");

const String notificationIcon = '@drawable/ic_status_bar_icon';
const String channelId = "bermooda_channel_id";
const String channelName = "Bermooda Channel";

abstract class AppConstants {
  static String get websiteAddress => dotenv.env['WEBSITE_ADDRESS'] ?? "";

  static String get websiteBaseURL => dotenv.env['WEBSITE_BASE_URL'] ?? "";
  static const maxFileSizeLimitInMB = 600;

  /// links ///////////////////////////////////////////////////////////////////////////////////////////////////////
  static String get termsAndConditionsUrl => dotenv.env['TERMS_AND_CONDITIONS_URL'] ?? "";

  static String get supportUrl => dotenv.env['SUPPORT_URL'] ?? "";

  static String get exampleCustomerImportExelUrl => dotenv.env['EXAMPLE_CUSTOMER_IMPORT_EXCEL_URL'] ?? "";

  /// For ULocalStorage key, Example: [ULocalStorage.getString(AppConstants.username)] ////////////////////////////
  static const String username = "username";
  static const String isLogin = "isLogin";
  static const String hasNotSetFcmToken = "hasNotSetFcmToken";
}

import 'package:u/utilities.dart';

import '../../core.dart';
import '../../navigator/navigator.dart';

extension UrlExtentions<T> on String? {
  Future<void> launchMyUrl() async {
    // 1. ورودی را trim کرده و برای خالی بودن بررسی می‌کنیم
    final String? urlToParse = this?.trim();
    if (urlToParse.isNullOrEmpty()) {
      return AppNavigator.snackbarRed(title: s.error, subtitle: s.linkIsEmpty);
    }

    // 2. برای اعتبارسنجی، پروتکل https را به لینک‌هایی که ندارند اضافه می‌کنیم
    String finalUrl = urlToParse!;
    if (!finalUrl.startsWith('http')) {
      finalUrl = 'https://$finalUrl';
    }

    // 3. با tryParse اعتبارسنجی می‌کنیم
    final Uri? uri = Uri.tryParse(finalUrl);

    // 4. بررسی می‌کنیم که آیا uri معتبر است و host (دامنه) دارد یا نه
    if (uri != null && uri.host.isNotEmpty) {
      // اگر معتبر بود، آن را باز می‌کنیم
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        AppNavigator.snackbarRed(title: s.error, subtitle: s.unableOpenLink);
      }
    } else {
      // اگر معتبر نبود، به کاربر خطا نمایش می‌دهیم
      AppNavigator.snackbarRed(title: s.error, subtitle: s.linkFormatIsInvalid);
    }
  }

  /// Checks if the given string is a valid web URL.
  ///
  /// Returns `true` for inputs like:
  /// - "https://google.com"
  /// - "http://www.example.org/path"
  /// - "google.com"
  ///
  /// Returns `false` for inputs like:
  /// - "متن عادی"
  /// - "google"
  /// - "ftp://server.com" (optional, can be enabled)
  bool get isWebUrl {
    if (this == null) {
      return false;
    }

    // Handle empty or null strings first.
    if (this!.isEmpty) {
      return false;
    }

    // Use Uri.tryParse to avoid exceptions on invalid input.
    final Uri? uri = Uri.tryParse(this!);

    // If parsing fails, it's not a URI.
    if (uri == null) {
      return false;
    }

    final bool hostIsOk = uri.host != '' && uri.host.contains(".") && uri.host.split(".").isNotEmpty && uri.host.split(".").last.length >= 2;

    debugPrint("host => ${uri.host}");
    debugPrint("hostIsOk => $hostIsOk");

    // Check if it has a scheme (like http, https) and a host (like google.com).
    // We only consider http and https as valid web schemes.
    if (uri.hasScheme && hostIsOk && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return true;
    }

    // // --- Handling URLs without a scheme (e.g., "google.com") ---
    // // If the original string doesn't have a scheme, try parsing it again
    // // by pretending it's a path. A valid domain name will parse
    // // correctly as a path segment with no scheme.
    // if (!uri.hasScheme && uri.hasAuthority && uri.path.contains('.')) {
    //   // This is a good indicator of something like "example.com".
    //   return true;
    // }

    return false;
  }
}

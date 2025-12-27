import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import 'constants.dart';

abstract class AppColors {
  static const Color primaryColor = Color(0xff516BFC);
  static const Color red = Color(0xffFF1249);
  static const Color yellow = Color(0xffFFFC31);
  static const Color green = Color(0xff41B40D);
  static const Color orange = Color(0xffFF9800);
  static const Color blue = Color(0xff516BFC);

  // static const Color darkBlue = Color(0xff4457e1);
  static const Color purple = Color(0xffa847e8);
  static const Color blueLink = Color(0xff5ABDff);
  static const Color brown = Color(0xffA24C00);
}

abstract class _AppColorsDark {
  static const Color background = Color(0xff22303c);
  static const Color card = Color(0xFF15202b);
  static const Color primaryDark = Color(0xffffffff);
  static const Color shadow = Color(0x38000000);
  static const Color hint = Color(0xff838383);
  static const Color hover = Color(0xff25325c);
  static const Color divider = Color(0xff585e6c);
}

abstract class _AppColorsLight {
  static const Color background = Color(0xfff3f3f3);
  static const Color card = Color(0xffffffff);
  static const Color primaryDark = Color(0xff000000);
  static const Color shadow = Color(0x17000000);
  static const Color hint = Color(0xffa4afbb);
  static const Color hover = Color(0xfffffaf8);
  static const Color divider = Color(0xffdadada);
}

abstract class AppThemes {
  static ThemeData lightTheme({final Locale? locale}) {
    final currentLocale = locale ?? Get.locale ?? defaultLocale;
    final isPersian = currentLocale.languageCode == "fa";

    TextStyle lightBaseTextStyle = const TextStyle(
      color: _AppColorsLight.primaryDark,
      fontWeight: FontWeight.w500,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: isPersian ? UFonts.iranSansFaNum.fontFamily : UFonts.iranSans.fontFamily,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: _AppColorsLight.background,
      cardColor: _AppColorsLight.card,
      primaryColorDark: _AppColorsLight.primaryDark,
      shadowColor: _AppColorsLight.shadow,
      hintColor: _AppColorsLight.hint,
      hoverColor: _AppColorsLight.hover,
      highlightColor: _AppColorsLight.card,
      disabledColor: _AppColorsLight.hint,
      dividerColor: _AppColorsLight.divider,
      secondaryHeaderColor: _AppColorsLight.primaryDark,
      iconTheme: const IconThemeData(color: _AppColorsLight.primaryDark),
      cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primaryColor,
      ),
      tooltipTheme: TooltipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _AppColorsLight.divider,
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: lightBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        showCheckmark: false,
        backgroundColor: _AppColorsLight.card,
        selectedColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: _AppColorsLight.divider),
        ),
        shadowColor: _AppColorsLight.shadow,
        selectedShadowColor: _AppColorsLight.shadow,
        surfaceTintColor: Colors.transparent,
        disabledColor: _AppColorsLight.hint,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: AppColors.primaryColor,
        disabledThumbColor: AppColors.primaryColor.withAlpha(150),
        activeTrackColor: AppColors.primaryColor,
        valueIndicatorColor: AppColors.primaryColor,
        overlayColor: AppColors.primaryColor.withAlpha(50),
        disabledActiveTrackColor: AppColors.primaryColor.withAlpha(150),
        inactiveTrackColor: _AppColorsLight.divider,
        disabledInactiveTrackColor: _AppColorsLight.divider,
        trackShape: _CustomSliderTrackShape(),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _AppColorsLight.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _AppColorsLight.divider),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: _AppColorsLight.shadow,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryColor, // رنگ cursor
        selectionHandleColor: AppColors.primaryColor, // رنگ دستگیره انتخاب متن
      ),
      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll(AppColors.primaryColor),
        thumbColor: WidgetStatePropertyAll(Colors.white),
      ),
      drawerTheme: const DrawerThemeData(
        width: 300,
        backgroundColor: _AppColorsLight.card,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: _AppColorsLight.card,
        shadowColor: _AppColorsLight.shadow,
        barrierColor: Colors.black26,
      ),
      checkboxTheme: const CheckboxThemeData(
        side: BorderSide(color: AppColors.primaryColor, width: 2),
        shape: CircleBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      listTileTheme: ListTileThemeData(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        selectedTileColor: AppColors.primaryColor.withAlpha(20),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(Colors.black12),
        trackColor: WidgetStatePropertyAll(_AppColorsLight.background),
        trackVisibility: WidgetStatePropertyAll(true),
        trackBorderColor: WidgetStatePropertyAll(Colors.transparent),
        radius: Radius.circular(20),
        crossAxisMargin: 3,
        mainAxisMargin: 3,
      ),
      textTheme: TextTheme(
        displayLarge: lightBaseTextStyle.copyWith(fontSize: 26, fontWeight: FontWeight.w500),
        displayMedium: lightBaseTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
        displaySmall: lightBaseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
        headlineLarge: lightBaseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
        headlineMedium: lightBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        headlineSmall: lightBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        titleLarge: lightBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        titleMedium: lightBaseTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
        titleSmall: lightBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        bodyLarge: lightBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        bodyMedium: lightBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        bodySmall: lightBaseTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
        labelLarge: lightBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        labelMedium: lightBaseTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
        labelSmall: lightBaseTextStyle.copyWith(fontSize: 8, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.hardEdge,
        color: _AppColorsLight.card,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: _AppColorsLight.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: _AppColorsLight.shadow, width: 2),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 12, horizontal: 20))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: _AppColorsLight.divider),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 10,
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _AppColorsLight.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _AppColorsLight.hint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
      ),
    );
  }

  static ThemeData darkTheme({Locale? locale}) {
    final currentLocale = locale ?? Get.locale ?? defaultLocale;
    final isPersian = currentLocale.languageCode == "fa";

    TextStyle darkBaseTextStyle = TextStyle(
      color: _AppColorsDark.primaryDark,
      fontWeight: FontWeight.w500,
      fontFamily: isPersian ? UFonts.iranSansFaNum.fontFamily : UFonts.iranSans.fontFamily,
    );

    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: _AppColorsDark.background,
      primaryColorDark: _AppColorsDark.primaryDark,
      cardColor: _AppColorsDark.card,
      shadowColor: _AppColorsDark.shadow,
      hintColor: _AppColorsDark.hint,
      hoverColor: _AppColorsDark.hover,
      highlightColor: _AppColorsDark.card,
      disabledColor: _AppColorsDark.hint,
      dividerColor: _AppColorsDark.divider,
      secondaryHeaderColor: Colors.white,
      iconTheme: const IconThemeData(color: _AppColorsDark.primaryDark),
      cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.light),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primaryColor,
      ),
      tooltipTheme: TooltipThemeData(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _AppColorsDark.divider,
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: darkBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      chipTheme: ChipThemeData(
        showCheckmark: false,
        backgroundColor: _AppColorsDark.card,
        selectedColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: _AppColorsDark.divider),
        ),
        shadowColor: _AppColorsDark.shadow,
        selectedShadowColor: _AppColorsDark.shadow,
        surfaceTintColor: Colors.transparent,
        disabledColor: _AppColorsDark.hint,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: AppColors.primaryColor,
        disabledThumbColor: AppColors.primaryColor.withAlpha(150),
        activeTrackColor: AppColors.primaryColor,
        valueIndicatorColor: AppColors.primaryColor,
        overlayColor: AppColors.primaryColor.withAlpha(50),
        disabledActiveTrackColor: AppColors.primaryColor.withAlpha(150),
        inactiveTrackColor: _AppColorsDark.divider,
        disabledInactiveTrackColor: _AppColorsDark.divider,
        trackShape: _CustomSliderTrackShape(),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _AppColorsDark.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _AppColorsDark.divider),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: _AppColorsDark.shadow,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryColor, // رنگ cursor
        selectionHandleColor: AppColors.primaryColor, // رنگ دستگیره انتخاب متن
      ),
      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll(AppColors.primaryColor),
        thumbColor: WidgetStatePropertyAll(Colors.white),
      ),
      drawerTheme: const DrawerThemeData(
        width: 300,
        backgroundColor: _AppColorsDark.card,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: _AppColorsDark.card,
        shadowColor: _AppColorsDark.shadow,
        barrierColor: Colors.white10,
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.primaryColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        selectedTileColor: Colors.white12,
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(Colors.white10),
        trackColor: WidgetStatePropertyAll(_AppColorsDark.background),
        trackVisibility: WidgetStatePropertyAll(true),
        trackBorderColor: WidgetStatePropertyAll(Colors.transparent),
        radius: Radius.circular(20),
        crossAxisMargin: 3,
        mainAxisMargin: 3,
      ),
      textTheme: TextTheme(
        displayLarge: darkBaseTextStyle.copyWith(fontSize: 26, fontWeight: FontWeight.w500),
        displayMedium: darkBaseTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
        displaySmall: darkBaseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
        headlineLarge: darkBaseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
        headlineMedium: darkBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        headlineSmall: darkBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        titleLarge: darkBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        titleMedium: darkBaseTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
        titleSmall: darkBaseTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
        bodyLarge: darkBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
        bodyMedium: darkBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        bodySmall: darkBaseTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
        labelLarge: darkBaseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: darkBaseTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
        labelSmall: darkBaseTextStyle.copyWith(fontSize: 8, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.hardEdge,
        color: _AppColorsDark.card,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: _AppColorsDark.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: _AppColorsDark.shadow, width: 2),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 12, horizontal: 20))),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 10,
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: _AppColorsDark.divider),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _AppColorsDark.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _AppColorsDark.hint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
      ),
    );
  }
}

abstract class AppImages {
  static const String _base = "lib/assets/images";
  static const String bermoodaLogo = "$_base/bermooda_logo.png";
  static const String bot = "$_base/bot.png";
  static const String cafebazaarBadgeEn = "$_base/cafebazaar_badge_en.png";
  static const String cafebazaarBadgeFa = "$_base/cafebazaar_badge_fa.png";
  static const String chatBg = "$_base/chat_bg_light.png";
  static const String defaultProfile = "$_base/default_profile.png";
  static const String exel = "$_base/exel.png";
  static const String folder = "$_base/folder_img.svg";
  static const String image = "$_base/image.png";
  static const String logo = '$_base/logo.png';
  static const String logoSplash = '$_base/logo_splash.png';
  static const String music = '$_base/music.png';
  static const String myketBadgeEn = '$_base/myket_badge_en.png';
  static const String myketBadgeFa = '$_base/myket_badge_fa.png';
  static const String pdf = "$_base/pdf.png";
  static const String powerPoint = "$_base/power_point.png";
  static const String scanQRCode = "$_base/scan_qrcode.png";
  static const String team = "$_base/team.png";
  static const String url = "$_base/url.png";
  static const String video = "$_base/video.png";
  static const String word = "$_base/word.png";
}

abstract class AppIcons {
  static const String _base = "lib/assets/icons";
  static const String absenceOutline = "$_base/absence_outline.svg";
  static const String addSquareOutline = "$_base/add_square_outline.svg";
  static const String adminOutline = "$_base/admin_outline.svg";
  static const String alarmOutline = "$_base/alarm_outline.svg";
  static const String appointment = "$_base/appointment.svg";
  static const String archiveOutline = "$_base/archive_outline.svg";
  static const String arrowSwapVert = "$_base/arrow_swap_vert.svg";
  static const String arrows = "$_base/arrows.svg";
  static const String attachment = "$_base/attachment.svg";
  static const String block = "$_base/block.svg";
  static const String bordColor = "$_base/bord_color.svg";
  static const String breakTimeOutline = "$_base/break_time_outline.svg";
  static const String briefcaseOutline = "$_base/briefcase_outline.svg";
  static const String businessesOutline = "$_base/businesses_outline.svg";
  static const String calendar = "$_base/calendar.svg";
  static const String calendarColor = "$_base/calendar_color.svg";
  static const String calendarOutline = "$_base/calendar_outline.svg";
  static const String callOutline = "$_base/call_outline.svg";
  static const String chat = "$_base/chat.svg";
  static const String chatOutline = "$_base/chat_outline.svg";
  static const String checkIn = "$_base/check_in.svg";
  static const String checkOut = "$_base/check_out.svg";
  static const String clockOutline = "$_base/clock_outline.svg";
  static const String closeCircle = "$_base/close_circle.svg";
  static const String contractOutline = "$_base/contract_outline.svg";
  static const String copyOutline = "$_base/copy_outline.svg";
  static const String crownOutline = "$_base/crown_outline.svg";
  static const String dangerOutline = "$_base/danger_outline.svg";
  static const String dashboard = "$_base/dashboard.svg";
  static const String dashboardOutline = "$_base/dashboard_outline.svg";
  static const String delete = "$_base/delete.svg";
  static const String departmentOutline = "$_base/department_outline.svg";
  static const String dollarOutline = "$_base/dollar_outline.svg";
  static const String editOutline = "$_base/edit_outline.svg";
  static const String emptyHomePage = "$_base/empty_home_page.svg";
  static const String emptyMailPage = "$_base/empty_mail_page.svg";
  static const String extension = "$_base/extension.svg";
  static const String extensionOutline = "$_base/extension_outline.svg";
  static const String externalMeeting = "$_base/external_meeting.svg";
  static const String fileOutline = "$_base/file_outline.svg";
  static const String filter = "$_base/filter.svg";
  static const String forwardMessage = "$_base/forward_message.svg";
  static const String galleryOutline = "$_base/gallery_outline.svg";
  static const String groupOutline = "$_base/group_outline.svg";
  static const String home = "$_base/home.svg";
  static const String homeOutline = "$_base/home_outline.svg";
  static const String humanResourceModule = "$_base/human_resource_module.png";
  static const String info = "$_base/info.svg";
  static const String internalMeeting = "$_base/internal_meeting.svg";
  static const String invoiceOutline = "$_base/invoice_outline.svg";
  static const String leaveOutline = "$_base/leave_outline.svg";
  static const String legalModule = "$_base/legal_module.svg";
  static const String linkOutline = "$_base/link_outline.svg";
  static const String listOutline = "$_base/list_outline.svg";
  static const String locationOutline = "$_base/location_outline.svg";
  static const String logout = "$_base/logout.svg";
  static const String mail = "$_base/mail.svg";
  static const String mailColor = "$_base/mail_color.svg";
  static const String mailOutline = "$_base/mail_outline.svg";
  static const String marketingModule = "$_base/marketing_module.png";
  static const String minusSquareOutline = "$_base/minus_square_outline.svg";
  static const String missionOutline = "$_base/mission_outline.svg";
  static const String moonOutline = "$_base/moon_outline.svg";
  static const String myDocsModule = "$_base/my_docs_module.svg";
  static const String noteOutline = "$_base/note_outline.svg";
  static const String notification = "$_base/notification.svg";
  static const String notificationOutline = "$_base/notification_outline.svg";
  static const String onlineMeeting = "$_base/online_meeting.svg";
  static const String pendingListOutline = "$_base/pending_list_outline.svg";
  static const String personalPlan = "$_base/personal_plan.svg";
  static const String presenceOutline = "$_base/presence_outline.svg";
  static const String progressStatusOutline = "$_base/progress_status_outline.svg";
  static const String projectModule = "$_base/project_module.svg";
  static const String employmentModule = "$_base/recruitment_module.svg";
  static const String reply = "$_base/reply.svg";
  static const String requestModule = "$_base/request_module.svg";
  static const String restore = "$_base/restore.svg";
  static const String crmModule = "$_base/sales_module.svg";
  static const String scanBarcodeOutline = "$_base/scan_barcode_outline.svg";
  static const String searchOutline = "$_base/search_outline.svg";
  static const String seen = "$_base/seen.png";
  static const String sendMessage = "$_base/send_message.svg";
  static const String settingsOutline = "$_base/settings_outline.svg";
  static const String staffManagementModule = "$_base/staff_management_module.svg";
  static const String statisticsOutline = "$_base/statistics_outline.svg";
  static const String supportModule = "$_base/support_module.svg";
  static const String tagOutline = "$_base/tag_outline.svg";
  static const String tickCircle = "$_base/tick_circle.svg";
  static const String tickCircleOutline = "$_base/tick_circle_outline.svg";
  static const String timer = "$_base/timer.svg";
  static const String timerOutline = "$_base/timer_outline.svg";
  static const String training = "$_base/training.svg";
  static const String unseen = "$_base/unseen.png";
  static const String updateOutline = "$_base/update_outline.svg";
  static const String userOctagonOutline = "$_base/user_octagon_outline.svg";
  static const String userOutline = "$_base/user_outline.svg";
  static const String profile = "$_base/user_tag.svg";
  static const String profileOutline = "$_base/user_tag_outline.svg";
  static const String walletOutline = "$_base/wallet_outline.svg";
  static const String warehouseModule = "$_base/warehouse_module.svg";
  static const String warningOutline = "$_base/warning_outline.svg";
}

abstract class AppLottie {
  static const String _base = "lib/assets/lottie";
  static const String emptyList = '$_base/empty_list_animation.lottie';
  static const String error = '$_base/error.lottie';
  static const String scanner = '$_base/scanner.lottie';
}

class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required final SliderThemeData sliderTheme,
    required final RenderBox parentBox,
    final Offset offset = Offset.zero,
    final bool isEnabled = false,
    final bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx + 12;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    // ✅ کل عرض والد را برای بدنه در نظر می‌گیریم
    final double trackWidth = parentBox.size.width - 24;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

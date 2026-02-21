import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';

enum ProviderType { kavenegar, sms_ir }

enum SMSStatus {
  pending("Pending", "در انتظار ارسال"),
  scheduled("Scheduled", "زمان\u200Cبندی شده"),
  sent("Sent", "ارسال\u200Cشده"),
  delivered("Delivered", "دریافت\u200Cشده"),
  failed("Failed", "ناموفق"),
  cancelled("Cancelled", "لغو شده");

  const SMSStatus(this.tEn, this.tFa);
  final String tEn;
  final String tFa;

  String get title => isPersianLang ? tFa : tEn;

  Color get color => switch(this) {
    SMSStatus.scheduled => AppColors.blue,
    SMSStatus.pending => AppColors.orange,
    SMSStatus.sent => AppColors.green,
    SMSStatus.delivered => AppColors.green,
    SMSStatus.failed => AppColors.red,
    SMSStatus.cancelled => Colors.grey,
  };

  static SMSStatus? fromString(final String? value) {
    switch(value) {
      case "pending":
        return SMSStatus.pending;
      case "scheduled":
        return SMSStatus.scheduled;
      case "sent":
        return SMSStatus.sent;
      case "delivered":
        return SMSStatus.delivered;
      case "failed":
        return SMSStatus.failed;
      case "cancelled":
        return SMSStatus.cancelled;
      default:
        return null;
    }
  }
}

enum GroupSMSStatus {
  scheduled("Scheduled", "زمان\u200Cبندی شده"),
  sending("Sending", "در حال ارسال"),
  completed("Completed", "تکمیل\u200Cشده"),
  failed("Failed", "ناموفق"),
  cancelled("Cancelled", "لغو شده");

  const GroupSMSStatus(this.tEn, this.tFa);
  final String tEn;
  final String tFa;

  String get title => isPersianLang ? tFa : tEn;

  Color get color => switch(this) {
    GroupSMSStatus.scheduled => AppColors.blue,
    GroupSMSStatus.sending => AppColors.orange,
    GroupSMSStatus.completed => AppColors.green,
    GroupSMSStatus.failed => AppColors.red,
    GroupSMSStatus.cancelled => Colors.grey,
  };

  static GroupSMSStatus? fromString(final String? value) {
    switch(value) {
      case "scheduled":
        return GroupSMSStatus.scheduled;
      case "sending":
        return GroupSMSStatus.sending;
      case "completed":
        return GroupSMSStatus.completed;
      case "failed":
        return GroupSMSStatus.failed;
      case "cancelled":
        return GroupSMSStatus.cancelled;
      default:
        return null;
    }
  }
}

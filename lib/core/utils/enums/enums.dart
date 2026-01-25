import 'package:u/utilities.dart';

import '../../../data/data.dart';
import '../../core.dart';
import '../../theme.dart';

part 'enums_extentions.dart';

enum ActionApiType { create, update, delete }

enum MemberActivityType { running, stopped }

enum MemberActivityCommand { play, stop }

enum AuthStatus {
  pending("Pending", "در انتظار"),
  accepted("Verified", "احراز هویت شده"),
  rejected("Rejected", "رد شده");

  const AuthStatus(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum OwnerMemberType {
  owner("Owner", "صاحب کسب\u200Cوکار"),
  member("Member", "عضو");

  const OwnerMemberType(this.title, this.titleTr1);

  final String title;
  final String titleTr1;

  String getTitle() => !isPersianLang ? title : titleTr1;

  static OwnerMemberType? fromString(final String? type) {
    switch (type) {
      case 'owner':
        return OwnerMemberType.owner;
      case 'member':
        return OwnerMemberType.member;
      default:
        return null;
    }
  }
}

enum ChatConnectionType {
  connecting("Connecting...", "در حال اتصال..."),
  update("Update...", "بروزرسانی..."),
  done("", "");

  const ChatConnectionType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum NotificationDataType {
  task_data,
  check_list_data,
  customer_data,
  tracking_data,
}

enum CustomerStatus {
  dont_followed("Closed-Lost", "عدم نیاز به پیگیری"),
  successful_sell("Closed-Won", "فروش موفق");

  const CustomerStatus(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum ConnectionType {
  phone("Phone", "تماس"),
  email("Email", "ایمیل"),
  sms("SMS", "پیامک"),
  social_media("Social Media", "شبکه اجتماعی");

  const ConnectionType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum InvoiceType {
  preinvoice("Proforma", "پیش‌فاکتور"),
  finalinvoice("Invoice", "فاکتور");

  const InvoiceType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;

  static InvoiceType? fromString(final String? type) {
    switch (type) {
      case 'preinvoice':
        return InvoiceType.preinvoice;
      case 'finalinvoice':
        return InvoiceType.finalinvoice;
      default:
        return null;
    }
  }
}

enum InvoiceStatusType {
  draft("Draft", "پیش‌نویس"),
  approved("Approved", "تأییدشده"),
  sent("Sent", "ارسال‌شده"),
  awaiting_payment("Awaiting Payment", "در انتظار پرداخت"),
  partially_paid("Partially Paid", "قسط پرداخت‌شده"),
  paids("Paid", "پرداخت‌شده کامل"),
  overdue("Overdue", "معوق / دیرکرد"),
  cancelled("Cancelled", "لغو شده"),
  refunded("Credited/Refunded", "اعتباری/برگشتی");

  const InvoiceStatusType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum PaymentType {
  cash("Cash", "نقدی"),
  installment("Installments", "اقساط");

  const PaymentType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum ContractStatus {
  pending("Pending", "در انتظار امضا"),
  signed("Signed", "امضا شده"),
  completed("Completed", "تکمیل شده"),
  rejected("Rejected", "رد شده"),
  expired("Expired", "منقضی شده");

  const ContractStatus(this.title, this.titleTr1);

  final String title;
  final String titleTr1;

  String getTitle() => !isPersianLang ? title : titleTr1;

  Color get color {
    switch (this) {
      case ContractStatus.pending:
        return AppColors.orange;
      case ContractStatus.signed:
        return AppColors.green;
      case ContractStatus.completed:
        return AppColors.green;
      case ContractStatus.rejected:
        return Colors.grey;
      case ContractStatus.expired:
        return AppColors.red;
    }
  }

  static ContractStatus? fromString(final String? status, {final ContractStatus? defaultValue}) {
    switch (status) {
      case 'pending':
        return ContractStatus.pending;
      case 'signed':
        return ContractStatus.signed;
      case 'completed':
        return ContractStatus.completed;
      case 'rejected':
        return ContractStatus.rejected;
      case 'expired':
        return ContractStatus.expired;
      default:
        return defaultValue;
    }
  }
}

enum EventType {
  personalPlan("Personal Plan", "برنامه شخصی", AppIcons.personalPlan, Color(0xffFF1D2C)),
  internalMeeting("Internal Meeting", "جلسه داخلی", AppIcons.internalMeeting, Color(0xff00C213)),
  externalMeeting("External Meeting", "جلسه خارجی", AppIcons.externalMeeting, Color(0xff8F0EFF)),
  onlineMeeting("Online Meeting", "جلسه آنلاین", AppIcons.onlineMeeting, Color(0xff0EB5FF)),
  appointment("Appointment", "ملاقات", AppIcons.appointment, Color(0xffE500D6)),
  training("Training", "آموزشی", AppIcons.training, Color(0xffFFCC00));

  const EventType(this.title, this.titleTr1, this.icon, this.color);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String icon;
  final Color color;
}

enum LabelColors {
  yellow("Yellow", "زرد", Color(0xffE7C726), "#E7C726"),
  red("Red", "قرمز", Color(0xffDB4646), "#DB4646"),
  green("Green", "سبز", Color(0xff02C875), "#02C875"),
  blue("Blue", "آبی", Color(0xff04C4B7), "#04C4B7"),
  purple("Purple", "بنفش", Color(0xff9C00E8), "#9C00E8"),
  ping("Pink", "صورتی", Color(0xffE82BA3), "#E82BA3"),
  grey("Grey", "خاکستری", Color(0xff636D74), "#636D74");

  const LabelColors(this.title, this.titleTr1, this.color, this.colorCode);

  String getTitle() => !isPersianLang ? title : titleTr1;

  static LabelColors getRandom() {
    final random = Random().nextInt(values.length);
    final color = values.elementAt(random);
    return color;
  }

  static LabelColors fromColorCode(final String? value) {
    if (value == null) return LabelColors.yellow;
    return LabelColors.values.firstWhereOrNull((final e) => e.colorCode == value) ?? LabelColors.yellow;
  }

  final String title;
  final String titleTr1;
  final Color color;
  final String colorCode;
}

enum ReminderTimeType {
  fiveMinutes("5 minutes before start", "5 دقیقه قبل از شروع", "minute", 5),
  tenMinutes("10 minutes before start", "10 دقیقه قبل از شروع", "minute", 10),
  fifteenMinutes("15 minutes before start", "15 دقیقه قبل از شروع", "minute", 15),
  halfHour("30 minutes before start", "۳۰ دقیقه قبل از شروع", "minute", 30),
  oneHour("1 hour before start", "1 ساعت قبل از شروع", "hour", 1),
  oneDay("1 day before start", "1 روز قبل از شروع", "day", 1);

  const ReminderTimeType(this.title, this.titleTr1, this.type, this.number);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String type;
  final int number;
}

enum RepeatType {
  noRepetition("No Repeat", "تکرار نمیشود", "no_repetition"),
  daily("Daily", "هر روز", "daily"),
  weakly("Weakly", "هر هفته", "weakly"),
  monthly("Monthly", "هر ماه", "monthly");

  const RepeatType(this.title, this.titleTr1, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String value;
}

enum CalendarFilterType { all, meetings, checklists, customers }

enum AuthenticationType {
  person,
  legal;

  String get title => switch (this) {
    AuthenticationType.person => s.personal,
    AuthenticationType.legal => s.legal,
  };
}

enum SubscriptionPurchaseType {
  no_purchase("No Subscription", "فاقد اشتراک"),
  trial("30 Days Free", "30 روز رایگان"),
  subscription("Purchased", "خریداری شده");

  const SubscriptionPurchaseType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

/// Values must be the same of [PermissionName]'s values
enum ModuleType {
  project,
  crm,
  humanResources,
  requests,
  conversation,
  legal,
  sms,
  cloudCall,
  employment,
  marketing,
  planning,
  letters;

  String get title => switch (this) {
    ModuleType.project => s.project,
    ModuleType.crm => s.customers,
    ModuleType.humanResources => s.humanResources,
    ModuleType.requests => s.requests,
    ModuleType.conversation => s.conversation,
    ModuleType.legal => s.legal,
    ModuleType.sms => s.sms,
    ModuleType.cloudCall => s.cloudCall,
    ModuleType.employment => s.employment,
    ModuleType.marketing => s.marketing,
    ModuleType.planning => s.planning,
    ModuleType.letters => s.correspondence,
  };

  static ModuleType? fromString(final String? type) {
    switch (type) {
      case 'PRM':
        return ModuleType.project;
      case 'CRM':
        return ModuleType.crm;
      case 'HRS':
        return ModuleType.humanResources;
      case 'RQS':
        return ModuleType.requests;
      case 'CON':
        return ModuleType.conversation;
      case 'LGL':
        return ModuleType.legal;
      case 'SMS':
        return ModuleType.sms;
      case 'CLC':
        return ModuleType.cloudCall;
      case 'employment':
        return ModuleType.employment;
      case 'marketing':
        return ModuleType.marketing;
      case 'planing':
        return ModuleType.planning;
      case 'letters':
        return ModuleType.letters;
      default:
        return null;
    }
  }
}

/// Values must be the same of [ModuleType]'s values
enum PermissionName {
  project("Project", "پروژه", "project board"),
  crm("Customers", "مشتریان", "crm"),
  humanResources("Human Resources (HR)", "سرمایه انسانی (HR)", "human_resources"),
  legal("Legal", "حقوقی", "LGL");

  const PermissionName(this.title, this.titleTr1, this.value);

  final String title;
  final String titleTr1;
  final String value;

  String getTitle() => !isPersianLang ? title : titleTr1;

  static PermissionName? fromString(final String? type) {
    switch (type) {
      case 'project board':
        return PermissionName.project;
      case 'crm':
        return PermissionName.crm;
      case 'human_resources':
        return PermissionName.humanResources;
      case 'LGL':
        return PermissionName.legal;
      default:
        return null;
    }
  }
}

enum PermissionType {
  manager("Manager", "مدیر", AppColors.green, AppIcons.adminOutline, "manager"),
  supervisor("Supervisor", "ناظر", AppColors.blue, AppIcons.userOctagonOutline, "supervisor"),
  expert("Specialist", "کارشناس", AppColors.orange, AppIcons.userOutline, "expert"),
  noAccess("No Access", "بدون دسترسی", AppColors.red, AppIcons.block, "no access");

  const PermissionType(this.title, this.titleTr1, this.color, this.icon, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final Color color;
  final String icon;
  final String value;

  static PermissionType? fromString(final String? type) {
    switch (type) {
      case 'manager':
        return PermissionType.manager;
      case 'supervisor':
        return PermissionType.supervisor;
      case 'expert':
        return PermissionType.expert;
      case 'no access':
        return PermissionType.noAccess;
      default:
        return null;
    }
  }
}

enum InsuranceType {
  taminEjtemaei("Social Security", "تامین اجتماعی", "tamin_ejtemaei"),
  takmili("Supplementary Insurance", "تکمیلی", "takmili"),
  bazneshastegi("Retirement", "بازنشستگی", "bazneshastegi"),
  darmani("Medical / Healthcare", "درمانی", "darmani"),
  hekmat("Hekmat", "حکمت", "hekmat"),
  nobat("Appointment / Turn", "نوبت", "nobat"),
  other("Other", "سایر", "other");

  const InsuranceType(this.title, this.titleTr1, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String value;
}

enum BusinessSize {
  twoToTen("2 to 10 employees", "2 تا 10 نفر"),
  tenToFifteen("10 to 15 employees", "10 تا 15 نفر"),
  fifteenToFifty("15 to 50 employees", "15 تا 50 نفر"),
  fiftyToTwoFifty("50 to 250 employees", "50 تا 250 نفر"),
  twoFiftyToFiveHundred("250 to 500 employees", "250 تا 500 نفر"),
  fiveHundredToOneThousand("500 to 1,000 employees", "500 تا 1000 نفر"),
  moreThanOneThousand("More than 1,000 employees", "بیش از 1000 نفر");

  const BusinessSize(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum GenderType {
  male("Male", "مرد"),
  female("Female", "زن");

  const GenderType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum MilitaryStatus {
  eligible("Eligible", "مشمول", "subject_to_service"),
  exempted("Exempted", "معاف", "exempt_from_service"),
  completed("Completed", "پایان خدمت", "end_of_service"),
  serving("Serving", "درحال خدمت", "in_the_service");

  const MilitaryStatus(this.title, this.titleTr1, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String value;
}

enum EducationType {
  highschool("High School Diploma", "دیپلم"),
  associate("Associate Degree", "کاردانی"),
  bachelor("Bachelor’s Degree", "کارشناسی"),
  master("Master’s Degree", "کارشناسی ارشد"),
  phd("Doctorate / PhD", "دکتری");

  const EducationType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum EmploymentType {
  fullTime("Full-time", "تمام‌وقت", "fulltime"),
  partTime("Part-time", "پاره‌وقت", "parttime"),
  remote("Remote / Freelance", "دورکاری", "remote"),
  contract("Contract / Freelance", "پروژه‌ای", "contract"),
  internship("Internship", "کارآموزی", "internship"),
  hourly("Hourly", "ساعتی", "hourly");

  const EmploymentType(this.title, this.titleTr1, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final String value;
}

enum SalaryType {
  monthly("Monthly", "ماهانه", "monthly"),
  hourly("Hourly", "ساعتی", "hourly"),
  perProject("Per Project", "پروژه‌ای", "per_project"),
  commissionBased("Commission-based", "پورسانتی", "commission_based"),
  negotiable("Negotiable", "توافقی", "negotiable"),
  baseCommission("Base + Commission", "ثابت + پورسانت", "base_commission");

  const SalaryType(this.title, this.titleTr1, this.value);

  String getTitle() => !isPersianLang ? title : titleTr1;

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
  final String value;
}

enum RecipientType {
  sign('Signer', 'امضا کننده'),
  cc('Carbon Copy (CC)', 'رونوشت (CC)'),
  vcc('Blind Carbon Copy (BCC)', 'رونوشت پنهان (BCC)');

  const RecipientType(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum TimerStatus { running, paused, stopped }

enum TimerStatusCommand { play, pause, reset, stop }

// enum HistoryFilterType {
enum ReportType {
  all(null),
  update("notification"),
  archive("archive"),
  note("note");
  // invoice("factor"),
  // contract("contract");

  const ReportType(this.value);

  final String? value;

  String get title {
    switch (this) {
      case ReportType.all:
        return s.all;
      case ReportType.update:
        return s.update;
      case ReportType.archive:
        return s.archive;
      case ReportType.note:
        return s.note;
      // case HistoryFilterType.invoice:
      //   return s.invoice;
      // case HistoryFilterType.contract:
      //   return s.contract;
    }
  }

  String get iconString {
    switch (this) {
      case ReportType.all:
        return '';
      case ReportType.update:
        return AppIcons.updateOutline;
      case ReportType.archive:
        return AppIcons.archiveOutline;
      case ReportType.note:
        return AppIcons.noteOutline;
      // case HistoryFilterType.invoice:
      //   return AppIcons.invoiceOutline;
      // case HistoryFilterType.contract:
      //   return AppIcons.contractOutline;
    }
  }

  static ReportType? fromString(final String value) {
    switch (value) {
      case 'notification':
        return ReportType.update;
      case 'archive':
        return ReportType.archive;
      case 'note':
        return ReportType.note;
      default:
        return null;
    }
  }
}

enum StatisticsTimePeriodFilter {
  today("Last 24 hours", "24 ساعت اخیر"),
  last_day("Last 48 hours", "48 ساعت اخیر"),
  last_week("Last 7 days", "7 روز اخیر"),
  last_month("Last 30 days", "30 روز اخیر"),
  last_three_month("Last 90 days", "90 روز اخیر"),
  last_year("Last 365 days", "365 روز اخیر");

  const StatisticsTimePeriodFilter(this.title, this.titleTr1);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
}

enum SubscriptionPeriod {
  oneMonth("1 Month", "۱ ماه", 30),
  threeMonths("3 Months", "۳ ماه", 90),
  sixMonths("6 Months", "۶ ماه", 180),
  twelveMonths("12 Months", "۱۲ ماه", 365);

  const SubscriptionPeriod(this.title, this.titleTr1, this.days);

  String getTitle() => !isPersianLang ? title : titleTr1;

  final String title;
  final String titleTr1;
  final int days;
}

enum SubscriptionStatus {
  active,
  expiringSoon,
  expired;

  String get title {
    switch (this) {
      case SubscriptionStatus.active:
        return s.active;
      case SubscriptionStatus.expiringSoon:
        return s.expiringSoon;
      case SubscriptionStatus.expired:
        return s.expired;
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionStatus.active:
        return AppColors.green;
      case SubscriptionStatus.expiringSoon:
        return AppColors.orange;
      case SubscriptionStatus.expired:
        return AppColors.red;
    }
  }

  String get icon {
    switch (this) {
      case SubscriptionStatus.active:
        return '⭐';
      case SubscriptionStatus.expiringSoon:
        return '⏰';
      case SubscriptionStatus.expired:
        return '⚠️';
    }
  }
}

enum ProjectArchiveFilter {
  all,
  deleted,
  done;

  String get title {
    switch (this) {
      case ProjectArchiveFilter.all:
        return s.all;
      case ProjectArchiveFilter.deleted:
        return s.deleted;
      case ProjectArchiveFilter.done:
        return s.doned;
    }
  }
}

enum SubtaskFilter {
  all,
  is_working,
  is_done;

  String get title {
    switch (this) {
      case SubtaskFilter.all:
        return s.all;
      case SubtaskFilter.is_working:
        return s.todo;
      case SubtaskFilter.is_done:
        return s.doned;
    }
  }
}

enum AttendanceTimeStatus {
  on_time,
  early,
  late;

  String get title {
    switch (this) {
      case AttendanceTimeStatus.on_time:
        return s.onTime;
      case AttendanceTimeStatus.early:
        return s.early;
      case AttendanceTimeStatus.late:
        return s.late;
    }
  }
}

enum AttendanceMethod {
  manual,
  qr_code;
  // finger_print,
  // face_id;

  String get title {
    switch (this) {
      case AttendanceMethod.manual:
        return s.manual;
      case AttendanceMethod.qr_code:
        return "QR Code";
      // case AttendanceMethod.finger_print:
      //   return s.fingerPrint;
      // case AttendanceMethod.face_id:
      //   return s.faceId;
    }
  }
}

enum AttendanceModalType {
  check_in,
  check_out;

  String get title {
    switch (this) {
      case AttendanceModalType.check_in:
        return s.swipeToCheckIn;
      case AttendanceModalType.check_out:
        return s.swipeToCheckOut;
    }
  }
}

enum AttendanceStatus {
  present,
  absent,
  leave,
  mission,
  empty;

  String get title {
    switch (this) {
      case AttendanceStatus.present:
        return s.presence;
      case AttendanceStatus.absent:
        return s.absence;
      case AttendanceStatus.leave:
        return s.leave;
      case AttendanceStatus.mission:
        return s.mission;
      case AttendanceStatus.empty:
        return s.noData;
    }
  }

  // IconData get icon {
  String get icon {
    switch (this) {
      case AttendanceStatus.present:
        return AppIcons.presenceOutline;
      case AttendanceStatus.absent:
        return AppIcons.absenceOutline;
      case AttendanceStatus.leave:
        return AppIcons.leaveOutline;
      case AttendanceStatus.mission:
        return AppIcons.missionOutline;
      case AttendanceStatus.empty:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.present:
        return AppColors.green.withValues(alpha: 0.5);
      case AttendanceStatus.absent:
        return AppColors.red.withValues(alpha: 0.5);
      case AttendanceStatus.leave:
        return AppColors.orange.withValues(alpha: 0.5);
      case AttendanceStatus.mission:
        return AppColors.purple.withValues(alpha: 0.5);
      case AttendanceStatus.empty:
        return Colors.transparent;
    }
  }
}

enum AttendanceReportType {
  check_in,
  resume,
  check_out,
  check_out_temporary,
  rest_start,
  rest_end,
  leave_start,
  leave_end,
  mission_start,
  mission_end,
  overtime_start,
  overtime_end;

  String get title {
    switch (this) {
      case AttendanceReportType.check_in || AttendanceReportType.resume:
        return s.checkIn;
      case AttendanceReportType.check_out || AttendanceReportType.check_out_temporary:
        return s.checkOut;
      case AttendanceReportType.rest_start:
        return s.breakStart;
      case AttendanceReportType.rest_end:
        return s.breakEnd;
      case AttendanceReportType.leave_start:
        return s.leaveStart;
      case AttendanceReportType.leave_end:
        return s.leaveEnd;
      case AttendanceReportType.mission_start:
        return s.missionStart;
      case AttendanceReportType.mission_end:
        return s.missionEnd;
      case AttendanceReportType.overtime_start:
        return s.overtimeStart;
      case AttendanceReportType.overtime_end:
        return s.overtimeEnd;
    }
  }

  String get icon {
    switch (this) {
      case AttendanceReportType.check_in || AttendanceReportType.resume:
        return AppIcons.checkIn;
      case AttendanceReportType.check_out || AttendanceReportType.check_out_temporary:
        return AppIcons.checkOut;
      case AttendanceReportType.rest_start:
        return AppIcons.breakTimeOutline;
      case AttendanceReportType.rest_end:
        return AppIcons.breakTimeOutline;
      case AttendanceReportType.leave_start:
        return AppIcons.leaveOutline;
      case AttendanceReportType.leave_end:
        return AppIcons.leaveOutline;
      case AttendanceReportType.mission_start:
        return AppIcons.missionOutline;
      case AttendanceReportType.mission_end:
        return AppIcons.missionOutline;
      case AttendanceReportType.overtime_start:
        return AppIcons.timerOutline;
      case AttendanceReportType.overtime_end:
        return AppIcons.timerOutline;
    }
  }

  Color get color {
    switch (this) {
      case AttendanceReportType.check_in || AttendanceReportType.resume:
        return AppColors.green;
      case AttendanceReportType.check_out || AttendanceReportType.check_out_temporary:
        return AppColors.red;
      case AttendanceReportType.rest_start || AttendanceReportType.rest_end:
        return AppColors.yellow;
      case AttendanceReportType.leave_start || AttendanceReportType.leave_end:
        return AppColors.orange;
      case AttendanceReportType.mission_start || AttendanceReportType.mission_end:
        return AppColors.purple;
      case AttendanceReportType.overtime_start || AttendanceReportType.overtime_end:
        return AppColors.blue;
    }
  }
}

enum MessageType {
  system,
  text,
  image,
  video,
  audio,
  file,
  voice;

  String? get title {
    switch (this) {
      case MessageType.text || MessageType.system:
        return null;
      case MessageType.image:
        return '📷 ${s.image}';
      case MessageType.video:
        return '🎥 ${s.video}';
      case MessageType.audio:
        return '🎵 ${s.audio}';
      case MessageType.file:
        return '📎 ${s.file}';
      case MessageType.voice:
        return '🎤 ${s.voiceMessage}';
    }
  }

  static MessageType fromString(final String? type) {
    switch (type) {
      case 'system':
        return MessageType.system;
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      case 'file':
        return MessageType.file;
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  static MessageStatus fromString(final String? status) {
    switch (status) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sending;
    }
  }
}

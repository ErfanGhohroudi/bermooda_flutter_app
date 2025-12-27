import 'package:flutter/material.dart';

import '../../theme.dart';

enum RequestCategoryType {
  leave_attendance("Leave", "مرخصی و حضور و غیاب"),
  missions_work("Mission", "مأموریت‌ها و امور کاری"),
  welfare_financial("Welfare", "خدمات رفاهی و مالی"),
  support_logistics("Support", "امور پشتیبانی و تدارکات"),
  employment("Recruitment", "جذب نیرو"),
  overtime("Overtime", "اضافه کاری"),
  general_requests("General", "سایر درخواست‌های عمومی");

  const RequestCategoryType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum LeaveType {
  entitlement_leave("Entitled Leave", "مرخصی استحقاقی"),
  sick_leave("Sick Leave", "مرخصی استعلاجی"),
  unpaid_leave("Unpaid Leave", "مرخصی بدون حقوق"),
  hourly_leave("Hourly Leave", "مرخصی ساعتی"),
  special_occasion_leave("Ceremonial Leave", "مرخصی مناسبتی");

  const LeaveType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum MissionType {
  out_of_city_mission("Out of City Mission", "مأموریت برون‌شهری"),
  in_city_mission("In City Mission", "مأموریت درون‌شهری"),
  mission_expense_payment("Expense Payment", "پرداخت هزینه‌های مأموریت");

  const MissionType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum WelfareType {
  loan_advance("Loan", "وام یا مساعده"),
  supplementary_insurance("Insurance", "بیمه تکمیلی / خدمات درمانی"),
  allowances("Allowance", "کمک‌هزینه‌ها"),
  other_welfare_services("Other Welfare", "سایر خدمات رفاهی");

  const WelfareType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum SupportType {
  equipment_purchase("Equipment Purchase", "خرید تجهیزات"),
  office_supplies("Office Supplies", "لوازم مصرفی اداری"),
  equipment_repair("Equipment Repair", "تعمیر، جایگزینی یا ارتقا تجهیزات");

  const SupportType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum GeneralType {
  personal_info_change("Personal Info Change", "تغییر اطلاعات پرسنلی"),
  employment_certificate("Employment Certificate", "گواهی اشتغال به کار"),
  introduction_letter("Introduction Letter", "معرفی‌نامه");

  const GeneralType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum EmploymentCooperationType {
  permanent("Permanent Employment", "استخدام دائمی"),
  temporary("Temporary Employment", "استخدام موقت"),
  internship("Internship Employment", "استخدام کارآموز"),
  outsourcing("Outsourcing", "برون‌سپاری");

  const EmploymentCooperationType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum WorkloadType {
  full_time("Full-time", "تمام‌وقت"),
  part_time("Part-time", "پاره‌وقت");

  const WorkloadType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum OvertimeType {
  regular_day("Weekday Overtime", "اضافه کاری روز عادی"),
  holiday("Holiday/Weekend Overtime", "اضافه کاری روز تعطیل"),
  nightly("Night Work", "اضافه کاری شبانه"),
  Special("Emergency Overtime", "اضافه کاری اضطراری/بحرانی");

  const OvertimeType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum EmploymentWorkLocation {
  office("On-site", "حضوری"),
  remote("Remote", "دورکار"),
  hybrid("Hybrid", "ترکیبی");

  const EmploymentWorkLocation(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

// Enum های فرعی برای جزئیات بیشتر
enum SickLeaveType {
  cold("Cold", "سرماخوردگی"),
  surgery("Surgery", "جراحی"),
  hospitalization("Hospitalization", "بستری"),
  other("Other", "سایر");

  const SickLeaveType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum HourlyLeaveReason {
  banking("Banking", "کار بانکی"),
  medical_visit("Medical", "مراجعه پزشکی"),
  personal_affairs("Personal", "امور شخصی"),
  other("Other", "سایر");

  const HourlyLeaveReason(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum CeremonialLeaveType {
  marriage("Marriage", "ازدواج"),
  child_birth("Birth", "تولد فرزند"),
  family_death("Death", "فوت بستگان درجه یک");

  const CeremonialLeaveType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum MissionPurpose {
  meeting("Meeting", "جلسه"),
  visit("Visit", "بازدید"),
  training("Training", "آموزش"),
  other("Other", "سایر");

  const MissionPurpose(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum TransportationType {
  personal_car("Personal Car", "خودرو شخصی"),
  company_car("Organizational Car", "خودرو سازمان"),
  taxi("Taxi", "تاکسی"),
  bus("Bus", "اتوبوس"),
  train("Train", "قطار"),
  plane("Airplane", "هواپیما");

  const TransportationType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum AccommodationType {
  hotel("Hotel", "هتل"),
  guesthouse("Guesthouse", "مهمانسرا"),
  other("Other", "سایر");

  const AccommodationType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum ExpenseType {
  transportation("Transportation", "حمل‌ونقل"),
  accommodation("Accommodation", "اقامت"),
  food("Food", "غذا"),
  other("Other", "سایر");

  const ExpenseType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum PaymentMethod {
  cash("Cash", "نقدی"),
  card("Card", "کارت"),
  organization_pay("Organization", "سازمان پرداخت کند");

  const PaymentMethod(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum LoanType {
  loan("Loan", "وام"),
  advance("Advance", "مساعده");

  const LoanType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum RepaymentType {
  installment("Installments", "قسطی"),
  lump_sum("Lump Sum", "یکجا");

  const RepaymentType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum InsuranceRequestType {
  registration("Registration", "ثبت‌نام"),
  renewal("Renewal", "تمدید"),
  add_family("Add Family", "اضافه کردن خانواده"),
  reimbursement("Reimbursement", "بازپرداخت هزینه درمان");

  const InsuranceRequestType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum AllowanceType {
  transportation("Transportation", "ایاب و ذهاب"),
  housing("Housing", "مسکن"),
  food("Food", "تغذیه"),
  other("Other", "سایر");

  const AllowanceType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum AllowancePeriod {
  monthly("Monthly", "ماهانه"),
  yearly("Yearly", "سالانه"),
  case_by_case("Case by Case", "موردی");

  const AllowancePeriod(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum EquipmentType {
  laptop("Laptop", "لپ‌تاپ"),
  monitor("Monitor", "مانیتور"),
  desk("Desk", "میز"),
  chair("Chair", "صندلی"),
  mobile("Mobile", "موبایل"),
  other("Other", "سایر");

  const EquipmentType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum UrgencyLevel {
  normal("Normal", "عادی"),
  urgent("Urgent", "فوری");

  const UrgencyLevel(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum RepairType {
  repair("Repair", "تعمیر"),
  upgrade("Upgrade", "ارتقاء"),
  replacement("Replacement", "جایگزینی");

  const RepairType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum PersonalInfoType {
  address("Address", "آدرس"),
  bank_account("Bank Account", "شماره حساب"),
  phone("Phone Number", "شماره تماس"),
  marital_status("Marital Status", "وضعیت تأهل"),
  other("Other", "سایر");

  const PersonalInfoType(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum CertificateLanguage {
  persian("Persian", "فارسی"),
  english("English", "انگلیسی");

  const CertificateLanguage(this.title, this.titleTr1);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
}

enum StatusType {
  pending_to_users("Submitted", "ثبت شده", Colors.grey),
  pending("Pending", "در انتظار", AppColors.orange),
  approved("Approved", "تایید شده", AppColors.green),
  rejected("Rejected", "رد شده", AppColors.red);

  const StatusType(this.title, this.titleTr1, this.color);

  @override
  String toString() => name;
  final String title;
  final String titleTr1;
  final Color color;
}

enum StatusFilter {
  pending("Pending", "در انتظار", [StatusType.pending_to_users, StatusType.pending]),
  completed("Completed", "تکمیل شده", [StatusType.approved, StatusType.rejected]);

  const StatusFilter(this.title, this.titleTr1, this.value);

  final String title;
  final String titleTr1;
  final List<StatusType> value;
}

part of '../../../data.dart';

class YearShiftParams {
  YearShiftParams({
    required this.year,
    required this.workshiftSlug,
    this.customData,
    this.isMonth = false,
    this.monthList,
  });

  final int year;
  final String workshiftSlug;
  final Map<String, dynamic>? customData;
  final bool isMonth;
  final List<Map<String, dynamic>>? monthList;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        'year': year,
        'workshift_slug': workshiftSlug,
        if (customData != null) 'custom_data': customData,
        if (isMonth) 'is_month': isMonth,
        if (monthList != null) 'month_list': monthList,
      };
}


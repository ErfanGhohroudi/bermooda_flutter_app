part of '../../data.dart';

class CustomerStatusParams {
  CustomerStatusParams({
    this.customerStatus,
    this.connectionType,
    this.followUpAgain = false,
    this.dateTimeToRemember,
    this.userAccountId,
    this.invoiceId,
    this.fileIdList,
    this.currencySlug,
    this.sellBalance,
    this.statusReasons,
    this.description,
  });

  final CustomerStatus? customerStatus;
  final ConnectionType? connectionType;
  final bool followUpAgain;
  final String? dateTimeToRemember;
  final String? userAccountId;
  final int? invoiceId;
  final List<int>? fileIdList;
  final String? currencySlug;
  final String? sellBalance;
  final List<StatusReasonReadDto>? statusReasons;
  final String? description;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
        "customer_status": customerStatus?.name,
        "connection_type": connectionType?.name,
        "follow_up_again": followUpAgain,
        "date_time_to_remember": dateTimeToRemember,
        "user_account_id": userAccountId?.toInt(),
        "invoice_id": invoiceId,
        "file_id_list": fileIdList,
        "currency_slug": currencySlug,
        "sell_balance": sellBalance?.numericOnly().toInt(),
        "status_category_slug_list": statusReasons?.map((final e) => e.slug).toList(),
        "description": description,
      };
}

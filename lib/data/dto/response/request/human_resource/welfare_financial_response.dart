part of '../../../../data.dart';

/// Welfare and Financial Response Parameters
class WelfareFinancialRequestEntity extends BaseResponseParams {
  WelfareFinancialRequestEntity({
    super.slug,
    super.currentReviewer,
    super.requestingUser,
    super.reviewerUsers,
    required super.categoryType,
    super.description,
    super.status,
    required this.welfareType,
    this.requestTypeFinancial,
    this.amount,
    this.date,
    this.bankAccountNumber,
    this.repaymentMethod,
    this.insuranceRequestType,
    this.coveredPersonDetails,
    this.allowanceType,
    this.allowancePeriod,
    this.files,
  });

  final WelfareType welfareType;
  final LoanType? requestTypeFinancial;
  final String? amount;
  final String? date;
  final String? bankAccountNumber;
  final RepaymentType? repaymentMethod;
  final InsuranceRequestType? insuranceRequestType;
  final String? coveredPersonDetails;
  final AllowanceType? allowanceType;
  final AllowancePeriod? allowancePeriod;
  final List<MainFileReadDto>? files;

  @override
  RequestCategoryType get categoryType => RequestCategoryType.welfare_financial;

  factory WelfareFinancialRequestEntity.fromJson(final String str) => WelfareFinancialRequestEntity.fromMap(json.decode(str));

  factory WelfareFinancialRequestEntity.fromMap(final Map<String, dynamic> json) => WelfareFinancialRequestEntity(
        slug: json["slug"],
        requestingUser: json["requesting_user"] == null ? null : UserReadDto.fromMap(json["requesting_user"]),
        currentReviewer: json["user_decided"] == null ? null : AcceptorUserReadDto.fromMap(json["user_decided"]),
        reviewerUsers:
            json["request_accepter_users"] == null ? [] : List<AcceptorUserReadDto>.from(json["request_accepter_users"].map((final x) => AcceptorUserReadDto.fromMap(x))),
        categoryType: RequestCategoryType.values.firstWhereOrNull((final e) => e.name == json["main_category"]) ?? RequestCategoryType.welfare_financial,
        description: json["description"],
        status: json["status"] == null ? null : StatusType.values.firstWhereOrNull((final e) => e.name == json["status"]),
        welfareType: WelfareType.values.firstWhereOrNull((final e) => e.name == json["subcategory"]) ?? WelfareType.loan_advance,
        requestTypeFinancial: json["loan_advance_type"] == null ? null : LoanType.values.firstWhereOrNull((final e) => e.name == json["loan_advance_type"]),
        amount: json["requested_amount"] ?? json["treatment_cost_amount"] ?? json["requested_allowance_amount"],
        date: json["required_payment_date"] ?? json["coverage_start_date"],
        bankAccountNumber: json["bank_account_number"],
        repaymentMethod: json["repayment_conditions"] == null ? null : RepaymentType.values.firstWhereOrNull((final e) => e.name == json["repayment_conditions"]),
        insuranceRequestType:
            json["insurance_request_type"] == null ? null : InsuranceRequestType.values.firstWhereOrNull((final e) => e.name == json["insurance_request_type"]),
        coveredPersonDetails: _extractCoveredPersonDetails(json["covered_people"]),
        allowanceType: json["allowance_type"] == null ? null : AllowanceType.values.firstWhereOrNull((final e) => e.name == json["allowance_type"]),
        allowancePeriod: json["allowance_period"] == null ? null : AllowancePeriod.values.firstWhereOrNull((final e) => e.name == json["allowance_period"]),
        files: _extractFiles(json),
      );

  static String? _extractCoveredPersonDetails(final dynamic coveredPeople) {
    if (coveredPeople is Map<String, dynamic> && coveredPeople["text"] != null) {
      return coveredPeople["text"];
    }
    return null;
  }

  static List<MainFileReadDto>? _extractFiles(final Map<String, dynamic> json) {
    if (json["guarantee_documents"] != null && json["guarantee_documents"] != []) {
      return List<MainFileReadDto>.from(json["guarantee_documents"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    if (json["medical_documents"] != null && json["medical_documents"] != []) {
      return List<MainFileReadDto>.from(json["medical_documents"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    if (json["allowance_documents"] != null && json["allowance_documents"] != []) {
      return List<MainFileReadDto>.from(json["allowance_documents"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    if (json["welfare_documents"] != null && json["welfare_documents"] != []) {
      return List<MainFileReadDto>.from(json["welfare_documents"].map((final x) => MainFileReadDto.fromMap(x)));
    }
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    final fileIds = files?.map((final file) => file.fileId).whereType<int>().toList();

    switch (welfareType) {
      case WelfareType.loan_advance:
        return {
          ...baseMap,
          'subcategory': welfareType.name,
          'loan_advance_type': requestTypeFinancial?.name,
          'requested_amount': amount,
          'required_payment_date': date,
          'bank_account_number': bankAccountNumber,
          'repayment_conditions': repaymentMethod?.name,
          'guarantee_document_id_list': fileIds,
        };

      case WelfareType.supplementary_insurance:
        return {
          ...baseMap,
          'subcategory': welfareType.name,
          'insurance_request_type': insuranceRequestType?.name,
          'coverage_start_date': date,
          'covered_people': {"text": coveredPersonDetails},
          'treatment_cost_amount': amount,
          'medical_document_id_list': fileIds,
        };

      case WelfareType.allowances:
        return {
          ...baseMap,
          'subcategory': welfareType.name,
          'allowance_type': allowanceType?.name,
          'allowance_period': allowancePeriod?.name,
          'requested_allowance_amount': amount,
          'allowance_document_id_list': fileIds,
        };

      case WelfareType.other_welfare_services:
        return {
          ...baseMap,
          'subcategory': welfareType.name,
          'welfare_document_id_list': fileIds,
        };
    }
  }
}

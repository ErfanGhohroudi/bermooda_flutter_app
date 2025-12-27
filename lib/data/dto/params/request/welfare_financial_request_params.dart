part of '../../../data.dart';

/// Welfare and Financial Request Parameters
class WelfareFinancialRequestParams extends BaseRequestParams {
  const WelfareFinancialRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.welfareType,
    this.requestTypeFinancial,
    this.date,
    this.amount,
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

  @override
  String toJson() => json.encode(toMap()).englishNumber();

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

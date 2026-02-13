import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';

class SellerInformationData {
  SellerInformationData({
    required this.fullnameOrCompanyName,
    required this.phoneNumber,
    required this.address,
    this.email,
    this.nationalCode,
    this.economicCode,
    this.state,
    this.city,
  });

  final String fullnameOrCompanyName;
  final String phoneNumber;
  final String address;
  final String? email;
  final String? nationalCode;
  final String? economicCode;
  final int? state;
  final int? city;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'fullname_or_company_name': fullnameOrCompanyName,
    'phone_number': phoneNumber,
    'address': address,
    if (email != null) 'email': email,
    if (nationalCode != null) 'national_code': nationalCode,
    if (economicCode != null) 'economic_code': economicCode,
    if (state != null) 'state': state,
    if (city != null) 'city': city,
  };
}

class InvoiceProductParams {
  InvoiceProductParams({
    required this.title,
    required this.count,
    required this.price,
    this.discount,
    this.code,
    this.unit,
  });

  final String title;
  final int count;
  final String price;
  final String? discount;
  final String? code;
  final String? unit;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'count': count,
    'price': price,
    if (discount != null) 'discount': discount,
    if (code != null) 'code': code,
    if (unit != null) 'unit': unit,
  };
}

// Installment
class InstallmentParams {
  InstallmentParams({
    required this.dateToPay,
    required this.totalAmount,
  });

  final Jalali dateToPay;
  final Decimal totalAmount;

  InstallmentParams copyWith({
    final Jalali? dateToPay,
    final Decimal? totalAmount,
  }) => InstallmentParams(
    dateToPay: dateToPay ?? this.dateToPay,
    totalAmount: totalAmount ?? this.totalAmount,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'date_to_pay': dateToPay.formatCompactDate(),
    'price': totalAmount.toStringAsFixed(0),
  };
}

class UpdateInvoiceInfoCustomerDataParams {
  UpdateInvoiceInfoCustomerDataParams({
    required this.fullnameOrCompanyName,
    required this.phoneNumber,
    required this.nationalCode,
    required this.economicCode,
    required this.address,
    this.cityId,
    this.stateId,
  });

  final String fullnameOrCompanyName;
  final String phoneNumber;
  final String nationalCode;
  final String? economicCode;
  final int? cityId;
  final int? stateId;
  final String address;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'fullname_or_company_name': fullnameOrCompanyName,
    'phone_number': phoneNumber,
    'national_code': nationalCode,
    'economic_code': economicCode,
    if (cityId != null) 'city_id': cityId,
    if (stateId != null) 'state_id': stateId,
    'address': address,
  };
}

class UpdateInvoiceInfoWorkspaceDataParams {
  UpdateInvoiceInfoWorkspaceDataParams({
    required this.fullname,
    required this.normalizedPersonalType,
    required this.registrationNumber,
    required this.nationalCode,
    required this.email,
    required this.postalCode,
    required this.phoneNumber,
    required this.faxNumber,
    required this.economicNumber,
    required this.address,
    this.cityId,
    this.stateId,
    required this.shebaNumber,
  });

  final String fullname;
  final AuthenticationType normalizedPersonalType;
  final String registrationNumber;
  final String nationalCode;
  final String email;
  final String postalCode;
  final String phoneNumber;
  final String faxNumber;
  final String economicNumber;
  final String address;
  final int? cityId;
  final int? stateId;
  final String shebaNumber;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'fullname': fullname,
    'normalized_personal_type': normalizedPersonalType.name,
    if (normalizedPersonalType == AuthenticationType.legal) 'registration_number': registrationNumber,
    'national_code': nationalCode,
    'email': email,
    'postal_code': postalCode,
    'phone_number': phoneNumber,
    'fax_number': faxNumber,
    if (normalizedPersonalType == AuthenticationType.legal) 'economic_number': economicNumber,
    'address': address,
    if (cityId != null) 'city_id': cityId,
    if (stateId != null) 'state_id': stateId,
    'shaba_number': shebaNumber,
  };
}

class UpdateInvoiceInfoParams {
  UpdateInvoiceInfoParams({
    required this.customerData,
    this.workspaceData,
  });

  final UpdateInvoiceInfoCustomerDataParams customerData;
  final UpdateInvoiceInfoWorkspaceDataParams? workspaceData;

  String toJson() => json.encode(removeNullEntries(toMap())!).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'customer_data': customerData.toMap(),
    if (workspaceData != null) 'workspace_data': workspaceData!.toMap(),
  };
}

class InvoiceParams {
  InvoiceParams({
    required this.customerId,
    required this.invoiceType,
    required this.paymentType,
    required this.invoiceCode,
    required this.productList,
    required this.createdDate,
    this.validityDate,
    this.signatureId,
    // this.dateToPayJalali,
    this.description,
    this.discount,
    this.taxes,
    this.shipping = false,
    this.shippingCost,
    this.interestPercentage,
    this.installmentPayments,
    this.latePenaltyEnabled,
    this.latePenaltyRate,
    this.latePenaltyCap,
  });

  final int customerId;
  final InvoiceType? invoiceType;
  final PaymentTerms? paymentType;
  final String invoiceCode;
  final List<InvoiceProductParams> productList;
  final String createdDate;
  final String? validityDate;
  final int? signatureId;

  // final String? dateToPayJalali;
  final String? description;
  final int? discount;
  final int? taxes;
  final bool shipping;
  final int? shippingCost;
  final int? interestPercentage;
  final List<InstallmentParams>? installmentPayments;
  final bool? latePenaltyEnabled;
  final int? latePenaltyRate;
  final String? latePenaltyCap;

  String toJson() => json.encode(removeNullEntries(toMap())!).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'customer_id': customerId,
    'invoice_type': invoiceType?.name,
    'payment_type': paymentType?.name,
    'invoice_code': invoiceCode,
    'product_list': productList.map((final e) => e.toMap()).toList(),
    'created_date': createdDate,
    if (validityDate != null) 'validity_date': validityDate,
    if (signatureId != null) 'signature_id': signatureId,
    // if (dateToPayJalali != null) 'date_to_pay_jalali': dateToPayJalali,
    if (description != null && description!.isNotEmpty) 'description': description,
    if (discount != null) 'discount': discount,
    if (taxes != null) 'taxes': taxes,
    if (shipping && shippingCost != null) 'shipping_cost': shippingCost,
    if (installmentPayments != null && installmentPayments!.isNotEmpty) ...{
      'installment_payments': installmentPayments!.map((final e) => e.toMap()).toList(),
      if (interestPercentage != null) 'interest_percentage': interestPercentage,
      if (latePenaltyEnabled != null) 'late_penalty_enabled': latePenaltyEnabled,
      if (latePenaltyEnabled != null && latePenaltyRate != null) 'late_penalty_rate': latePenaltyRate,
      if (latePenaltyEnabled != null && latePenaltyCap != null) 'late_penalty_cap': latePenaltyCap,
    },
  };
}

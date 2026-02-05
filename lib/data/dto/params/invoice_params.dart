part of '../../data.dart';

class SellerInformationData {
  SellerInformationData({
    required this.fullnameOrCompanyName,
    required this.phoneNumber,
    required this.address,
    this.state,
    this.city,
  });

  final String fullnameOrCompanyName;
  final String phoneNumber;
  final int? state;
  final int? city;
  final String address;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'fullname_or_company_name': fullnameOrCompanyName,
    'phone_number': phoneNumber,
    'state': state,
    'city': city,
    'address': address,
  };
}

class InvoiceProductItem {
  InvoiceProductItem({
    required this.title,
    required this.count,
    required this.price,
    this.code,
    this.unit,
  });

  final String title;
  final int count;
  final String price;
  final String? code;
  final String? unit;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'count': count,
    'price': price,
    if (code != null) 'code': code,
    if (unit != null) 'unit': unit,
  };
}

// Installment
class InstallmentResult {
  InstallmentResult({
    required this.dateToPay,
    required this.principalAmount,
    required this.profitAmount,
  });

  final Jalali dateToPay;

  /// اصل این قسط
  final Decimal principalAmount;

  /// سود این قسط (تخصیص‌یافته از سود کل مرابحه)
  final Decimal profitAmount;

  Decimal get totalAmount => profitAmount + principalAmount;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'date_to_pay': dateToPay.formatCompactDate(),
    'price': principalAmount.toStringAsFixed(0),
  };
}

class UpdateInvoiceInfoCustomerData {
  UpdateInvoiceInfoCustomerData({
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
  final String economicCode;
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

class UpdateInvoiceInfoWorkspaceData {
  UpdateInvoiceInfoWorkspaceData({
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

  final UpdateInvoiceInfoCustomerData customerData;
  final UpdateInvoiceInfoWorkspaceData? workspaceData;

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
    this.sellerInformationData,
    this.validityDate,
    this.dateToPayJalali,
    this.description,
    this.discount,
    this.taxes,
    this.interestPercentage,
    this.installmentPayments,
  });

  final int customerId;
  final InvoiceType? invoiceType;
  final PaymentTerms? paymentType;
  final String invoiceCode;
  final SellerInformationData? sellerInformationData;
  final List<InvoiceProductItem> productList;
  final String createdDate;
  final String? validityDate;
  final String? dateToPayJalali;
  final String? description;
  final int? discount;
  final int? taxes;
  final int? interestPercentage;
  final List<InstallmentResult>? installmentPayments;

  String toJson() => json.encode(removeNullEntries(toMap())!).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'customer_id': customerId,
    'invoice_type': invoiceType?.name,
    'payment_type': paymentType?.name,
    'invoice_code': invoiceCode,
    if (sellerInformationData != null) 'seller_information_data': sellerInformationData!.toMap(),
    'product_list': productList.map((final e) => e.toMap()).toList(),
    'created_date': createdDate,
    if (validityDate != null) 'validity_date': validityDate,
    if (dateToPayJalali != null) 'date_to_pay_jalali': dateToPayJalali,
    if (description != null && description!.isNotEmpty) 'description': description,
    if (discount != null) 'discount': discount,
    if (taxes != null) 'taxes': taxes,
    if (interestPercentage != null) 'interest_percentage': interestPercentage,
    if (installmentPayments != null && installmentPayments!.isNotEmpty)
      'installment_payments': installmentPayments!.map((final e) => e.toMap()).toList(),
  };
}

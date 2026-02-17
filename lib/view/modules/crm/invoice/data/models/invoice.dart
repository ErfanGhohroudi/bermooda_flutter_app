import 'package:decimal/decimal.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../../domain/enums/verify_status.dart';

class InvoiceReadDto {
  final int? id;
  final String? mainId;
  final InvoiceType? invoiceType;
  final PaymentTerms? paymentType;
  final String? status;
  final String? preInvoiceStatus;
  final bool? isPaid;
  final String? invoiceCode;
  final ErInformation? sellerInformation;
  final ErInformation? buyerInformation;
  final List<Product>? products;
  final FactorPrice? factorPrice;
  final String? invoiceUrl;
  final String? validityDatePersian;
  final bool? isOver;
  final bool? isSuspended;
  final DateTime? suspendedAt;
  final String? suspendedReason;
  final List<Installment>? installments;
  final MainFileReadDto? qrCode;
  final MainFileReadDto? signatureBuyerUrl;
  final String? description;
  final int? discount;
  final int? taxes;
  final int? shippingCost;
  final DateTime? created;
  final String? invoiceDate;
  final int? interestPercentage;
  final MainFileReadDto? signatureFile;
  final bool? latePenaltyEnabled;
  final String? latePenaltyRate;
  final String? latePenaltyCap;
  final PaymentRecord? paymentRecord;
  final MainFileReadDto? logoFile;

  const InvoiceReadDto({
    this.id,
    this.mainId,
    this.status,
    this.preInvoiceStatus,
    this.invoiceType,
    this.qrCode,
    this.isPaid,
    this.paymentType,
    this.sellerInformation,
    this.buyerInformation,
    this.products,
    this.signatureBuyerUrl,
    this.description,
    this.discount,
    this.taxes,
    this.shippingCost,
    this.created,
    this.invoiceCode,
    this.factorPrice,
    this.invoiceUrl,
    this.invoiceDate,
    this.installments,
    this.interestPercentage,
    this.validityDatePersian,
    this.isOver,
    this.isSuspended,
    this.suspendedAt,
    this.suspendedReason,
    this.signatureFile,
    this.latePenaltyEnabled,
    this.latePenaltyRate,
    this.latePenaltyCap,
    this.paymentRecord,
    this.logoFile,
  });

  factory InvoiceReadDto.fromJson(final String str) => InvoiceReadDto.fromMap(json.decode(str));

  factory InvoiceReadDto.fromMap(final Map<String, dynamic> json) => InvoiceReadDto(
    id: json["id"],
    mainId: json["main_id"],
    invoiceType: InvoiceType.fromString(json["invoice_type"]),
    status: json["current_status"],
    preInvoiceStatus: json["preinvoice_status"],
    qrCode: json["qr_code"] == null ? null : MainFileReadDto.fromMap(json["qr_code"]),
    isPaid: json["is_paid"],
    paymentType: json["payment_type"] == null
        ? null
        : PaymentTerms.values.firstWhereOrNull((final element) => element.name == json["payment_type"]!),
    sellerInformation: json["seller_information"] == null ? null : ErInformation.fromJson(json["seller_information"]!),
    buyerInformation: json["buyer_information"] == null ? null : ErInformation.fromJson(json["buyer_information"]),
    products: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((final x) => Product.fromJson(x))),
    signatureBuyerUrl: json["signature_buyer_url"] == null ? null : MainFileReadDto.fromMap(json["signature_buyer_url"]!),
    description: json["description"],
    discount: json["discount"],
    taxes: json["taxes"],
    shippingCost: json["shipping_cost"]?.toInt(),
    created: json["created"] == null ? null : DateTime.tryParse(json["created"]!),
    invoiceCode: json["invoice_code"],
    factorPrice: json["factor_price"] == null ? null : FactorPrice.fromJson(json["factor_price"]!),
    invoiceUrl: json["invoice_url"],
    invoiceDate: json["invoice_date"],
    installments: json["installments"] == null
        ? null
        : List<Installment>.from(json["installments"]!.map((final x) => Installment.fromJson(x))),
    interestPercentage: json["interest_percentage"],
    validityDatePersian: json["validity_date_persian"],
    isOver: json["is_over"],
    isSuspended: json["is_suspended"],
    suspendedAt: json["suspended_at"] == null ? null : DateTime.tryParse(json["suspended_at"]!),
    suspendedReason: json["suspended_reason"],
    signatureFile: json["signature_file"] == null ? null : MainFileReadDto.fromMap(json["signature_file"]!),
    latePenaltyEnabled: json["late_penalty_enabled"],
    latePenaltyRate: json["late_penalty_rate"],
    latePenaltyCap: json["late_penalty_cap"],
    paymentRecord: json["payment_record"] == null ? null : PaymentRecord.fromJson(json["payment_record"]!),
    logoFile: json["logo_file"] == null ? null : MainFileReadDto.fromMap(json["logo_file"]!),
  );
}

class Installment {
  int? id;
  String? price;
  DateTime? dateToPay;
  int? invoice;
  bool? isPaid;
  DateTime? datePayed;
  bool? isDelayed;
  List<MainFileReadDto>? documentOfPayment;
  PaymentRecord? paymentRecord;
  int? daysPassed;
  String? createdPersian;
  String? dateToPayPersian;
  String? datePayedPersian;

  Installment({
    this.id,
    this.price,
    this.dateToPay,
    this.invoice,
    this.isPaid,
    this.datePayed,
    this.isDelayed,
    this.documentOfPayment,
    this.paymentRecord,
    this.daysPassed,
    this.createdPersian,
    this.dateToPayPersian,
    this.datePayedPersian,
  });

  factory Installment.fromRawJson(final String str) => Installment.fromJson(json.decode(str));

  factory Installment.fromJson(final Map<String, dynamic> json) => Installment(
    id: json["id"],
    price: json["price"],
    dateToPay: json["date_to_pay"] == null ? null : DateTime.parse(json["date_to_pay"]),
    invoice: json["invoice"],
    isPaid: json["is_paid"],
    datePayed: json["date_payed"] == null ? null : DateTime.parse(json["date_payed"]),
    isDelayed: json["is_delayed"],
    documentOfPayment: json["document_of_payment"] == null
        ? null
        : List<MainFileReadDto>.from(json["document_of_payment"]!.map((final x) => MainFileReadDto.fromMap(x))),
    paymentRecord: json["payment_record"] == null ? null : PaymentRecord.fromJson(json["payment_record"]!),
    daysPassed: json["days_passed"] == null ? null : int.tryParse(json["days_passed"]!.toString()),
    createdPersian: json["created_persian"],
    dateToPayPersian: json["date_to_pay_persian"],
    datePayedPersian: json["date_payed_persian"],
  );
}

class PaymentRecord {
  int id;
  VerifyStatus verifyStatus;
  int? invoiceId;
  DateTime? createdAt;
  List<MainFileReadDto> paymentFiles;
  Jalali? paymentDate;
  String? paymentTime;
  String? trackingCode;
  String? description;
  Decimal? amount;
  bool verified;
  DateTime? verifiedAt;

  PaymentRecord({
    required this.id,
    required this.verifyStatus,
    this.invoiceId,
    this.createdAt,
    this.paymentFiles = const [],
    this.paymentDate,
    this.paymentTime,
    this.trackingCode,
    this.description,
    this.amount,
    this.verified = false,
    this.verifiedAt,
  });

  factory PaymentRecord.fromRawJson(final String str) => PaymentRecord.fromJson(json.decode(str));

  factory PaymentRecord.fromJson(final Map<String, dynamic> json) => PaymentRecord(
    id: json["id"] ?? 0,
    verifyStatus: VerifyStatus.fromString(json["verify_status"]),
    invoiceId: json["invoice"],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]!),
    paymentFiles: json["payment_file"] != null
        ? List<MainFileReadDto>.from(json["payment_file"]!.map((final x) => MainFileReadDto.fromMap(x)))
        : [],
    paymentDate: json["payment_date"] == null ? null : DateTime.tryParse(json["payment_date"]!)?.toJalali(),
    paymentTime: json["payment_time"],
    trackingCode: json["tracking_code"],
    description: json["description"],
    amount: json["amount"] == null ? null : Decimal.fromJson(json["amount"]!),
    verified: json["verified"] ?? false,
    verifiedAt: json["verified_at"] == null ? null : DateTime.tryParse(json["verified_at"]!),
  );
}

class ErInformation {
  String? fullnameOrCompanyName;
  String? email;
  String? address;
  int? city;
  int? state;
  String? phoneNumber;
  String? cityName;
  String? stateName;

  ErInformation({
    this.fullnameOrCompanyName,
    this.email,
    this.address,
    this.city,
    this.state,
    this.phoneNumber,
    this.cityName,
    this.stateName,
  });

  factory ErInformation.fromRawJson(final String str) => ErInformation.fromJson(json.decode(str));

  factory ErInformation.fromJson(final Map<String, dynamic> json) => ErInformation(
    fullnameOrCompanyName: json["fullname_or_company_name"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    phoneNumber: json["phone_number"],
    cityName: json["city_name"],
    stateName: json["state_name"],
  );
}

class FactorPrice {
  late final Decimal finalPrice;
  late final Decimal factorPrice;
  late final Decimal discountPrice;
  late final Decimal taxesPrice;

  FactorPrice({
    final Decimal? finalPrice,
    final Decimal? factorPrice,
    final Decimal? discountPrice,
    final Decimal? taxesPrice,
  }) {
    this.finalPrice = finalPrice ?? Decimal.zero;
    this.factorPrice = factorPrice ?? Decimal.zero;
    this.discountPrice = discountPrice ?? Decimal.zero;
    this.taxesPrice = taxesPrice ?? Decimal.zero;
  }

  factory FactorPrice.fromRawJson(final String str) => FactorPrice.fromJson(json.decode(str));

  factory FactorPrice.fromJson(final Map<String, dynamic> json) => FactorPrice(
    finalPrice: Decimal.fromJson(json["final_price"]?.toString() ?? '0'),
    factorPrice: Decimal.fromJson(json["factor_price"]?.toString() ?? '0'),
    discountPrice: Decimal.fromJson(json["discount_price"]?.toString() ?? '0'),
    taxesPrice: Decimal.fromJson(json["taxes_price"]?.toString() ?? '0'),
  );
}

class Product {
  int? id;
  String? title;
  int? count;
  String? price;
  String? discount;
  String? code;
  String? unit;

  Product({
    this.id,
    this.title,
    this.count,
    this.price,
    this.discount,
    this.code,
    this.unit,
  });

  factory Product.fromRawJson(final String str) => Product.fromJson(json.decode(str));

  factory Product.fromJson(final Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    count: json["count"],
    price: json["formated_price"],
    discount: json["discount"],
    code: json["code"],
    unit: json["unit"],
  );
}

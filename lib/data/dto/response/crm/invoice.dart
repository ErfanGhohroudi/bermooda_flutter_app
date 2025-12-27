part of '../../../data.dart';

class InvoiceReadDto {
  InvoiceStatusReadDto? status;
  InvoiceStatusType? invoiceType;
  MainFileReadDto? qrCode;
  int? id;
  String? mainId;
  MainFileReadDto? signatureUrl;
  MainFileReadDto? logoUrl;
  PaymentType? paymentType;
  ErInformation? sellerInformation;
  ErInformation? buyerInformation;
  List<Product>? product;
  MainFileReadDto? signatureBuyerUrl;
  String? description;
  int? discount;
  int? taxes;
  DateTime? created;
  String? invoiceCode;
  FactorPrice? factorPrice;
  String? invoiceDate;
  List<dynamic>? installments;
  int? interestPercentage;
  String? createdDatePersian;
  String? validityDatePersian;
  bool? isOver;
  String? signatureFile;
  String? logoFile;

  InvoiceReadDto({
    this.status,
    this.invoiceType,
    this.qrCode,
    this.id,
    this.mainId,
    this.signatureUrl,
    this.logoUrl,
    this.paymentType,
    this.sellerInformation,
    this.buyerInformation,
    this.product,
    this.signatureBuyerUrl,
    this.description,
    this.discount,
    this.taxes,
    this.created,
    this.invoiceCode,
    this.factorPrice,
    this.invoiceDate,
    this.installments,
    this.interestPercentage,
    this.createdDatePersian,
    this.validityDatePersian,
    this.isOver,
    this.signatureFile,
    this.logoFile,
  });

  factory InvoiceReadDto.fromJson(final String str) => InvoiceReadDto.fromMap(json.decode(str));

  factory InvoiceReadDto.fromMap(final Map<String, dynamic> json) => InvoiceReadDto(
        status: json["status"] == null ? null : InvoiceStatusReadDto.fromMap(json["status"]),
        invoiceType: json["invoice_type"] == null ? null : InvoiceStatusType.values.firstWhereOrNull((final element) => element.name == json["invoice_type"]),
        qrCode: json["qr_code"] == null ? null : MainFileReadDto.fromMap(json["qr_code"]),
        id: json["id"],
        mainId: json["main_id"],
        signatureUrl: json["signature_url"] == null ? null : MainFileReadDto.fromMap(json["signature_url"]),
        logoUrl: json["logo_url"] == null ? null : MainFileReadDto.fromMap(json["logo_url"]),
        paymentType: json["payment_type"] == null ? null : PaymentType.values.firstWhereOrNull((final element) => element.name == json["payment_type"]),
        sellerInformation: json["seller_information"] == null ? null : ErInformation.fromJson(json["seller_information"]),
        buyerInformation: json["buyer_information"] == null ? null : ErInformation.fromJson(json["buyer_information"]),
        product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((final x) => Product.fromJson(x))),
        signatureBuyerUrl: json["signature_buyer_url"] == null ? null : MainFileReadDto.fromMap(json["signature_buyer_url"]),
        description: json["description"],
        discount: json["discount"],
        taxes: json["taxes"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        invoiceCode: json["invoice_code"],
        factorPrice: json["factor_price"] == null ? null : FactorPrice.fromJson(json["factor_price"]),
        invoiceDate: json["invoice_date"],
        installments: json["installments"] == null ? [] : List<dynamic>.from(json["installments"]!.map((final x) => x)),
        interestPercentage: json["interest_percentage"],
        createdDatePersian: json["created_date_persian"],
        validityDatePersian: json["validity_date_persian"],
        isOver: json["is_over"],
        signatureFile: json["signature_file"],
        logoFile: json["logo_file"],
      );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => <String, dynamic>{
        "status": status?.toMap(),
        "invoice_type": invoiceType?.name,
        "qr_code": qrCode?.toMap(),
        "id": id,
        "main_id": mainId,
        "signature_url": signatureUrl?.toMap(),
        "logo_url": logoUrl?.toMap(),
        "payment_type": paymentType?.name,
        "seller_information": sellerInformation?.toJson(),
        "buyer_information": buyerInformation?.toJson(),
        "product": product == null ? [] : List<dynamic>.from(product!.map((final x) => x.toJson())),
        "signature_buyer_url": signatureBuyerUrl?.toJson(),
        "description": description,
        "discount": discount,
        "taxes": taxes,
        "created": "${created!.year.toString().padLeft(4, '0')}-${created!.month.toString().padLeft(2, '0')}-${created!.day.toString().padLeft(2, '0')}",
        "invoice_code": invoiceCode,
        "factor_price": factorPrice?.toJson(),
        "invoice_date": invoiceDate,
        "installments": installments == null ? [] : List<dynamic>.from(installments!.map((final x) => x)),
        "interest_percentage": interestPercentage,
        "created_date_persian": createdDatePersian,
        "validity_date_persian": validityDatePersian,
        "is_over": isOver,
        "signature_file": signatureFile,
        "logo_file": logoFile,
      };
}

class InvoiceStatusReadDto {
  int id;
  String title;
  String colorCode;

  InvoiceStatusReadDto({
    required this.id,
    required this.title,
    required this.colorCode,
  });

  factory InvoiceStatusReadDto.fromJson(final String str) => InvoiceStatusReadDto.fromMap(json.decode(str));

  factory InvoiceStatusReadDto.fromMap(final Map<String, dynamic> json) => InvoiceStatusReadDto(
        id: json['id'],
        title: json['title'],
        colorCode: json['color_code'],
      );

  String toJson() => json.encode(removeNullEntries(toMap()));

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'color_code': colorCode,
      };
}

class Installment {
  int? id;
  String? price;
  DateTime? dateToPay;
  int? invoice;
  bool? isPaid;
  DateTime? datePayed;
  bool? isDelayed;
  MainFileReadDto? documentOfPayment;
  dynamic daysPassed;
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
    this.daysPassed,
    this.createdPersian,
    this.dateToPayPersian,
    this.datePayedPersian,
  });

  factory Installment.fromRawJson(final String str) => Installment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Installment.fromJson(final Map<String, dynamic> json) => Installment(
        id: json["id"],
        price: json["price"],
        dateToPay: json["date_to_pay"] == null ? null : DateTime.parse(json["date_to_pay"]),
        invoice: json["invoice"],
        isPaid: json["is_paid"],
        datePayed: json["date_payed"] == null ? null : DateTime.parse(json["date_payed"]),
        isDelayed: json["is_delayed"],
        documentOfPayment: json["document_of_payment"] == null ? null : MainFileReadDto.fromMap(json["document_of_payment"]),
        daysPassed: json["days_passed"],
        createdPersian: json["created_persian"],
        dateToPayPersian: json["date_to_pay_persian"],
        datePayedPersian: json["date_payed_persian"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "date_to_pay": "${dateToPay!.year.toString().padLeft(4, '0')}-${dateToPay!.month.toString().padLeft(2, '0')}-${dateToPay!.day.toString().padLeft(2, '0')}",
        "invoice": invoice,
        "is_paid": isPaid,
        "date_payed": "${datePayed!.year.toString().padLeft(4, '0')}-${datePayed!.month.toString().padLeft(2, '0')}-${datePayed!.day.toString().padLeft(2, '0')}",
        "is_delayed": isDelayed,
        "document_of_payment": documentOfPayment?.toMap(),
        "days_passed": daysPassed,
        "created_persian": createdPersian,
        "date_to_pay_persian": dateToPayPersian,
        "date_payed_persian": datePayedPersian,
      };
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

  String toRawJson() => json.encode(toJson());

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

  Map<String, dynamic> toJson() => {
        "fullname_or_company_name": fullnameOrCompanyName,
        "email": email,
        "address": address,
        "city": city,
        "state": state,
        "phone_number": phoneNumber,
        "city_name": cityName,
        "state_name": stateName,
      };
}

class FactorPrice {
  String? finalPrice;
  String? factorPrice;
  String? discountPrice;
  String? taxesPrice;

  FactorPrice({
    this.finalPrice,
    this.factorPrice,
    this.discountPrice,
    this.taxesPrice,
  });

  factory FactorPrice.fromRawJson(final String str) => FactorPrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FactorPrice.fromJson(final Map<String, dynamic> json) => FactorPrice(
        finalPrice: json["formated_final_price"],
        factorPrice: json["formated_factor_price"],
        discountPrice: json["formated_discount_price"],
        taxesPrice: json["formated_taxes_price"],
      );

  Map<String, dynamic> toJson() => {
        "formated_final_price": finalPrice,
        "formated_factor_price": factorPrice,
        "formated_discount_price": discountPrice,
        "formated_taxes_price": taxesPrice,
      };
}

class Product {
  int? id;
  String? title;
  int? count;
  String? price;
  String? code;
  String? unit;

  Product({
    this.id,
    this.title,
    this.count,
    this.price,
    this.code,
    this.unit,
  });

  factory Product.fromRawJson(final String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(final Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        count: json["count"],
        price: json["formated_price"],
        code: json["code"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "count": count,
        "formated_price": price,
        "code": code,
        "unit": unit,
      };
}

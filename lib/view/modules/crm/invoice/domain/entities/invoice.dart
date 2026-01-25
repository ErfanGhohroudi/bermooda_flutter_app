import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';

/// Domain Entity for Invoice Product
class InvoiceProduct extends Equatable {
  const InvoiceProduct({
    required this.id,
    required this.title,
    required this.count,
    required this.price,
    this.code,
    this.unit,
  });

  final int id;
  final String title;
  final int count;
  final String price;
  final String? code;
  final String? unit;

  @override
  List<Object?> get props => [id, title, count, price, code, unit];
}

/// Domain Entity for Invoice Status
class InvoiceStatusEntity extends Equatable {
  const InvoiceStatusEntity({
    required this.id,
    required this.title,
    required this.colorCode,
  });

  final int id;
  final String title;
  final String colorCode;

  @override
  List<Object?> get props => [id, title, colorCode];
}

/// Domain Entity for Installment
class InstallmentEntity extends Equatable {
  const InstallmentEntity({
    required this.id,
    required this.price,
    required this.dateToPayPersian,
    required this.isPaid,
    this.datePayedPersian,
    this.documentOfPayment,
    this.order,
  });

  final int id;
  final String price;
  final String dateToPayPersian;
  final bool isPaid;
  final String? datePayedPersian;
  final MainFileReadDto? documentOfPayment;
  final int? order;

  @override
  List<Object?> get props => [id, price, dateToPayPersian, isPaid, datePayedPersian, documentOfPayment, order];
}

/// Domain Entity for Invoice
class InvoiceEntity extends Equatable {
  const InvoiceEntity({
    required this.id,
    required this.mainId,
    required this.invoiceCode,
    required this.invoiceType,
    required this.paymentType,
    required this.products,
    required this.createdDatePersian,
    this.status,
    this.buyerInformation,
    this.sellerInformation,
    this.discount,
    this.taxes,
    this.factorPrice,
    this.validityDatePersian,
    this.dateToPayPersian,
    this.datePayedPersian,
    this.description,
    this.installments,
    this.interestPercentage,
    this.signatureFile,
    this.logoFile,
    this.qrCode,
    this.isPaid,
  });

  final int id;
  final String mainId;
  final String invoiceCode;
  final InvoiceType invoiceType;
  final PaymentType paymentType;
  final List<InvoiceProduct> products;
  final String createdDatePersian;
  final InvoiceStatusEntity? status;
  final ErInformation? buyerInformation;
  final ErInformation? sellerInformation;
  final int? discount;
  final int? taxes;
  final FactorPrice? factorPrice;
  final String? validityDatePersian;
  final String? dateToPayPersian;
  final String? datePayedPersian;
  final String? description;
  final List<InstallmentEntity>? installments;
  final int? interestPercentage;
  final String? signatureFile;
  final String? logoFile;
  final MainFileReadDto? qrCode;
  final bool? isPaid;

  factory InvoiceEntity.fromDto(final InvoiceReadDto dto) =>
      InvoiceEntity(
        id: dto.id ?? 0,
        mainId: dto.mainId ?? '',
        invoiceCode: dto.invoiceCode ?? '',
        invoiceType: dto.invoiceType ?? InvoiceType.preinvoice,
        paymentType: dto.paymentType ?? PaymentType.cash,
        products: (dto.product ?? []).map((final p) => InvoiceProduct(
          id: p.id ?? 0,
          title: p.title ?? '',
          count: p.count ?? 0,
          price: p.price ?? '',
          code: p.code,
          unit: p.unit,
        )).toList(),
        createdDatePersian: dto.createdDatePersian ?? '',
        status: dto.status != null
            ? InvoiceStatusEntity(
          id: dto.status!.id,
          title: dto.status!.title,
          colorCode: dto.status!.colorCode,
        )
            : null,
        buyerInformation: dto.buyerInformation,
        sellerInformation: dto.sellerInformation,
        discount: dto.discount,
        taxes: dto.taxes,
        factorPrice: dto.factorPrice,
        validityDatePersian: dto.validityDatePersian,
        description: dto.description,
        installments: dto.installments != null
            ? (dto.installments as List).map((final i) {
          if (i is Map<String, dynamic>) {
            final installment = Installment.fromJson(i);
            return InstallmentEntity(
              id: installment.id ?? 0,
              price: installment.price ?? '',
              dateToPayPersian: installment.dateToPayPersian ?? '',
              isPaid: installment.isPaid ?? false,
              datePayedPersian: installment.datePayedPersian,
              documentOfPayment: installment.documentOfPayment,
            );
          }
          return null;
        }).whereType<InstallmentEntity>().toList()
            : null,
        interestPercentage: dto.interestPercentage,
        signatureFile: dto.signatureFile,
        logoFile: dto.logoFile,
        qrCode: dto.qrCode,
        isPaid: dto.installments != null
            ? (dto.installments as List).every((final i) {
          if (i is Map<String, dynamic>) {
            final installment = Installment.fromJson(i);
            return installment.isPaid ?? false;
          }
          return false;
        })
            : null,
      );

  @override
  List<Object?> get props =>
      [
        id,
        mainId,
        invoiceCode,
        invoiceType,
        paymentType,
        products,
        createdDatePersian,
        status,
        buyerInformation,
        sellerInformation,
        discount,
        taxes,
        factorPrice,
        validityDatePersian,
        dateToPayPersian,
        datePayedPersian,
        description,
        installments,
        interestPercentage,
        signatureFile,
        logoFile,
        qrCode,
        isPaid,
      ];
}

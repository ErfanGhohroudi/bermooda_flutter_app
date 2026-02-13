import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../data/data.dart';
import '../enums/invoice_status.dart';
import 'installment.dart';
import 'invoice_product.dart';

export 'installment.dart';
export 'invoice_product.dart';

/// Domain Entity for Invoice
class InvoiceEntity extends Equatable {
  const InvoiceEntity({
    required this.id,
    required this.mainId,
    required this.invoiceCode,
    required this.invoiceDate,
    required this.invoiceType,
    required this.paymentType,
    required this.products,
    required this.factorPrice,
    this.invoiceUrl,
    this.status,
    this.buyerInformation,
    this.sellerInformation,
    this.discountPercentage = 0,
    this.taxesPercentage = 0,
    this.shippingCost = 0,
    this.validityDatePersian,
    this.description,
    this.installments = const [],
    this.interestPercentage = 0,
    this.signatureFile,
    this.isPaid = false,
    this.isSuspended = false,
    this.isOver = false,
    this.suspendedAt,
    this.suspendedReason,
    this.latePenaltyEnabled = false,
    this.latePenaltyRate = 0,
    this.latePenaltyCap,
    this.paymentRecord,
    this.logoFile,
  });

  final int id;
  final String mainId;
  final String invoiceCode;
  final String invoiceDate;
  final InvoiceType invoiceType;
  final PaymentTerms paymentType;
  final List<InvoiceProduct> products;
  final String? invoiceUrl;
  final InvoiceStatus? status;
  final ErInformation? buyerInformation;
  final ErInformation? sellerInformation;
  final int discountPercentage;
  final int taxesPercentage;
  final int shippingCost;
  final FactorPrice factorPrice;
  final String? validityDatePersian;
  final String? description;
  final List<InstallmentEntity> installments;
  final int interestPercentage;
  final MainFileReadDto? signatureFile;
  final bool isPaid;
  final bool isSuspended;
  final bool isOver;
  final DateTime? suspendedAt;
  final String? suspendedReason;
  final bool latePenaltyEnabled;
  final int latePenaltyRate;
  final String? latePenaltyCap;
  final PaymentRecord? paymentRecord;
  final MainFileReadDto? logoFile;

  factory InvoiceEntity.fromDto(final InvoiceReadDto dto) => InvoiceEntity(
    id: dto.id ?? 0,
    mainId: dto.mainId ?? '',
    invoiceCode: dto.invoiceCode ?? '',
    invoiceDate: dto.invoiceDate ?? '',
    invoiceType: dto.invoiceType ?? InvoiceType.preinvoice,
    paymentType: dto.paymentType ?? PaymentTerms.cash,
    products: (dto.products ?? [])
        .map(
          (final Product p) => InvoiceProduct(
            id: p.id ?? 0,
            title: p.title ?? '',
            count: p.count ?? 0,
            price: p.price ?? '',
            code: p.code,
            unit: p.unit,
          ),
        )
        .toList(),
    factorPrice: dto.factorPrice ?? FactorPrice(),
    invoiceUrl: dto.invoiceUrl,
    status: dto.invoiceType == InvoiceType.finalinvoice && dto.status != null
        ? InvoiceStatus.fromString(dto.status!)
        : dto.invoiceType == InvoiceType.preinvoice && dto.preInvoiceStatus != null
        ? InvoiceStatus.fromString(dto.preInvoiceStatus!)
        : null,
    buyerInformation: dto.buyerInformation,
    sellerInformation: dto.sellerInformation,
    discountPercentage: dto.discount ?? 0,
    taxesPercentage: dto.taxes ?? 0,
    shippingCost: dto.shippingCost ?? 0,
    validityDatePersian: dto.validityDatePersian,
    description: dto.description,
    installments: (dto.installments ?? []).map((final e) => InstallmentEntity.fromDto(e)).toList(),
    interestPercentage: dto.interestPercentage ?? 0,
    signatureFile: dto.signatureFile,
    isPaid: dto.isPaid ?? false,
    isSuspended: dto.isSuspended ?? false,
    isOver: dto.isOver ?? false,
    suspendedAt: dto.suspendedAt,
    suspendedReason: dto.suspendedReason,
    latePenaltyEnabled: dto.latePenaltyEnabled ?? false,
    latePenaltyRate: int.tryParse(dto.latePenaltyRate?.split('.').firstOrNull ?? '') ?? 0,
    latePenaltyCap: dto.latePenaltyCap,
    paymentRecord: dto.paymentRecord,
    logoFile: dto.logoFile,
  );

  InvoiceEntity copyWith({
    final String? invoiceCode,
    final String? invoiceDate,
    final InvoiceType? invoiceType,
    final PaymentTerms? paymentType,
    final List<InvoiceProduct>? products,
    final String? invoiceUrl,
    final InvoiceStatus? status,
    final ErInformation? buyerInformation,
    final ErInformation? sellerInformation,
    final int? discountPercentage,
    final int? taxesPercentage,
    final int? shippingCost,
    final FactorPrice? factorPrice,
    final String? validityDatePersian,
    final String? description,
    final List<InstallmentEntity>? installments,
    final int? interestPercentage,
    final MainFileReadDto? signatureFile,
    final bool? isPaid,
    final bool? isSuspended,
    final bool? isOver,
    final DateTime? suspendedAt,
    final String? suspendedReason,
    final bool? latePenaltyEnabled,
    final int? latePenaltyRate,
    final String? latePenaltyCap,
    final PaymentRecord? paymentRecord,
    final MainFileReadDto? logoFile,
  }) => InvoiceEntity(
    id: id,
    mainId: mainId,
    invoiceCode: invoiceCode ?? this.invoiceCode,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    invoiceType: invoiceType ?? this.invoiceType,
    paymentType: paymentType ?? this.paymentType,
    products: products ?? this.products,
    invoiceUrl: invoiceUrl ?? this.invoiceUrl,
    status: status ?? this.status,
    buyerInformation: buyerInformation ?? this.buyerInformation,
    sellerInformation: sellerInformation ?? this.sellerInformation,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    taxesPercentage: taxesPercentage ?? this.taxesPercentage,
    shippingCost: shippingCost ?? this.shippingCost,
    factorPrice: factorPrice ?? this.factorPrice,
    validityDatePersian: validityDatePersian ?? this.validityDatePersian,
    description: description ?? this.description,
    installments: installments ?? this.installments,
    interestPercentage: interestPercentage ?? this.interestPercentage,
    signatureFile: signatureFile ?? this.signatureFile,
    isPaid: isPaid ?? this.isPaid,
    isSuspended: isSuspended ?? this.isSuspended,
    isOver: isOver ?? this.isOver,
    suspendedAt: suspendedAt ?? this.suspendedAt,
    suspendedReason: suspendedReason ?? this.suspendedReason,
    latePenaltyEnabled: latePenaltyEnabled ?? this.latePenaltyEnabled,
    latePenaltyRate: latePenaltyRate ?? this.latePenaltyRate,
    latePenaltyCap: latePenaltyCap ?? this.latePenaltyCap,
    paymentRecord: paymentRecord ?? this.paymentRecord,
    logoFile: logoFile ?? this.logoFile,
  );

  @override
  List<Object?> get props => [
    id,
    mainId,
    invoiceCode,
    invoiceType,
    paymentType,
    products,
    invoiceUrl,
    status,
    buyerInformation,
    sellerInformation,
    discountPercentage,
    taxesPercentage,
    shippingCost,
    factorPrice,
    validityDatePersian,
    description,
    installments,
    interestPercentage,
    signatureFile,
    isPaid,
    isSuspended,
    isOver,
    suspendedAt,
    suspendedReason,
    latePenaltyEnabled,
    latePenaltyRate,
    latePenaltyCap,
    paymentRecord,
    logoFile,
  ];
}

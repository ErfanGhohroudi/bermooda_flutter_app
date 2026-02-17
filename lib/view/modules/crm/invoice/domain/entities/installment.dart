import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:u/utils/persian_date_picker/src/material/date.dart';
import 'package:u/utils/shamsi_date/src/jalali/jalali_date.dart';

import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../data/data.dart';

/// Domain Entity for Installment
class InstallmentEntity extends Equatable {
  const InstallmentEntity({
    required this.id,
    required this.invoiceId,
    required this.price,
    required this.dateToPayPersian,
    required this.isPaid,
    required this.isDelayed,
    this.dateToPay,
    this.datePayedPersian,
    this.documentOfPayment = const [],
    this.paymentRecord,
    this.daysPassed = 0,
  });

  final int id;
  final int invoiceId;
  final Decimal price;
  final Jalali? dateToPay;
  final String dateToPayPersian;
  final bool isPaid;
  final bool isDelayed;
  final String? datePayedPersian;
  final List<MainFileReadDto> documentOfPayment;
  final PaymentRecord? paymentRecord;
  final int daysPassed;

  factory InstallmentEntity.fromDto(final Installment dto) => InstallmentEntity(
    id: dto.id ?? 0,
    invoiceId: dto.invoice ?? 0,
    price: Decimal.tryParse(dto.price ?? '') ?? Decimal.zero,
    isPaid: dto.isPaid ?? false,
    isDelayed: dto.isDelayed ?? false,
    dateToPay: dto.dateToPay?.toJalali(),
    dateToPayPersian: dto.dateToPay.toJalaliDateStringWithMonthName ?? '',
    datePayedPersian: dto.datePayed.toJalaliDateStringWithMonthName ?? '',
    documentOfPayment: dto.documentOfPayment ?? [],
    paymentRecord: dto.paymentRecord,
    daysPassed: dto.daysPassed ?? 0,
  );

  @override
  List<Object?> get props => [id, price, dateToPayPersian, isPaid, datePayedPersian, documentOfPayment, daysPassed];
}
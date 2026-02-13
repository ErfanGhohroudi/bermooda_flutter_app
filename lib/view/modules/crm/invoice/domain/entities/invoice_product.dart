import 'package:equatable/equatable.dart';

/// Domain Entity for Invoice Product
class InvoiceProduct extends Equatable {
  const InvoiceProduct({
    required this.id,
    required this.title,
    required this.count,
    required this.price,
    this.discount,
    this.code,
    this.unit,
  });

  final int id;
  final String title;
  final int count;
  final String price;
  final String? discount;
  final String? code;
  final String? unit;

  @override
  List<Object?> get props => [id, title, count, price, discount, code, unit];
}
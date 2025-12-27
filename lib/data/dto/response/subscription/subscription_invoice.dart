part of '../../../data.dart';

class SubscriptionInvoiceReadDto extends Equatable {
  const SubscriptionInvoiceReadDto({
    required this.slug,
    required this.invoiceCode,
    required this.title,
    this.paidAt,
    this.trackId,
    this.refNumber,
    this.cardNumber,
    this.description,
    this.price = 0,
    this.invoiceUrl,
  });

  final String slug;
  final String invoiceCode;
  final String title;
  final DateTime? paidAt;
  final String? trackId;
  final String? refNumber;
  final String? cardNumber;
  final String? description;
  final int price;
  final String? invoiceUrl;

  factory SubscriptionInvoiceReadDto.fromJson(final String str) => SubscriptionInvoiceReadDto.fromMap(json.decode(str));

  factory SubscriptionInvoiceReadDto.fromMap(final Map<String, dynamic> json) => SubscriptionInvoiceReadDto(
        slug: json["slug"].toString(),
        invoiceCode: json["invoice_code"],
        title: json["title"].toString(),
        paidAt: json["paid_at"] == null || json["paid_at"] is! String ? null : DateTime.tryParse(json["paid_at"]),
        trackId: json["track_id"]?.toString(),
        refNumber: json["ref_number"]?.toString(),
        cardNumber: json["card_number"]?.toString(),
        description: json["description"]?.toString(),
        price: json["price"]?.toString().numericOnly().toInt() ?? 0,
        invoiceUrl: json["invoice_url"],
      );

  // Helper methods

  @override
  List<Object?> get props => [
        slug,
        invoiceCode,
        title,
        paidAt,
        trackId,
        refNumber,
        cardNumber,
        description,
        price,
        invoiceUrl,
      ];
}

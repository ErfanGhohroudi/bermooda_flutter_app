import 'package:equatable/equatable.dart';

import '../../../../../data/data.dart';
import '../../data/models/support_section_dto.dart';

class SupportSection extends Equatable {
  const SupportSection({
    required this.id,
    required this.title,
    this.colorCode,
    this.icon,
    this.order,
  });

  final int id;
  final String title;
  final String? colorCode;
  final MainFileReadDto? icon;
  final String? order;

  factory SupportSection.fromDto(final SupportSectionReadDto dto) => SupportSection(
    id: dto.id ?? 0,
    title: dto.title ?? '',
    colorCode: dto.colorCode,
    icon: dto.icon,
    order: dto.order,
  );

  @override
  List<Object?> get props => [id];
}

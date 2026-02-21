import 'package:equatable/equatable.dart';

import '../../data/models/response/validation_numbers_result_dto.dart';

class ValidationNumbersResultEntity extends Equatable {
  final List<ValidNumberEntity> valid;
  final List<String> invalid;
  final List<String> duplicate;
  final VNCountsEntity counts;

  const ValidationNumbersResultEntity({
    this.valid = const [],
    this.invalid = const [],
    this.duplicate = const [],
    required this.counts,
  });

  factory ValidationNumbersResultEntity.fromDto(final ValidationNumbersResultReadDto dto) => ValidationNumbersResultEntity(
    valid: (dto.valid ?? []).map((final x) => ValidNumberEntity.fromDto(x)).toList(),
    invalid: dto.invalid ?? [],
    duplicate: dto.duplicate ?? [],
    counts: dto.counts != null ? VNCountsEntity.fromDto(dto.counts!) : const VNCountsEntity(),
  );

  @override
  List<Object?> get props => [
    valid,
    invalid,
    duplicate,
    counts,
  ];
}

class VNCountsEntity extends Equatable {
  final int total;
  final int valid;
  final int invalid;
  final int duplicate;

  const VNCountsEntity({
    this.total = 0,
    this.valid = 0,
    this.invalid = 0,
    this.duplicate = 0,
  });

  factory VNCountsEntity.fromDto(final VNCountsReadDto dto) => VNCountsEntity(
    total: dto.total ?? 0,
    valid: dto.valid ?? 0,
    invalid: dto.invalid ?? 0,
    duplicate: dto.duplicate ?? 0,
  );

  @override
  List<Object?> get props => [
    total,
    valid,
    invalid,
    duplicate,
  ];
}

class ValidNumberEntity {
  final String phone;
  final String? name;

  const ValidNumberEntity({
    this.phone = '',
    this.name,
  });

  factory ValidNumberEntity.fromDto(final ValidNumberReadDto dto) => ValidNumberEntity(
    phone: dto.phone ?? '',
    name: dto.name,
  );
}

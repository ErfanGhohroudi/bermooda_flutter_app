class ValidationNumbersResultReadDto {
  final List<ValidNumberReadDto>? valid;
  final List<String>? invalid;
  final List<String>? duplicate;
  final VNCountsReadDto? counts;

  const ValidationNumbersResultReadDto({
    this.valid,
    this.invalid,
    this.duplicate,
    this.counts,
  });

  factory ValidationNumbersResultReadDto.fromMap(final Map<String, dynamic> json) => ValidationNumbersResultReadDto(
    valid: json["valid"] == null
        ? null
        : List<ValidNumberReadDto>.from(json["valid"]!.map((final x) => ValidNumberReadDto.fromMap(x))),
    invalid: json["invalid"] == null ? null : List<String>.from(json["invalid"]!.map((final x) => x)),
    duplicate: json["duplicate"] == null ? null : List<String>.from(json["duplicate"]!.map((final x) => x)),
    counts: json["counts"] == null ? null : VNCountsReadDto.fromMap(json["counts"]!),
  );
}

class VNCountsReadDto {
  final int? total;
  final int? valid;
  final int? invalid;
  final int? duplicate;

  const VNCountsReadDto({
    this.total,
    this.valid,
    this.invalid,
    this.duplicate,
  });

  factory VNCountsReadDto.fromMap(final Map<String, dynamic> json) => VNCountsReadDto(
    total: json["total"],
    valid: json["valid"],
    invalid: json["invalid"],
    duplicate: json["duplicate"],
  );
}

class ValidNumberReadDto {
  final String? phone;
  final String? name;

  const ValidNumberReadDto({
    this.phone,
    this.name,
  });

  factory ValidNumberReadDto.fromMap(final Map<String, dynamic> json) => ValidNumberReadDto(
    phone: json["phone"],
    name: json["name"],
  );
}

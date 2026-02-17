class VoipNumberReadDto {
  const VoipNumberReadDto({
    this.id,
    this.number,
    this.providerName,
    this.provider,
    this.trunkId,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? number;
  final String? providerName;
  final VoipProviderReadDto? provider;
  final String? trunkId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoipNumberReadDto.fromMap(final Map<String, dynamic> json) {
    return VoipNumberReadDto(
      id: json['id'] as int?,
      providerName: json['provider_name'] as String?,
      provider: json['provider'] == null ? null : VoipProviderReadDto.fromMap(json["provider"]!),
      trunkId: json['trunk_id'] as String?,
      number: json['number'] as String?,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}

class VoipProviderReadDto {
  const VoipProviderReadDto({
    this.id,
    this.name,
    this.serviceId,
    this.isActive,
    this.extensionsCount,
    this.trunksCount,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? serviceId;
  final bool? isActive;
  final int? extensionsCount;
  final int? trunksCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoipProviderReadDto.fromMap(final Map<String, dynamic> json) {
    return VoipProviderReadDto(
      id: json['id'] as int?,
      name: json['name'] as String?,
      serviceId: json['service_id'] as String?,
      isActive: json['is_active'] as bool?,
      extensionsCount: json['extensions_count'] as int?,
      trunksCount: json['trunks_count'] as int?,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at'] as String),
    );
  }
}

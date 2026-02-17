import 'package:equatable/equatable.dart';

import '../../data/models/response/voip_number.dart';

class VoipNumber extends Equatable {
  const VoipNumber({
    required this.id,
    required this.trunkId,
    this.title,
    this.number,
    this.provider,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String trunkId;
  final String? title;
  final String? number;
  final VoipProvider? provider;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoipNumber.fromDto(final VoipNumberReadDto dto) {
    return VoipNumber(
      id: dto.id ?? 0,
      trunkId: dto.trunkId ?? '',
      title: dto.providerName,
      number: dto.number,
      provider: dto.provider != null ? VoipProvider.fromDto(dto.provider!) : null,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    trunkId,
    title,
    number,
    provider,
    createdAt,
    updatedAt,
  ];
}

class VoipProvider extends Equatable {
  const VoipProvider({
    required this.id,
    this.name,
    this.serviceId,
    this.isActive = false,
    this.extensionsCount,
    this.trunksCount,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? name;
  final String? serviceId;
  final bool isActive;
  final int? extensionsCount;
  final int? trunksCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoipProvider.fromDto(final VoipProviderReadDto dto) {
    return VoipProvider(
      id: dto.id ?? 0,
      name: dto.name,
      serviceId: dto.serviceId,
      isActive: dto.isActive ?? false,
      extensionsCount: dto.extensionsCount,
      trunksCount: dto.trunksCount,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    serviceId,
    isActive,
    extensionsCount,
    trunksCount,
    createdAt,
    updatedAt,
  ];
}

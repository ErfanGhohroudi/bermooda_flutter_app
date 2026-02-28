import 'package:equatable/equatable.dart';
import '../../data/models/support_customer_dto.dart';
import 'support_room_entity.dart';

class SupportCustomer extends Equatable {
  final int id;
  final String? fullName;
  final String? phoneNumber;
  final List<SupportRoomEntity> rooms;

  const SupportCustomer({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.rooms = const [],
  });

  factory SupportCustomer.fromDto(final SupportCustomerReadDto dto) {
    return SupportCustomer(
      id: dto.id ?? 0,
      fullName: dto.fullName,
      phoneNumber: dto.phoneNumber,
      rooms: dto.rooms?.map((final room) => SupportRoomEntity.fromDto(room)).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    phoneNumber,
    rooms,
  ];
}

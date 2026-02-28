import 'support_room_dto.dart';

class SupportCustomerReadDto {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final List<SupportRoomReadDto>? rooms;

  const SupportCustomerReadDto({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.rooms,
  });

  factory SupportCustomerReadDto.fromMap(final Map<String, dynamic> json) {
    return SupportCustomerReadDto(
      id: json['id'],
      fullName: json['fullname'],
      phoneNumber: json['phone_number'],
      rooms: json['rooms'] == null
          ? null
          : List<SupportRoomReadDto>.from(json['rooms']!.map((final x) => SupportRoomReadDto.fromMap(x))),
    );
  }
}

part of '../../../data.dart';

class ContractReadDto extends Equatable {
  const ContractReadDto({
    required this.id,
    this.title,
    this.contractNumber,
    this.status = ContractStatus.pending,
    this.expireDate,
    this.file,
    this.creatorDetail,
    this.signers = const [],
    this.hasAnySignerSigned = false,
  });

  final int id;
  final String? title;
  final String? contractNumber;
  final ContractStatus status;
  final Jalali? expireDate;
  final MainFileReadDto? file;
  final UserReadDto? creatorDetail;
  final List<SignerDto> signers;
  final bool hasAnySignerSigned;

  ContractReadDto copyWith({
    final String? title,
    final String? contractNumber,
    final String? firstParty,
    final String? secondParty,
    final ContractStatus? status,
    final Jalali? expireDate,
    final MainFileReadDto? file,
    final UserReadDto? creatorDetail,
    final List<SignerDto>? signers,
    final bool? hasAnySignerSigned,
  }) {
    return ContractReadDto(
      id: id,
      title: title ?? this.title,
      contractNumber: contractNumber ?? this.contractNumber,
      status: status ?? this.status,
      expireDate: expireDate ?? this.expireDate,
      file: file ?? this.file,
      creatorDetail: creatorDetail ?? this.creatorDetail,
      signers: signers ?? this.signers,
      hasAnySignerSigned: hasAnySignerSigned ?? this.hasAnySignerSigned,
    );
  }

  factory ContractReadDto.fromJson(final String str) => ContractReadDto.fromMap(json.decode(str));

  factory ContractReadDto.fromMap(final Map<String, dynamic> json) => ContractReadDto(
    id: json['id'] as int,
    title: json["title"],
    contractNumber: json["contract_number"],
    status: ContractStatus.fromString(json["status"], defaultValue: ContractStatus.pending) ?? ContractStatus.pending,
    expireDate: json["expire_date"] == null ? null : DateTime.tryParse(json["expire_date"])?.toJalali(),
    file: json["file_url"] != null ? MainFileReadDto.fromMap(json) : null,
    creatorDetail: json["creator_detail"] == null ? null : UserReadDto.fromMap(json["creator_detail"]),
    signers: json["signers"] == null
        ? []
        : List<SignerDto>.from((json["signers"] as List).map((final x) => SignerDto.fromMap(x))),
    hasAnySignerSigned: (json["has_user_sign"] as bool?) ?? false,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    contractNumber,
    status,
    expireDate,
    file,
    creatorDetail,
    signers,
    hasAnySignerSigned,
  ];
}

class SignerDto extends Equatable {
  const SignerDto({
    required this.id,
    this.name = '',
    this.family = '',
    this.fullName = '',
    this.mobile = '',
    this.email,
    this.nationalId,
    this.isSigned = false,
  });

  final int id;
  final String name;
  final String family;
  final String fullName;
  final String mobile;
  final String? email;
  final String? nationalId;
  final bool isSigned;

  SignerDto copyWith({
    final String? name,
    final String? family,
    final String? fullName,
    final String? mobile,
    final String? email,
    final String? nationalId,
    final bool? isSigned,
  }) {
    return SignerDto(
      id: id,
      name: name ?? this.name,
      family: family ?? this.family,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      isSigned: isSigned ?? this.isSigned,
    );
  }

  factory SignerDto.fromMap(final Map<String, dynamic> json) => SignerDto(
    id: json['id'] as int,
    name: json["name"] as String? ?? '',
    family: json["family"] as String? ?? '',
    fullName: json["full_name"] as String? ?? '',
    mobile: json["mobile"] as String? ?? '',
    email: json["email"],
    nationalId: json["national_code"],
    isSigned: (json["is_signed"] as bool?) ?? false,
  );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "family": family,
      "full_name": fullName,
      "mobile": mobile,
      "email": email,
      "national_code": nationalId,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    family,
    fullName,
    mobile,
    email,
    nationalId,
    isSigned,
  ];
}

part of '../../../data.dart';

enum ContractSendType {
  sms,
  email,
  both;

  String get title => switch (this) {
    ContractSendType.sms => s.sms,
    ContractSendType.email => s.email,
    ContractSendType.both => s.both,
  };
}

enum ContractType {
  contract,
  legalCase;

  String get title => switch (this) {
    ContractType.contract => s.contract,
    ContractType.legalCase => s.legalCase,
  };
}

class ContractParams extends Equatable {
  const ContractParams({
    this.type = ContractType.contract,
    this.title = '',
    this.expireDate,
    this.fileId,
    this.sendType = ContractSendType.sms,
    this.members = const [],
    this.legalCaseId,
  });

  final ContractType type;
  final String title;

  /// YYYY/MM/DD Jalali format
  final String? expireDate;

  final int? fileId;
  final ContractSendType sendType;
  final List<SignerDto> members;
  final int? legalCaseId;

  ContractParams copyWith({
    final ContractType? type,
    final String? title,
    final String? expireDate,
    final int? fileId,
    final ContractSendType? sendType,
    final List<SignerDto>? members,
    final int? legalCaseId,
  }) {
    return ContractParams(
      type: type ?? this.type,
      title: title ?? this.title,
      expireDate: expireDate ?? this.expireDate,
      fileId: fileId ?? this.fileId,
      sendType: sendType ?? this.sendType,
      members: members ?? this.members,
      legalCaseId: legalCaseId ?? this.legalCaseId,
    );
  }

  Map<String, dynamic> toMap() {
    final isOffline = type == ContractType.legalCase;
    return {
      "title": title,
      "contractAttachmentId": fileId,
      "contractCaseId": legalCaseId,
      if (isOffline) ...{
        "parties": members.map((final SignerDto e) => e.toMap()).toList(),
        "is_offline": true,
      } else ...{
        "expireDate": expireDate,
        "sendType": sendType.name,
        "members": members.map((final e) => e.toMap()).toList(),
      },
    };
  }

  @override
  List<Object?> get props => [
    title,
    expireDate,
    fileId,
    sendType,
    members,
  ];
}

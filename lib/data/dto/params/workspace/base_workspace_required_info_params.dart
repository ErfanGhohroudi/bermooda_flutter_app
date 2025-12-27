part of '../../../data.dart';

abstract class IWorkspaceRequiredInfoParams {
  AuthenticationType get authenticationType;
  String toJson();
  Map<String, dynamic> toMap();
}

class BaseWorkspaceRequiredInfoParams implements IWorkspaceRequiredInfoParams{
  const BaseWorkspaceRequiredInfoParams({
    required this.authenticationType,
  });

  @override
  final AuthenticationType authenticationType;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
    "person_type": authenticationType.name,
  };
}

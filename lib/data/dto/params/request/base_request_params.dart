part of '../../../data.dart';

/// Base interface for all request parameters
abstract class IRequestCreateParams {
  int? get requestingUserId;
  RequestCategoryType? get categoryType;
  String? get description;

  Map<String, dynamic> toMap();
  String toJson();
}

/// Base class for common request fields
abstract class BaseRequestParams implements IRequestCreateParams {
  const BaseRequestParams({
    required this.categoryType,
    this.requestingUserId,
    this.description,
  });

  @override
  final int? requestingUserId;

  @override
  final RequestCategoryType categoryType;

  @override
  final String? description;


  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'requesting_user_id': requestingUserId,
        'main_category': categoryType.name,
        'description': description,
      };
}

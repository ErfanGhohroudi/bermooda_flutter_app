part of '../../../../data.dart';

/// Base interface for all response parameters
abstract class IRequestReadDto {
  String? get slug;
  UserReadDto? get requestingUser;
  AcceptorUserReadDto? get currentReviewer;
  List<AcceptorUserReadDto> get reviewerUsers;
  set requestingUser(final UserReadDto? value);
  RequestCategoryType? get categoryType;
  String? get description;
  StatusType? get status;

  Map<String, dynamic> toMap();
  String toJson();
}

/// Base class for common response fields
abstract class BaseResponseParams implements IRequestReadDto {
  BaseResponseParams({
    this.slug,
    this.requestingUser,
    this.currentReviewer,
    this.reviewerUsers = const [],
    required this.categoryType,
    this.description,
    this.status = StatusType.pending,
  });

  @override
  final String? slug;

  @override
  UserReadDto? requestingUser;

  @override
  AcceptorUserReadDto? currentReviewer;

  @override
  List<AcceptorUserReadDto> reviewerUsers;

  @override
  final RequestCategoryType categoryType;

  @override
  final String? description;

  @override
  final StatusType? status;

  @override
  String toJson() => json.encode(toMap()).englishNumber();

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'slug': slug,
        'requesting_user_id': requestingUser,
        'request_accepter_user_id_list': reviewerUsers.map((final e) => e.slug).toList(),
        'main_category': categoryType.name,
        'description': description,
        'status': status?.name,
      };
}

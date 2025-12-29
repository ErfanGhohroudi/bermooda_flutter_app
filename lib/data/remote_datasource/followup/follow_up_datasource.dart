part of '../../data.dart';

abstract class IFollowUpDatasource {
  void create({
    required final int? sourceId,
    required final String date,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void update({
    required final String? slug,
    required final String? date,
    required final String? trackerId,
    required final List<MainFileReadDto> files,
    final String? time,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void delete({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void changeTimerStatus({
    required final String? slug,
    required final TimerStatusCommand? command,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void changeStatus({
    required final String? slug,
    required final bool isSuccessFull,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void restore({
    required final String? slug,
    required final Function() onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });

  void getFollowups({
    required final int? sourceId,
    required final Function(GenericResponse<FollowUpReadDto> response) onResponse,
    required final Function(GenericResponse<dynamic> errorResponse) onError,
    final bool withRetry = false,
  });
}

import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';

enum SupportRoomStatus {
  WAITING,
  CLOSED,
  CONFIRMED,
  IN_PROGRESS;

  static SupportRoomStatus fromString(final String? status) {
    switch (status) {
      case 'waiting':
        return WAITING;
      case 'closed':
        return CLOSED;
      case 'confirmed':
        return CONFIRMED;
      case 'in_progress':
        return IN_PROGRESS;
      default:
        return WAITING;
    }
  }

  String get title {
    switch (this) {
      case WAITING:
        return 'WAITING';
      case CLOSED:
        return 'CLOSED';
      case CONFIRMED:
        return 'CONFIRMED';
      case IN_PROGRESS:
        return 'IN_PROGRESS';
    }
  }

  Color get color {
    switch (this) {
      case WAITING:
        return AppColors.orange;
      case CLOSED:
        return Colors.grey;
      case CONFIRMED:
        return AppColors.green;
      case IN_PROGRESS:
        return AppColors.orange;
    }
  }
}
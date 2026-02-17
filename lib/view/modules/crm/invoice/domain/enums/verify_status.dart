import 'package:flutter/material.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';

enum VerifyStatus {
  pending,
  verified,
  un_verified;

  String get title =>
      switch (this) {
        VerifyStatus.pending => s.pending,
        VerifyStatus.verified => s.verified,
        VerifyStatus.un_verified => s.rejected,
      };

  Color get color =>
      switch (this) {
        VerifyStatus.pending => AppColors.orange,
        VerifyStatus.verified => AppColors.green,
        VerifyStatus.un_verified => AppColors.red,
      };

  static VerifyStatus fromString(final String title) => switch (title) {
    'pending' => VerifyStatus.pending,
    'verified' => VerifyStatus.verified,
    'un_verified' => VerifyStatus.un_verified,
    _ => VerifyStatus.pending,
  };
}
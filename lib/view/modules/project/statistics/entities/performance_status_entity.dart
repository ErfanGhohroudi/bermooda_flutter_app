import 'package:flutter/material.dart';

class PerformanceStatusEntity {
  const PerformanceStatusEntity({
    required this.title,
    required this.color,
  });

  final String title; // عنوان وضعیت (عالی، خوب، متوسط، نیاز به بهبود)
  final Color color; // رنگ مربوط به وضعیت
}

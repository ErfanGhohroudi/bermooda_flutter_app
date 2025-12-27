import 'package:flutter/material.dart';

class StatCardValueEntity {
  const StatCardValueEntity({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String subtitle;
}

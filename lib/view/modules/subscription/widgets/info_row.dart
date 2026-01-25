import 'package:flutter/material.dart';
import 'package:u/utils/extensions/text_extension.dart';

class WInfoRow extends StatelessWidget {
  const WInfoRow(
    this.label,
    this.value, {
    this.isLtr = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isLtr;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ").bodyMedium(),
          Text(
            value,
            textDirection: isLtr ? TextDirection.ltr : null,
          ).bodyMedium(),
        ],
      ),
    );
  }
}

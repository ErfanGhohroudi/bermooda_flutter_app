import 'package:flutter/material.dart';
import 'package:u/utils/extensions/text_extension.dart';

import '../../../../core/theme.dart';

class WPriceRow extends StatelessWidget {
  const WPriceRow(
    this.label,
    this.value, {
    this.isDiscount = false,
    this.verPadding = 4,
    this.labelColor,
    super.key,
  });

  final String label;
  final String value;
  final bool isDiscount;
  final double verPadding;
  final Color? labelColor;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ").bodyMedium(color: labelColor),
          Text(value).bodyMedium(color: isDiscount ? AppColors.red : null),
        ],
      ),
    );
  }
}

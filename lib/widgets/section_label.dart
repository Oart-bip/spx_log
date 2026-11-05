import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Divisor de seção: "01  TÍTULO ———————"
class SectionLabel extends StatelessWidget {
  final String index;
  final String text;

  const SectionLabel(this.index, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(index, style: AppText.label.copyWith(color: AppColors.signal)),
        const SizedBox(width: 12),
        Text(text, style: AppText.label),
        const SizedBox(width: 12),
        const Expanded(child: Divider(height: 1, color: AppColors.line)),
      ],
    );
  }
}

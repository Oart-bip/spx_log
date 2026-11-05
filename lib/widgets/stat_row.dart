import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatCell extends StatelessWidget {
  final String label;
  final String value;

  const StatCell({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.label),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppText.data),
          ),
        ],
      ),
    );
  }
}

// Linha de indicadores separada por filetes, sem cards.
class StatRow extends StatelessWidget {
  final List<StatCell> cells;

  const StatRow({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < cells.length; i++) ...[
              if (i > 0) const VerticalDivider(width: 1, thickness: 1, color: AppColors.line),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: i == 0 ? 0 : 14, right: 8),
                  child: cells[i],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

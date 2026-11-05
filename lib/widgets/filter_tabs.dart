import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Filtros em texto sublinhado (sem chips nem botões do Material).
class FilterTabs extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  const FilterTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == selected ? AppColors.signal : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: AppText.label.copyWith(
                    color: i == selected ? AppColors.bone : AppColors.boneDim,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

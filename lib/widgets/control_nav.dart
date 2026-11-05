import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NavItem {
  final String index;
  final String label;
  const NavItem(this.index, this.label);
}

// Navegação própria: itens numerados e uma barra laranja que desliza.
class ControlNav extends StatelessWidget {
  final List<NavItem> items;
  final int current;
  final ValueChanged<int> onChanged;

  const ControlNav({
    super.key,
    required this.items,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final x = items.length == 1 ? 0.0 : -1 + 2 * current / (items.length - 1);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.ink,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: Alignment(x, -1),
                child: FractionallySizedBox(
                  widthFactor: 1 / items.length,
                  child: Container(height: 2, color: AppColors.signal),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              items[i].index,
                              style: AppText.label.copyWith(
                                fontSize: 10,
                                color: i == current ? AppColors.signal : AppColors.line,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items[i].label,
                              style: AppText.label.copyWith(
                                color: i == current ? AppColors.bone : AppColors.boneDim,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

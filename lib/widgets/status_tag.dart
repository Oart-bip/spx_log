import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../theme/app_theme.dart';

// Marcador quadrado + texto, no lugar de um chip arredondado.
class StatusTag extends StatelessWidget {
  final LaunchStatus status;
  final bool showText;

  const StatusTag({super.key, required this.status, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final (cor, texto) = switch (status) {
      LaunchStatus.success => (AppColors.ok, 'SUCESSO'),
      LaunchStatus.failure => (AppColors.fail, 'FALHA'),
      LaunchStatus.upcoming => (AppColors.signal, 'PRÓXIMO'),
      LaunchStatus.unknown => (AppColors.boneDim, 'SEM STATUS'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, color: cor),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(texto, style: AppText.label.copyWith(color: cor)),
        ],
      ],
    );
  }
}

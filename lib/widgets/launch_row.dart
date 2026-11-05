import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'status_tag.dart';

// Linha de lançamento: data, nome, foguete/agência e status.
class LaunchRow extends StatelessWidget {
  final Launch launch;
  final VoidCallback onTap;

  const LaunchRow({super.key, required this.launch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDayMonth(launch.date),
                    style: AppText.label.copyWith(color: AppColors.signal),
                  ),
                  const SizedBox(height: 4),
                  Text('${launch.date.toUtc().year}', style: AppText.label),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(launch.name, style: AppText.title),
                  const SizedBox(height: 6),
                  Text(
                    '${launch.rocketName}  ·  ${launch.provider}'.toUpperCase(),
                    style: AppText.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: StatusTag(status: launch.status, showText: false),
            ),
          ],
        ),
      ),
    );
  }
}

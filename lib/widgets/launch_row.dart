import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'status_tag.dart';

// Linha de lançamento: número do voo, nome, data/foguete e status.
class LaunchRow extends StatelessWidget {
  final Launch launch;
  final String rocketName;
  final VoidCallback onTap;

  const LaunchRow({
    super.key,
    required this.launch,
    required this.rocketName,
    required this.onTap,
  });

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
              width: 56,
              child: Text(
                formatFlight(launch.flightNumber),
                style: AppText.label.copyWith(color: AppColors.signal),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(launch.name, style: AppText.title),
                  const SizedBox(height: 6),
                  Text(
                    '${formatDate(launch.date)}  ·  ${rocketName.toUpperCase()}',
                    style: AppText.label,
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

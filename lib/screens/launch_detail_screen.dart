import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/section_label.dart';
import '../widgets/stat_row.dart';
import '../widgets/status_tag.dart';

class LaunchDetailScreen extends StatelessWidget {
  final Launch launch;
  final String rocketName;

  const LaunchDetailScreen({super.key, required this.launch, required this.rocketName});

  @override
  Widget build(BuildContext context) {
    final links = <String, String?>{
      'TRANSMISSÃO': launch.webcast,
      'ARTIGO': launch.article,
      'WIKIPEDIA': launch.wikipedia,
    }..removeWhere((_, url) => url == null);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            // Barra de volta própria, sem AppBar.
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('← VOLTAR', style: AppText.label.copyWith(color: AppColors.signal)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (launch.patchUrl != null)
              Align(
                alignment: Alignment.centerRight,
                child: Image.network(
                  launch.patchUrl!,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Text(formatFlight(launch.flightNumber), style: AppText.label.copyWith(color: AppColors.signal)),
            const SizedBox(height: 8),
            Text(launch.name, style: AppText.display.copyWith(fontSize: 40)),
            const SizedBox(height: 16),
            StatusTag(status: launch.status),
            const SizedBox(height: 28),
            StatRow(cells: [
              StatCell(label: 'DATA', value: formatDate(launch.date)),
              StatCell(label: 'HORA', value: formatTime(launch.date)),
            ]),
            StatRow(cells: [
              StatCell(label: 'FOGUETE', value: rocketName),
            ]),
            const SizedBox(height: 32),
            const SectionLabel('01', 'RELATÓRIO'),
            const SizedBox(height: 16),
            Text(
              launch.details ?? 'A API não traz descrição para esta missão.',
              style: AppText.body,
            ),
            if (launch.failures.isNotEmpty) ...[
              const SizedBox(height: 32),
              const SectionLabel('02', 'FALHAS'),
              const SizedBox(height: 16),
              for (final motivo in launch.failures)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('— $motivo', style: AppText.body.copyWith(color: AppColors.fail)),
                ),
            ],
            if (links.isNotEmpty) ...[
              const SizedBox(height: 32),
              SectionLabel(launch.failures.isEmpty ? '02' : '03', 'LINKS'),
              const SizedBox(height: 16),
              for (final entry in links.entries) ...[
                Text(entry.key, style: AppText.label),
                const SizedBox(height: 4),
                SelectableText(
                  entry.value!,
                  style: AppText.label.copyWith(color: AppColors.bone, letterSpacing: 0.2),
                ),
                const SizedBox(height: 14),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

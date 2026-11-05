import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/section_label.dart';
import '../widgets/stat_row.dart';
import '../widgets/status_tag.dart';

class LaunchDetailScreen extends StatelessWidget {
  final Launch launch;

  const LaunchDetailScreen({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    // Numeração automática das seções, já que algumas são opcionais.
    var n = 0;
    String proxima() => (++n).toString().padLeft(2, '0');

    final plataforma = [launch.padName, launch.location].whereType<String>().join('\n');

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
            if (launch.imageUrl != null) ...[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  launch.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) =>
                      progress == null ? child : Container(color: AppColors.panel),
                  errorBuilder: (_, __, ___) => Container(color: AppColors.panel),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(launch.provider.toUpperCase(), style: AppText.label.copyWith(color: AppColors.signal)),
            const SizedBox(height: 8),
            Text(launch.name, style: AppText.display.copyWith(fontSize: 36)),
            const SizedBox(height: 16),
            StatusTag(status: launch.status),
            const SizedBox(height: 28),
            StatRow(cells: [
              StatCell(label: 'DATA', value: formatDate(launch.date)),
              StatCell(label: 'HORA', value: formatTime(launch.date)),
            ]),
            StatRow(cells: [
              StatCell(label: 'FOGUETE', value: launch.rocketName),
              StatCell(label: 'ÓRBITA', value: launch.orbit ?? '-'),
            ]),
            const SizedBox(height: 32),
            SectionLabel(proxima(), 'RELATÓRIO'),
            const SizedBox(height: 16),
            Text(
              launch.missionDescription ?? 'A API não traz descrição para esta missão.',
              style: AppText.body,
            ),
            if (launch.failReason != null) ...[
              const SizedBox(height: 32),
              SectionLabel(proxima(), 'FALHA'),
              const SizedBox(height: 16),
              Text(launch.failReason!, style: AppText.body.copyWith(color: AppColors.fail)),
            ],
            if (plataforma.isNotEmpty) ...[
              const SizedBox(height: 32),
              SectionLabel(proxima(), 'PLATAFORMA'),
              const SizedBox(height: 16),
              Text(plataforma.toUpperCase(), style: AppText.label.copyWith(height: 1.8)),
            ],
          ],
        ),
      ),
    );
  }
}

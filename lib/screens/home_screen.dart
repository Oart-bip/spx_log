import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../services/space_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/routes.dart';
import '../widgets/future_view.dart';
import '../widgets/section_label.dart';
import '../widgets/stat_row.dart';
import '../widgets/state_views.dart';
import '../widgets/status_tag.dart';
import 'launch_detail_screen.dart';

class _HomeData {
  final Launch? next;
  final int upcomingCount;
  final int previousCount;
  _HomeData(this.next, this.upcomingCount, this.previousCount);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Próximos e anteriores em paralelo; o próximo lançamento é o mais cedo da lista.
  Future<_HomeData> _load(bool force) async {
    final pages = await Future.wait<LaunchPage>([
      spaceService.fetchUpcoming(force: force),
      spaceService.fetchPrevious(force: force),
    ]);
    final upcoming = [...pages[0].launches]..sort((a, b) => a.date.compareTo(b.date));
    return _HomeData(
      upcoming.isEmpty ? null : upcoming.first,
      pages[0].count,
      pages[1].count,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureView<_HomeData>(
        loader: _load,
        builder: (context, data) {
          final launch = data.next;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ÓRBITA / LOG', style: AppText.label.copyWith(color: AppColors.signal)),
                  const Text('LAUNCH LIBRARY 2', style: AppText.label),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Diário\nde voo.', style: AppText.display),
              const SizedBox(height: 40),
              const SectionLabel('01', 'PRÓXIMO LANÇAMENTO'),
              const SizedBox(height: 20),
              if (launch == null)
                const StateMessage(
                  title: 'Sem agenda.',
                  message: 'A API não tem lançamentos agendados no momento.',
                )
              else
                _NextLaunch(launch: launch),
              const SizedBox(height: 40),
              const SectionLabel('02', 'BANCO DE DADOS'),
              const SizedBox(height: 12),
              StatRow(cells: [
                StatCell(label: 'REALIZADOS', value: formatInt(data.previousCount)),
                StatCell(label: 'AGENDADOS', value: formatInt(data.upcomingCount)),
              ]),
              if (launch != null) ...[
                const SizedBox(height: 20),
                // Recuo à esquerda para quebrar o alinhamento do resto da tela.
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Text(
                    launch.missionDescription ?? 'A API não traz descrição para esta missão.',
                    style: AppText.body,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Text(
                    [launch.padName, launch.location].whereType<String>().join('  ·  ').toUpperCase(),
                    style: AppText.label,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// Destaque do próximo lançamento, com contagem de dias em tamanho gigante.
class _NextLaunch extends StatelessWidget {
  final Launch launch;

  const _NextLaunch({required this.launch});

  @override
  Widget build(BuildContext context) {
    final dias = launch.date.difference(DateTime.now()).inDays;
    final contagem = dias >= 0 ? 'T-$dias' : 'T+${-dias}';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(fadeRoute(LaunchDetailScreen(launch: launch))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              contagem,
              style: AppText.display.copyWith(fontSize: 96, letterSpacing: -5),
            ),
          ),
          Text(launch.name, style: AppText.title.copyWith(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            '${formatDate(launch.date)}  ·  ${launch.rocketName}'.toUpperCase(),
            style: AppText.label,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusTag(status: launch.status),
              Text('VER MISSÃO →', style: AppText.label.copyWith(color: AppColors.signal)),
            ],
          ),
        ],
      ),
    );
  }
}

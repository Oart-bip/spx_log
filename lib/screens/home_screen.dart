import 'package:flutter/material.dart';

import '../models/company.dart';
import '../models/launch.dart';
import '../services/spacex_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/routes.dart';
import '../widgets/future_view.dart';
import '../widgets/section_label.dart';
import '../widgets/stat_row.dart';
import '../widgets/status_tag.dart';
import 'launch_detail_screen.dart';

class _HomeData {
  final Launch latest;
  final Company company;
  final Map<String, String> rocketNames;
  _HomeData(this.latest, this.company, this.rocketNames);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Três requisições em paralelo.
  Future<_HomeData> _load() async {
    final r = await Future.wait<Object>([
      spaceX.fetchLatestLaunch(),
      spaceX.fetchCompany(),
      spaceX.fetchRocketNames(),
    ]);
    return _HomeData(r[0] as Launch, r[1] as Company, r[2] as Map<String, String>);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureView<_HomeData>(
        loader: _load,
        builder: (context, data) {
          final launch = data.latest;
          final company = data.company;
          final rocket = data.rocketNames[launch.rocketId] ?? '-';

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SPX / LOG', style: AppText.label.copyWith(color: AppColors.signal)),
                  const Text('API v4', style: AppText.label),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Diário\nde voo.', style: AppText.display),
              const SizedBox(height: 40),
              const SectionLabel('01', 'ÚLTIMO LANÇAMENTO'),
              const SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).push(
                  fadeRoute(LaunchDetailScreen(launch: launch, rocketName: rocket)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Número do voo em tamanho gigante, deslocado para a direita.
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatFlight(launch.flightNumber),
                        style: AppText.display.copyWith(fontSize: 96, letterSpacing: -5),
                      ),
                    ),
                    Text(launch.name, style: AppText.title.copyWith(fontSize: 28)),
                    const SizedBox(height: 10),
                    Text(
                      '${formatDate(launch.date)}  ·  ${rocket.toUpperCase()}',
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
              ),
              const SizedBox(height: 40),
              const SectionLabel('02', 'A EMPRESA'),
              const SizedBox(height: 12),
              StatRow(cells: [
                StatCell(label: 'FUNDAÇÃO', value: '${company.founded}'),
                StatCell(label: 'EQUIPE', value: formatInt(company.employees)),
              ]),
              StatRow(cells: [
                StatCell(label: 'VALOR', value: formatUsd(company.valuation)),
                StatCell(label: 'VEÍCULOS', value: '${company.vehicles}'),
                StatCell(label: 'BASES', value: '${company.launchSites + company.testSites}'),
              ]),
              const SizedBox(height: 20),
              // Recuo à esquerda para quebrar o alinhamento do resto da tela.
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(company.summary, style: AppText.body),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(
                  'CEO ${company.ceo.toUpperCase()}  ·  CTO ${company.cto.toUpperCase()}',
                  style: AppText.label,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

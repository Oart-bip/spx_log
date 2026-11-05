import 'package:flutter/material.dart';

import '../models/rocket.dart';
import '../services/space_service.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/future_view.dart';
import '../widgets/stat_row.dart';
import '../widgets/state_views.dart';

class RocketsScreen extends StatelessWidget {
  const RocketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureView<List<Rocket>>(
        loader: (force) => spaceService.fetchRockets(force: force),
        builder: (context, rockets) {
          if (rockets.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 48),
                StateMessage(title: 'Hangar vazio.', message: 'A API não retornou foguetes.'),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            itemCount: rockets.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text('Frota.', style: AppText.display),
                );
              }
              return _RocketBlock(rocket: rockets[i - 1], index: i - 1);
            },
          );
        },
      ),
    );
  }
}

// Medida com unidade, ou "-" quando a API não informa.
String _medida(double? valor, String unidade) {
  if (valor == null || valor == 0) return '-';
  return '${formatDecimal(valor)} $unidade';
}

class _RocketBlock extends StatelessWidget {
  final Rocket rocket;
  final int index;

  const _RocketBlock({required this.rocket, required this.index});

  @override
  Widget build(BuildContext context) {
    final image = rocket.imageUrl;
    final taxa = rocket.successRatePct;

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A imagem alterna o recuo (esquerda/direita) para criar assimetria.
          if (image != null)
            Padding(
              padding: EdgeInsets.only(left: index.isOdd ? 40 : 0, right: index.isEven ? 40 : 0),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) =>
                      progress == null ? child : Container(color: AppColors.panel),
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.panel,
                    alignment: Alignment.center,
                    child: const Text('SEM IMAGEM', style: AppText.label),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: AppText.label.copyWith(color: AppColors.signal),
              ),
              const SizedBox(width: 12),
              Text(rocket.family.toUpperCase(), style: AppText.label),
              const Spacer(),
              Text(
                rocket.active ? 'ATIVO' : 'APOSENTADO',
                style: AppText.label.copyWith(
                  color: rocket.active ? AppColors.ok : AppColors.boneDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(rocket.name, style: AppText.display.copyWith(fontSize: 36)),
          const SizedBox(height: 16),
          StatRow(cells: [
            StatCell(label: 'ALTURA', value: _medida(rocket.lengthM, 'm')),
            StatCell(label: 'DIÂMETRO', value: _medida(rocket.diameterM, 'm')),
            StatCell(label: 'MASSA', value: _medida(rocket.massT, 't')),
          ]),
          StatRow(cells: [
            StatCell(label: 'LANÇAMENTOS', value: formatInt(rocket.totalLaunches)),
            StatCell(label: 'SUCESSO', value: taxa == null ? '-' : '$taxa%'),
          ]),
          const SizedBox(height: 16),
          if (rocket.description.isNotEmpty)
            Text(
              rocket.description,
              style: AppText.body,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 10),
          Text(
            [
              rocket.manufacturer,
              if (rocket.maidenFlightYear != null) '1º VOO ${rocket.maidenFlightYear}',
            ].join('  ·  ').toUpperCase(),
            style: AppText.label,
          ),
        ],
      ),
    );
  }
}

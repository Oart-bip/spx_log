import 'package:flutter/material.dart';

import '../models/rocket.dart';
import '../services/spacex_service.dart';
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
        loader: spaceX.fetchRockets,
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

class _RocketBlock extends StatelessWidget {
  final Rocket rocket;
  final int index;

  const _RocketBlock({required this.rocket, required this.index});

  @override
  Widget build(BuildContext context) {
    final image = rocket.images.isNotEmpty ? rocket.images.first : null;

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
              Text('0${index + 1}', style: AppText.label.copyWith(color: AppColors.signal)),
              const SizedBox(width: 12),
              Text(rocket.type.toUpperCase(), style: AppText.label),
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
            StatCell(label: 'ALTURA', value: '${formatDecimal(rocket.heightMeters)} m'),
            StatCell(label: 'MASSA', value: '${formatInt((rocket.massKg / 1000).round())} t'),
            StatCell(label: 'SUCESSO', value: '${rocket.successRatePct}%'),
          ]),
          const SizedBox(height: 16),
          Text(rocket.description, style: AppText.body),
          const SizedBox(height: 10),
          Text(
            '${rocket.stages} ESTÁGIOS  ·  1º VOO ${rocket.firstFlight}',
            style: AppText.label,
          ),
        ],
      ),
    );
  }
}

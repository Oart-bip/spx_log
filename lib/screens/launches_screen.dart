import 'package:flutter/material.dart';

import '../models/launch.dart';
import '../services/spacex_service.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/future_view.dart';
import '../widgets/launch_row.dart';
import '../widgets/state_views.dart';
import 'launch_detail_screen.dart';

class _LaunchesData {
  final List<Launch> launches;
  final Map<String, String> rocketNames;
  _LaunchesData(this.launches, this.rocketNames);
}

class LaunchesScreen extends StatefulWidget {
  const LaunchesScreen({super.key});

  @override
  State<LaunchesScreen> createState() => _LaunchesScreenState();
}

class _LaunchesScreenState extends State<LaunchesScreen> {
  static const _filters = ['TODOS', 'SUCESSO', 'FALHA', 'PRÓXIMOS'];

  int _filter = 0;
  String _query = '';

  Future<_LaunchesData> _load() async {
    final r = await Future.wait<Object>([
      spaceX.fetchLaunches(),
      spaceX.fetchRocketNames(),
    ]);
    return _LaunchesData(r[0] as List<Launch>, r[1] as Map<String, String>);
  }

  // Aplica o filtro de status e a busca por nome.
  List<Launch> _apply(List<Launch> all) {
    final wanted = switch (_filter) {
      1 => LaunchStatus.success,
      2 => LaunchStatus.failure,
      3 => LaunchStatus.upcoming,
      _ => null,
    };

    final result = all.where((l) {
      final statusOk = wanted == null || l.status == wanted;
      final queryOk = l.name.toLowerCase().contains(_query.toLowerCase());
      return statusOk && queryOk;
    }).toList();

    // Próximos lançamentos fazem mais sentido do mais perto para o mais distante.
    if (wanted == LaunchStatus.upcoming) {
      result.sort((a, b) => a.date.compareTo(b.date));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Missões.', style: AppText.display),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  cursorColor: AppColors.signal,
                  style: AppText.data.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.line)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.line)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.signal)),
                    hintText: 'BUSCAR MISSÃO',
                    hintStyle: AppText.label,
                    prefixText: '/ ',
                    prefixStyle: AppText.data.copyWith(fontSize: 14, color: AppColors.signal),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                FilterTabs(
                  labels: _filters,
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureView<_LaunchesData>(
              loader: _load,
              builder: (context, data) {
                final items = _apply(data.launches);

                if (items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 48),
                      StateMessage(
                        title: 'Nada aqui.',
                        message: 'Nenhuma missão encontrada com esse filtro ou busca.',
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final launch = items[i];
                    final rocket = data.rocketNames[launch.rocketId] ?? '-';
                    return LaunchRow(
                      launch: launch,
                      rocketName: rocket,
                      onTap: () => Navigator.of(context).push(
                        fadeRoute(LaunchDetailScreen(launch: launch, rocketName: rocket)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

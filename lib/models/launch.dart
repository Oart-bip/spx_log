import '../utils/json.dart';

enum LaunchStatus { success, failure, upcoming, unknown }

class Launch {
  final String id;
  final String name;
  final String provider;
  final String rocketName;
  final DateTime date;
  final LaunchStatus status;
  final String? missionDescription;
  final String? orbit;
  final String? padName;
  final String? location;
  final String? imageUrl;
  final String? failReason;

  Launch({
    required this.id,
    required this.name,
    required this.provider,
    required this.rocketName,
    required this.date,
    required this.status,
    required this.missionDescription,
    required this.orbit,
    required this.padName,
    required this.location,
    required this.imageUrl,
    required this.failReason,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] as Map<String, dynamic>?) ?? {};
    final provider = (json['launch_service_provider'] as Map<String, dynamic>?) ?? {};
    final rocket = (json['rocket'] as Map<String, dynamic>?) ?? {};
    final config = (rocket['configuration'] as Map<String, dynamic>?) ?? {};
    final mission = (json['mission'] as Map<String, dynamic>?) ?? {};
    final orbit = (mission['orbit'] as Map<String, dynamic>?) ?? {};
    final pad = (json['pad'] as Map<String, dynamic>?) ?? {};
    final location = (pad['location'] as Map<String, dynamic>?) ?? {};

    return Launch(
      id: json['id'].toString(),
      name: asText(json['name']) ?? 'Missão sem nome',
      provider: asText(provider['name']) ?? '-',
      rocketName: asText(config['full_name']) ?? asText(config['name']) ?? '-',
      date: DateTime.tryParse(asText(json['net']) ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      status: _statusFromId(status['id']),
      missionDescription: asText(mission['description']),
      orbit: asText(orbit['name']),
      padName: asText(pad['name']),
      location: asText(location['name']),
      imageUrl: asImageUrl(json['image']),
      failReason: asText(json['failreason']),
    );
  }
}

// Ids de status da Launch Library 2:
// 3 = sucesso, 4 = falha, 7 = falha parcial, 1/2/5/6/8 = ainda não concluído.
LaunchStatus _statusFromId(dynamic id) {
  return switch (id) {
    3 => LaunchStatus.success,
    4 || 7 => LaunchStatus.failure,
    1 || 2 || 5 || 6 || 8 => LaunchStatus.upcoming,
    _ => LaunchStatus.unknown,
  };
}

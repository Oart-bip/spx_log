import '../utils/json.dart';

// Configuração de foguete (endpoint /config/launcher).
class Rocket {
  final String id;
  final String name;
  final String family;
  final String manufacturer;
  final String description;
  final String? imageUrl;
  final String? maidenFlightYear;
  final bool active;
  final double? lengthM;
  final double? diameterM;
  final double? massT;
  final int totalLaunches;
  final int successes;
  final int failures;

  Rocket({
    required this.id,
    required this.name,
    required this.family,
    required this.manufacturer,
    required this.description,
    required this.imageUrl,
    required this.maidenFlightYear,
    required this.active,
    required this.lengthM,
    required this.diameterM,
    required this.massT,
    required this.totalLaunches,
    required this.successes,
    required this.failures,
  });

  // Taxa de sucesso calculada a partir dos lançamentos concluídos.
  int? get successRatePct {
    final total = successes + failures;
    return total == 0 ? null : (successes * 100 / total).round();
  }

  factory Rocket.fromJson(Map<String, dynamic> json) {
    final maker = (json['manufacturer'] as Map<String, dynamic>?) ?? {};
    final maiden = asText(json['maiden_flight']);

    return Rocket(
      id: json['id'].toString(),
      name: asText(json['full_name']) ?? asText(json['name']) ?? '-',
      family: asText(json['family']) ?? '',
      manufacturer: asText(maker['name']) ?? '-',
      description: asText(json['description']) ?? '',
      imageUrl: asImageUrl(json['image_url'] ?? json['image']),
      maidenFlightYear: (maiden != null && maiden.length >= 4) ? maiden.substring(0, 4) : null,
      active: (json['active'] as bool?) ?? false,
      lengthM: asDouble(json['length']),
      diameterM: asDouble(json['diameter']),
      massT: asDouble(json['launch_mass']),
      totalLaunches: asInt(json['total_launch_count']),
      successes: asInt(json['successful_launches']),
      failures: asInt(json['failed_launches']),
    );
  }
}

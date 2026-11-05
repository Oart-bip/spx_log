enum LaunchStatus { success, failure, upcoming, unknown }

class Launch {
  final String id;
  final String name;
  final String rocketId;
  final int flightNumber;
  final DateTime date;
  final bool? success;
  final bool upcoming;
  final String? details;
  final String? patchUrl;
  final String? webcast;
  final String? article;
  final String? wikipedia;
  final List<String> failures;

  Launch({
    required this.id,
    required this.name,
    required this.rocketId,
    required this.flightNumber,
    required this.date,
    required this.success,
    required this.upcoming,
    required this.details,
    required this.patchUrl,
    required this.webcast,
    required this.article,
    required this.wikipedia,
    required this.failures,
  });

  LaunchStatus get status {
    if (upcoming) return LaunchStatus.upcoming;
    if (success == true) return LaunchStatus.success;
    if (success == false) return LaunchStatus.failure;
    return LaunchStatus.unknown;
  }

  factory Launch.fromJson(Map<String, dynamic> json) {
    final links = (json['links'] as Map<String, dynamic>?) ?? {};
    final patch = (links['patch'] as Map<String, dynamic>?) ?? {};
    final failures = ((json['failures'] as List?) ?? [])
        .map((f) => (f as Map<String, dynamic>)['reason']?.toString() ?? 'Motivo não informado')
        .toList();

    return Launch(
      id: json['id'] as String,
      name: json['name'] as String,
      rocketId: json['rocket']?.toString() ?? '',
      flightNumber: (json['flight_number'] as int?) ?? 0,
      date: DateTime.parse(json['date_utc'] as String),
      success: json['success'] as bool?,
      upcoming: (json['upcoming'] as bool?) ?? false,
      details: json['details'] as String?,
      patchUrl: patch['small'] as String?,
      webcast: links['webcast'] as String?,
      article: links['article'] as String?,
      wikipedia: links['wikipedia'] as String?,
      failures: failures,
    );
  }
}

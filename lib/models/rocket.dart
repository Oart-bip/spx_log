class Rocket {
  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int successRatePct;
  final String firstFlight;
  final double heightMeters;
  final double massKg;
  final String description;
  final List<String> images;

  Rocket({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.stages,
    required this.successRatePct,
    required this.firstFlight,
    required this.heightMeters,
    required this.massKg,
    required this.description,
    required this.images,
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    final height = (json['height'] as Map<String, dynamic>?) ?? {};
    final mass = (json['mass'] as Map<String, dynamic>?) ?? {};

    return Rocket(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type']?.toString() ?? '',
      active: (json['active'] as bool?) ?? false,
      stages: (json['stages'] as int?) ?? 0,
      successRatePct: (json['success_rate_pct'] as num?)?.toInt() ?? 0,
      firstFlight: json['first_flight']?.toString() ?? '-',
      heightMeters: (height['meters'] as num?)?.toDouble() ?? 0,
      massKg: (mass['kg'] as num?)?.toDouble() ?? 0,
      description: json['description']?.toString() ?? '',
      images: ((json['flickr_images'] as List?) ?? []).map((e) => e.toString()).toList(),
    );
  }
}

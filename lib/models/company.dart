class Company {
  final String name;
  final String ceo;
  final String cto;
  final int founded;
  final int employees;
  final int vehicles;
  final int launchSites;
  final int testSites;
  final int valuation;
  final String summary;

  Company({
    required this.name,
    required this.ceo,
    required this.cto,
    required this.founded,
    required this.employees,
    required this.vehicles,
    required this.launchSites,
    required this.testSites,
    required this.valuation,
    required this.summary,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name']?.toString() ?? '',
      ceo: json['ceo']?.toString() ?? '-',
      cto: json['cto']?.toString() ?? '-',
      founded: (json['founded'] as num?)?.toInt() ?? 0,
      employees: (json['employees'] as num?)?.toInt() ?? 0,
      vehicles: (json['vehicles'] as num?)?.toInt() ?? 0,
      launchSites: (json['launch_sites'] as num?)?.toInt() ?? 0,
      testSites: (json['test_sites'] as num?)?.toInt() ?? 0,
      valuation: (json['valuation'] as num?)?.toInt() ?? 0,
      summary: json['summary']?.toString() ?? '',
    );
  }
}

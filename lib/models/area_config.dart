class AreaConfig {
  final int? id;
  final String name;
  final double centerLat;
  final double centerLon;
  final double northKm;
  final double southKm;
  final double eastKm;
  final double westKm;
  final DateTime createdAt;

  AreaConfig({
    this.id,
    required this.name,
    required this.centerLat,
    required this.centerLon,
    required this.northKm,
    required this.southKm,
    required this.eastKm,
    required this.westKm,
    required this.createdAt,
  });

  factory AreaConfig.fromJson(Map<String, dynamic> json) {
    return AreaConfig(
      id: json['id'] as int?,
      name: json['name'] as String,
      centerLat: (json['centerLat'] as num).toDouble(),
      centerLon: (json['centerLon'] as num).toDouble(),
      northKm: (json['northKm'] as num).toDouble(),
      southKm: (json['southKm'] as num).toDouble(),
      eastKm: (json['eastKm'] as num).toDouble(),
      westKm: (json['westKm'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'centerLat': centerLat,
      'centerLon': centerLon,
      'northKm': northKm,
      'southKm': southKm,
      'eastKm': eastKm,
      'westKm': westKm,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

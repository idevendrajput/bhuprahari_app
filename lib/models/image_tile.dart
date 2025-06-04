class ImageTile {
  final int? id;
  final int areaConfigId;
  final String uniqueKey;
  final double latitude;
  final double longitude;
  final DateTime captureTime;
  final String imagePath;
  final String status; // Corresponds to ImageTileStatus enum in Python
  final DateTime? lastComparisonTime;
  final bool? changeDetected;

  ImageTile({
    this.id,
    required this.areaConfigId,
    required this.uniqueKey,
    required this.latitude,
    required this.longitude,
    required this.captureTime,
    required this.imagePath,
    required this.status,
    this.lastComparisonTime,
    this.changeDetected,
  });

  factory ImageTile.fromJson(Map<String, dynamic> json) {
    return ImageTile(
      id: json['id'] as int?,
      areaConfigId: json['areaConfigId'] as int,
      uniqueKey: json['uniqueKey'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      captureTime: DateTime.parse(json['captureTime'] as String),
      imagePath: json['imagePath'] as String,
      status: json['status'] as String,
      lastComparisonTime: json['lastComparisonTime'] != null
          ? DateTime.parse(json['lastComparisonTime'] as String)
          : null,
      changeDetected: json['changeDetected'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'areaConfigId': areaConfigId,
      'uniqueKey': uniqueKey,
      'latitude': latitude,
      'longitude': longitude,
      'captureTime': captureTime.toIso8601String(),
      'imagePath': imagePath,
      'status': status,
      'lastComparisonTime': lastComparisonTime?.toIso8601String(),
      'changeDetected': changeDetected,
    };
  }
}

class AlertDetail {
  final int? id;
  final int alertSessionId;
  final int imageTileId;
  final String previousImagePath;
  final String currentImagePath;
  final Map<String, dynamic>? changeLog; // JSON data from OpenCV
  final DateTime alertTime;

  AlertDetail({
    this.id,
    required this.alertSessionId,
    required this.imageTileId,
    required this.previousImagePath,
    required this.currentImagePath,
    this.changeLog,
    required this.alertTime,
  });

  factory AlertDetail.fromJson(Map<String, dynamic> json) {
    return AlertDetail(
      id: json['id'] as int?,
      alertSessionId: json['alertSessionId'] as int,
      imageTileId: json['imageTileId'] as int,
      previousImagePath: json['previousImagePath'] as String,
      currentImagePath: json['currentImagePath'] as String,
      changeLog: json['changeLog'] != null
          ? Map<String, dynamic>.from(json['changeLog'])
          : null,
      alertTime: DateTime.parse(json['alertTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alertSessionId': alertSessionId,
      'imageTileId': imageTileId,
      'previousImagePath': previousImagePath,
      'currentImagePath': currentImagePath,
      'changeLog': changeLog,
      'alertTime': alertTime.toIso8601String(),
    };
  }
}

class AlertSession {
  final int? id;
  final int areaConfigId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final int totalChangesDetected;
  final bool notificationSent;

  AlertSession({
    this.id,
    required this.areaConfigId,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.totalChangesDetected,
    required this.notificationSent,
  });

  factory AlertSession.fromJson(Map<String, dynamic> json) {
    return AlertSession(
      id: json['id'] as int?,
      areaConfigId: json['areaConfigId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      status: json['status'] as String,
      totalChangesDetected: json['totalChangesDetected'] as int,
      notificationSent: json['notificationSent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'areaConfigId': areaConfigId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status,
      'totalChangesDetected': totalChangesDetected,
      'notificationSent': notificationSent,
    };
  }
}

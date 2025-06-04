class User {
  final int? id;
  final String email;
  final String? profile;
  final DateTime? createdAt;
  final DateTime? lastUpdate;

  User({
    this.id,
    required this.email,
    this.profile,
    this.createdAt,
    this.lastUpdate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      email: json['email'] as String,
      profile: json['profile'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastUpdate: json['lastUpdate'] != null ? DateTime.parse(json['lastUpdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'profile': profile,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdate': lastUpdate?.toIso8601String(),
    };
  }
}

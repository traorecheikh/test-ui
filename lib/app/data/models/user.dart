class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final UserLevel level;
  final int sunuPoints;
  final double reliabilityScore;
  final List<String> tontineIds;
  final List<String> organizedTontineIds;
  final UserPreferences preferences;
  final List<Achievement> achievements;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profileImageUrl,
    required this.createdAt,
    this.level = UserLevel.novice,
    this.sunuPoints = 0,
    this.reliabilityScore = 5.0,
    this.tontineIds = const [],
    this.organizedTontineIds = const [],
    required this.preferences,
    this.achievements = const [],
  });

  bool get isOrganizer => organizedTontineIds.isNotEmpty;
  int get totalTontines => tontineIds.length;

  AppUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    UserLevel? level,
    int? sunuPoints,
    double? reliabilityScore,
    List<String>? tontineIds,
    List<String>? organizedTontineIds,
    UserPreferences? preferences,
    List<Achievement>? achievements,
  }) =>
      AppUser(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        createdAt: createdAt ?? this.createdAt,
        level: level ?? this.level,
        sunuPoints: sunuPoints ?? this.sunuPoints,
        reliabilityScore: reliabilityScore ?? this.reliabilityScore,
        tontineIds: tontineIds ?? this.tontineIds,
        organizedTontineIds: organizedTontineIds ?? this.organizedTontineIds,
        preferences: preferences ?? this.preferences,
        achievements: achievements ?? this.achievements,
      );
}

enum UserLevel {
  novice('Novice Tontine', 0),
  regular('Épargnant Régulier', 1000),
  pro('Tontineuse Pro', 5000),
  expert('Expert Communauté', 20000),
  legend('Légende SunuTontine', 100000);

  const UserLevel(this.label, this.requiredPoints);
  final String label;
  final int requiredPoints;
}

class UserPreferences {
  bool darkMode;
  String language;
  bool notificationsEnabled;
  bool soundEnabled;
  String currencyFormat;

  UserPreferences({
    this.darkMode = false,
    this.language = 'fr',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.currencyFormat = 'FCFA',
  });

  UserPreferences copyWith({
    bool? darkMode,
    String? language,
    bool? notificationsEnabled,
    bool? soundEnabled,
    String? currencyFormat,
  }) =>
      UserPreferences(
        darkMode: darkMode ?? this.darkMode,
        language: language ?? this.language,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        currencyFormat: currencyFormat ?? this.currencyFormat,
      );
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int pointsAwarded;
  final DateTime earnedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.pointsAwarded,
    required this.earnedAt,
  });
}

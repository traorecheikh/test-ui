import 'package:hive_ce/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 10)
class AppUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String? email;
  @HiveField(4)
  final String? profileImageUrl;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final UserLevel level;
  @HiveField(7)
  final int sunuPoints;
  @HiveField(8)
  final double reliabilityScore;
  @HiveField(9)
  final List<String> tontineIds;
  @HiveField(10)
  final List<String> organizedTontineIds;
  @HiveField(11)
  final UserPreferences preferences;
  @HiveField(12)
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
  }) => AppUser(
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

@HiveType(typeId: 11)
enum UserLevel {
  @HiveField(0)
  novice('Novice Tontine', 0),
  @HiveField(1)
  regular('Épargnant Régulier', 1000),
  @HiveField(2)
  pro('Tontineuse Pro', 5000),
  @HiveField(3)
  expert('Expert Communauté', 20000),
  @HiveField(4)
  legend('Légende SunuTontine', 100000);

  const UserLevel(this.label, this.requiredPoints);
  final String label;
  final int requiredPoints;
}

@HiveType(typeId: 12)
class UserPreferences {
  @HiveField(0)
  bool darkMode;
  @HiveField(1)
  String language;
  @HiveField(2)
  bool notificationsEnabled;
  @HiveField(3)
  bool soundEnabled;
  @HiveField(4)
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
  }) => UserPreferences(
    darkMode: darkMode ?? this.darkMode,
    language: language ?? this.language,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    currencyFormat: currencyFormat ?? this.currencyFormat,
  );
}

@HiveType(typeId: 13)
class Achievement {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime dateEarned;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.dateEarned,
  });
}

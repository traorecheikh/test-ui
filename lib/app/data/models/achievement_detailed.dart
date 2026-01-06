import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achievement_detailed.g.dart';

/// Achievement categories matching backend
@HiveType(typeId: 23)
enum AchievementCategory {
  @HiveField(0)
  @JsonValue('RELIABILITY')
  RELIABILITY,
  
  @HiveField(1)
  @JsonValue('PARTICIPATION')
  PARTICIPATION,
  
  @HiveField(2)
  @JsonValue('LEADERSHIP')
  LEADERSHIP,
  
  @HiveField(3)
  @JsonValue('SOCIAL')
  SOCIAL,
  
  @HiveField(4)
  @JsonValue('FINANCIAL')
  FINANCIAL,
  
  @HiveField(5)
  @JsonValue('STREAK')
  STREAK,
  
  @HiveField(6)
  @JsonValue('MILESTONE')
  MILESTONE,
  
  @HiveField(7)
  @JsonValue('SPECIAL')
  SPECIAL;

  String get displayName {
    switch (this) {
      case AchievementCategory.RELIABILITY:
        return 'Fiabilité';
      case AchievementCategory.PARTICIPATION:
        return 'Participation';
      case AchievementCategory.LEADERSHIP:
        return 'Leadership';
      case AchievementCategory.SOCIAL:
        return 'Social';
      case AchievementCategory.FINANCIAL:
        return 'Financier';
      case AchievementCategory.STREAK:
        return 'Série';
      case AchievementCategory.MILESTONE:
        return 'Jalon';
      case AchievementCategory.SPECIAL:
        return 'Spécial';
    }
  }

  String get icon {
    switch (this) {
      case AchievementCategory.RELIABILITY:
        return '⭐';
      case AchievementCategory.PARTICIPATION:
        return '🎯';
      case AchievementCategory.LEADERSHIP:
        return '👑';
      case AchievementCategory.SOCIAL:
        return '🤝';
      case AchievementCategory.FINANCIAL:
        return '💰';
      case AchievementCategory.STREAK:
        return '🔥';
      case AchievementCategory.MILESTONE:
        return '🏆';
      case AchievementCategory.SPECIAL:
        return '✨';
    }
  }
}

/// Achievement rarity levels matching backend
@HiveType(typeId: 24)
enum AchievementRarity {
  @HiveField(0)
  @JsonValue('COMMON')
  COMMON,
  
  @HiveField(1)
  @JsonValue('UNCOMMON')
  UNCOMMON,
  
  @HiveField(2)
  @JsonValue('RARE')
  RARE,
  
  @HiveField(3)
  @JsonValue('EPIC')
  EPIC,
  
  @HiveField(4)
  @JsonValue('LEGENDARY')
  LEGENDARY;

  String get displayName {
    switch (this) {
      case AchievementRarity.COMMON:
        return 'Commun';
      case AchievementRarity.UNCOMMON:
        return 'Peu Commun';
      case AchievementRarity.RARE:
        return 'Rare';
      case AchievementRarity.EPIC:
        return 'Épique';
      case AchievementRarity.LEGENDARY:
        return 'Légendaire';
    }
  }

  /// Get typical points for this rarity
  int get typicalPoints {
    switch (this) {
      case AchievementRarity.COMMON:
        return 50;
      case AchievementRarity.UNCOMMON:
        return 100;
      case AchievementRarity.RARE:
        return 200;
      case AchievementRarity.EPIC:
        return 350;
      case AchievementRarity.LEGENDARY:
        return 500;
    }
  }

  /// Get color for this rarity (hex string)
  String get colorHex {
    switch (this) {
      case AchievementRarity.COMMON:
        return '#9E9E9E'; // Grey
      case AchievementRarity.UNCOMMON:
        return '#4CAF50'; // Green
      case AchievementRarity.RARE:
        return '#2196F3'; // Blue
      case AchievementRarity.EPIC:
        return '#9C27B0'; // Purple
      case AchievementRarity.LEGENDARY:
        return '#FF9800'; // Orange/Gold
    }
  }
}

/// Detailed achievement model matching backend
@HiveType(typeId: 25)
@JsonSerializable()
class AchievementDetailed {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final AchievementCategory category;

  @HiveField(5)
  final AchievementRarity rarity;

  @HiveField(6)
  final int pointsAwarded;

  @HiveField(7)
  final DateTime? unlockedAt;

  @HiveField(8)
  final double progress; // 0.0 - 1.0

  @HiveField(9)
  final int currentValue;

  @HiveField(10)
  final int targetValue;

  @HiveField(11)
  final String? iconUrl;

  const AchievementDetailed({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.category,
    required this.rarity,
    required this.pointsAwarded,
    this.unlockedAt,
    this.progress = 0.0,
    this.currentValue = 0,
    required this.targetValue,
    this.iconUrl,
  });

  /// Check if achievement is unlocked
  bool get isUnlocked => unlockedAt != null;

  /// Check if achievement is in progress
  bool get isInProgress => !isUnlocked && progress > 0;

  /// Check if achievement is locked (not started)
  bool get isLocked => !isUnlocked && progress == 0;

  /// Get progress percentage (0-100)
  int get progressPercentage => (progress * 100).round();

  /// Get remaining value to unlock
  int get remainingValue {
    final remaining = targetValue - currentValue;
    return remaining > 0 ? remaining : 0;
  }

  /// Get days since unlock (null if not unlocked)
  int? get daysSinceUnlock {
    if (unlockedAt == null) return null;
    return DateTime.now().difference(unlockedAt!).inDays;
  }

  /// Check if recently unlocked (< 7 days)
  bool get isRecentlyUnlocked {
    final days = daysSinceUnlock;
    return days != null && days < 7;
  }

  factory AchievementDetailed.fromJson(Map<String, dynamic> json) =>
      _$AchievementDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementDetailedToJson(this);

  AchievementDetailed copyWith({
    int? id,
    String? code,
    String? title,
    String? description,
    AchievementCategory? category,
    AchievementRarity? rarity,
    int? pointsAwarded,
    DateTime? unlockedAt,
    double? progress,
    int? currentValue,
    int? targetValue,
    String? iconUrl,
  }) {
    return AchievementDetailed(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}

/// Achievement unlock event for streams
class AchievementUnlockedEvent {
  final AchievementDetailed achievement;
  final DateTime timestamp;
  final int pointsEarned;

  const AchievementUnlockedEvent({
    required this.achievement,
    required this.timestamp,
    required this.pointsEarned,
  });
}

/// Helper to group achievements by category
class AchievementsByCategory {
  final Map<AchievementCategory, List<AchievementDetailed>> achievementsByCategory;

  const AchievementsByCategory(this.achievementsByCategory);

  List<AchievementDetailed> get reliability =>
      achievementsByCategory[AchievementCategory.RELIABILITY] ?? [];

  List<AchievementDetailed> get participation =>
      achievementsByCategory[AchievementCategory.PARTICIPATION] ?? [];

  List<AchievementDetailed> get leadership =>
      achievementsByCategory[AchievementCategory.LEADERSHIP] ?? [];

  List<AchievementDetailed> get social =>
      achievementsByCategory[AchievementCategory.SOCIAL] ?? [];

  List<AchievementDetailed> get financial =>
      achievementsByCategory[AchievementCategory.FINANCIAL] ?? [];

  List<AchievementDetailed> get streak =>
      achievementsByCategory[AchievementCategory.STREAK] ?? [];

  List<AchievementDetailed> get milestone =>
      achievementsByCategory[AchievementCategory.MILESTONE] ?? [];

  List<AchievementDetailed> get special =>
      achievementsByCategory[AchievementCategory.SPECIAL] ?? [];

  int get totalUnlocked {
    return achievementsByCategory.values
        .expand((list) => list)
        .where((a) => a.isUnlocked)
        .length;
  }

  int get totalAchievements {
    return achievementsByCategory.values.expand((list) => list).length;
  }

  int get totalPoints {
    return achievementsByCategory.values
        .expand((list) => list)
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) => sum + a.pointsAwarded);
  }
}

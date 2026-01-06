import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reliability_score.g.dart';

/// Trust tiers based on reliability score (0-1000)
@HiveType(typeId: 26)
enum TrustTier {
  @HiveField(0)
  @JsonValue('NOVICE')
  NOVICE, // 0-199
  
  @HiveField(1)
  @JsonValue('BRONZE')
  BRONZE, // 200-399
  
  @HiveField(2)
  @JsonValue('SILVER')
  SILVER, // 400-599
  
  @HiveField(3)
  @JsonValue('GOLD')
  GOLD, // 600-799
  
  @HiveField(4)
  @JsonValue('PLATINUM')
  PLATINUM, // 800-899
  
  @HiveField(5)
  @JsonValue('DIAMOND')
  DIAMOND; // 900-1000

  String get displayName {
    switch (this) {
      case TrustTier.NOVICE:
        return 'Novice';
      case TrustTier.BRONZE:
        return 'Bronze';
      case TrustTier.SILVER:
        return 'Argent';
      case TrustTier.GOLD:
        return 'Or';
      case TrustTier.PLATINUM:
        return 'Platine';
      case TrustTier.DIAMOND:
        return 'Diamant';
    }
  }

  String get description {
    switch (this) {
      case TrustTier.NOVICE:
        return 'Nouveau, non testé';
      case TrustTier.BRONZE:
        return 'Fiable occasionnel';
      case TrustTier.SILVER:
        return 'Fiable régulier';
      case TrustTier.GOLD:
        return 'Très fiable';
      case TrustTier.PLATINUM:
        return 'Extrêmement fiable';
      case TrustTier.DIAMOND:
        return 'Fiabilité parfaite';
    }
  }

  String get icon {
    switch (this) {
      case TrustTier.NOVICE:
        return '🥉';
      case TrustTier.BRONZE:
        return '🥉';
      case TrustTier.SILVER:
        return '🥈';
      case TrustTier.GOLD:
        return '🥇';
      case TrustTier.PLATINUM:
        return '💎';
      case TrustTier.DIAMOND:
        return '💎';
    }
  }

  /// Get color for this tier (Material color)
  Color get color {
    switch (this) {
      case TrustTier.NOVICE:
        return const Color(0xFF9E9E9E); // Grey
      case TrustTier.BRONZE:
        return const Color(0xFFCD7F32); // Bronze
      case TrustTier.SILVER:
        return const Color(0xFFC0C0C0); // Silver
      case TrustTier.GOLD:
        return const Color(0xFFFFD700); // Gold
      case TrustTier.PLATINUM:
        return const Color(0xFFE5E4E2); // Platinum
      case TrustTier.DIAMOND:
        return const Color(0xFFB9F2FF); // Diamond blue
    }
  }

  /// Get score range for this tier
  (int min, int max) get scoreRange {
    switch (this) {
      case TrustTier.NOVICE:
        return (0, 199);
      case TrustTier.BRONZE:
        return (200, 399);
      case TrustTier.SILVER:
        return (400, 599);
      case TrustTier.GOLD:
        return (600, 799);
      case TrustTier.PLATINUM:
        return (800, 899);
      case TrustTier.DIAMOND:
        return (900, 1000);
    }
  }

  /// Get max contribution amount for this tier (in FCFA)
  int get maxContributionAmount {
    switch (this) {
      case TrustTier.NOVICE:
        return 10000; // 10k FCFA
      case TrustTier.BRONZE:
        return 25000; // 25k FCFA
      case TrustTier.SILVER:
        return 50000; // 50k FCFA
      case TrustTier.GOLD:
        return 75000; // 75k FCFA
      case TrustTier.PLATINUM:
        return 100000; // 100k FCFA
      case TrustTier.DIAMOND:
        return 100000; // 100k FCFA (backend max)
    }
  }

  /// Calculate tier from score
  static TrustTier fromScore(int score) {
    if (score < 200) return TrustTier.NOVICE;
    if (score < 400) return TrustTier.BRONZE;
    if (score < 600) return TrustTier.SILVER;
    if (score < 800) return TrustTier.GOLD;
    if (score < 900) return TrustTier.PLATINUM;
    return TrustTier.DIAMOND;
  }

  /// Get next tier (null if already DIAMOND)
  TrustTier? get nextTier {
    switch (this) {
      case TrustTier.NOVICE:
        return TrustTier.BRONZE;
      case TrustTier.BRONZE:
        return TrustTier.SILVER;
      case TrustTier.SILVER:
        return TrustTier.GOLD;
      case TrustTier.GOLD:
        return TrustTier.PLATINUM;
      case TrustTier.PLATINUM:
        return TrustTier.DIAMOND;
      case TrustTier.DIAMOND:
        return null;
    }
  }

  /// Get points needed to reach this tier
  int get minScore => scoreRange.$1;
}

/// History entry for score changes
@HiveType(typeId: 27)
@JsonSerializable()
class ScoreHistoryEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final String reason;

  @HiveField(3)
  final int? scoreDelta; // Change from previous (+/-)

  const ScoreHistoryEntry({
    required this.date,
    required this.score,
    required this.reason,
    this.scoreDelta,
  });

  bool get isPositive => scoreDelta != null && scoreDelta! > 0;
  bool get isNegative => scoreDelta != null && scoreDelta! < 0;

  factory ScoreHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ScoreHistoryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreHistoryEntryToJson(this);
}

/// Score breakdown by factor
@JsonSerializable()
class ScoreBreakdown {
  final int punctuality; // Points from on-time payments
  final int regularity; // Points from consistent participation
  final int completedTontines; // Points from completed tontines
  final int penalties; // Negative points from penalties
  final int socialBehavior; // Points from invitations, helping others

  const ScoreBreakdown({
    required this.punctuality,
    required this.regularity,
    required this.completedTontines,
    required this.penalties,
    required this.socialBehavior,
  });

  int get total =>
      punctuality + regularity + completedTontines + penalties + socialBehavior;

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ScoreBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreBreakdownToJson(this);
}

/// Main reliability score model
@HiveType(typeId: 28)
@JsonSerializable()
class ReliabilityScore {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final int score; // 0-1000

  @HiveField(2)
  final TrustTier trustTier;

  @HiveField(3)
  final DateTime lastUpdated;

  @HiveField(4)
  final List<ScoreHistoryEntry> history;

  @HiveField(5)
  final ScoreBreakdown breakdown;

  const ReliabilityScore({
    required this.userId,
    required this.score,
    required this.trustTier,
    required this.lastUpdated,
    this.history = const [],
    required this.breakdown,
  });

  /// Get progress to next tier (0.0 - 1.0)
  double get progressToNextTier {
    final nextTier = trustTier.nextTier;
    if (nextTier == null) return 1.0; // Already max tier

    final currentMin = trustTier.scoreRange.$1;
    final nextMin = nextTier.scoreRange.$1;
    final range = nextMin - currentMin;

    if (range == 0) return 1.0;

    final progress = (score - currentMin) / range;
    return progress.clamp(0.0, 1.0);
  }

  /// Get points needed for next tier
  int get pointsToNextTier {
    final nextTier = trustTier.nextTier;
    if (nextTier == null) return 0;

    final needed = nextTier.minScore - score;
    return needed > 0 ? needed : 0;
  }

  /// Get recent history (last N entries)
  List<ScoreHistoryEntry> getRecentHistory([int count = 10]) {
    if (history.isEmpty) return [];
    final sorted = List<ScoreHistoryEntry>.from(history)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(count).toList();
  }

  /// Check if score improved recently
  bool get hasRecentImprovement {
    if (history.length < 2) return false;
    final recent = getRecentHistory(2);
    if (recent.length < 2) return false;
    return recent[0].score > recent[1].score;
  }

  /// Check if score declined recently
  bool get hasRecentDecline {
    if (history.length < 2) return false;
    final recent = getRecentHistory(2);
    if (recent.length < 2) return false;
    return recent[0].score < recent[1].score;
  }

  factory ReliabilityScore.fromJson(Map<String, dynamic> json) =>
      _$ReliabilityScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ReliabilityScoreToJson(this);

  ReliabilityScore copyWith({
    int? userId,
    int? score,
    TrustTier? trustTier,
    DateTime? lastUpdated,
    List<ScoreHistoryEntry>? history,
    ScoreBreakdown? breakdown,
  }) {
    return ReliabilityScore(
      userId: userId ?? this.userId,
      score: score ?? this.score,
      trustTier: trustTier ?? this.trustTier,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}

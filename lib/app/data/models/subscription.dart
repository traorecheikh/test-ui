import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

/// Subscription tiers matching backend enum
@HiveType(typeId: 20)
enum SubscriptionTier {
  @HiveField(0)
  @JsonValue('FREE')
  FREE,
  
  @HiveField(1)
  @JsonValue('PREMIUM')
  PREMIUM,
  
  @HiveField(2)
  @JsonValue('ENTERPRISE')
  ENTERPRISE;

  /// Get display name in French
  String get displayName {
    switch (this) {
      case SubscriptionTier.FREE:
        return 'Gratuit';
      case SubscriptionTier.PREMIUM:
        return 'Premium';
      case SubscriptionTier.ENTERPRISE:
        return 'Enterprise';
    }
  }

  /// Get description of the tier
  String get description {
    switch (this) {
      case SubscriptionTier.FREE:
        return 'Parfait pour commencer';
      case SubscriptionTier.PREMIUM:
        return 'Pour les utilisateurs actifs';
      case SubscriptionTier.ENTERPRISE:
        return 'Pour les organisations';
    }
  }

  /// Get tontine limit for this tier
  int get tontineLimit {
    switch (this) {
      case SubscriptionTier.FREE:
        return 1;
      case SubscriptionTier.PREMIUM:
        return 10;
      case SubscriptionTier.ENTERPRISE:
        return 999999; // Practically unlimited
    }
  }

  /// Get participant limit for this tier
  int get participantLimit {
    switch (this) {
      case SubscriptionTier.FREE:
        return 10;
      case SubscriptionTier.PREMIUM:
        return 50;
      case SubscriptionTier.ENTERPRISE:
        return 500;
    }
  }

  /// Check if tier allows PawaPay payments
  bool get allowsPawaPayPayments {
    return this != SubscriptionTier.FREE;
  }

  /// Get monthly price in FCFA
  int? get monthlyPrice {
    switch (this) {
      case SubscriptionTier.FREE:
        return null; // Free
      case SubscriptionTier.PREMIUM:
        return 2500; // 2500 FCFA/month
      case SubscriptionTier.ENTERPRISE:
        return null; // Custom pricing
    }
  }
}

/// Subscription status matching backend enum
@HiveType(typeId: 21)
enum SubscriptionStatus {
  @HiveField(0)
  @JsonValue('ACTIVE')
  ACTIVE,
  
  @HiveField(1)
  @JsonValue('EXPIRED')
  EXPIRED,
  
  @HiveField(2)
  @JsonValue('CANCELLED')
  CANCELLED,
  
  @HiveField(3)
  @JsonValue('PENDING')
  PENDING;

  String get displayName {
    switch (this) {
      case SubscriptionStatus.ACTIVE:
        return 'Actif';
      case SubscriptionStatus.EXPIRED:
        return 'Expiré';
      case SubscriptionStatus.CANCELLED:
        return 'Annulé';
      case SubscriptionStatus.PENDING:
        return 'En attente';
    }
  }

  bool get isActive => this == SubscriptionStatus.ACTIVE;
}

/// Main subscription model matching backend entity
@HiveType(typeId: 22)
@JsonSerializable()
class Subscription {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final SubscriptionTier tier;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime? endDate;

  @HiveField(5)
  final SubscriptionStatus status;

  @HiveField(6)
  final int tontinesCreatedThisMonth;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.startDate,
    this.endDate,
    required this.status,
    this.tontinesCreatedThisMonth = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get tontine limit based on tier
  int get tontineLimit => tier.tontineLimit;

  /// Get participant limit based on tier
  int get participantLimit => tier.participantLimit;

  /// Check if can create more tontines this month
  bool get canCreateMoreTontines {
    return tontinesCreatedThisMonth < tontineLimit;
  }

  /// Get remaining tontines this month
  int get remainingTontines {
    final remaining = tontineLimit - tontinesCreatedThisMonth;
    return remaining > 0 ? remaining : 0;
  }

  /// Check if subscription is active
  bool get isActive => status.isActive;

  /// Get days until expiration (null if no end date)
  int? get daysUntilExpiration {
    if (endDate == null) return null;
    return endDate!.difference(DateTime.now()).inDays;
  }

  /// Check if subscription is about to expire (< 7 days)
  bool get isExpiringsSoon {
    final days = daysUntilExpiration;
    return days != null && days < 7 && days > 0;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  Subscription copyWith({
    int? id,
    int? userId,
    SubscriptionTier? tier,
    DateTime? startDate,
    DateTime? endDate,
    SubscriptionStatus? status,
    int? tontinesCreatedThisMonth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      tontinesCreatedThisMonth:
          tontinesCreatedThisMonth ?? this.tontinesCreatedThisMonth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Subscription limits helper class
class SubscriptionLimits {
  final int tontineLimit;
  final int participantLimit;
  final int tontinesUsed;
  final bool canCreateTontine;
  final bool allowsPawaPayPayments;

  const SubscriptionLimits({
    required this.tontineLimit,
    required this.participantLimit,
    required this.tontinesUsed,
    required this.canCreateTontine,
    required this.allowsPawaPayPayments,
  });

  int get remainingTontines {
    final remaining = tontineLimit - tontinesUsed;
    return remaining > 0 ? remaining : 0;
  }

  double get usagePercentage {
    if (tontineLimit == 0) return 0.0;
    return (tontinesUsed / tontineLimit).clamp(0.0, 1.0);
  }

  factory SubscriptionLimits.fromSubscription(Subscription subscription) {
    return SubscriptionLimits(
      tontineLimit: subscription.tontineLimit,
      participantLimit: subscription.participantLimit,
      tontinesUsed: subscription.tontinesCreatedThisMonth,
      canCreateTontine: subscription.canCreateMoreTontines,
      allowsPawaPayPayments: subscription.tier.allowsPawaPayPayments,
    );
  }
}

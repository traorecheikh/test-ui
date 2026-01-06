# 📘 GUIDE D'IMPLÉMENTATION - NEXT STEPS
## SunuTontine Frontend - Synchronisation avec Backend

**Date:** 6 Janvier 2026  
**Auteur:** GitHub Copilot AI  
**Pour:** Équipe SunuTontine  
**Objectif:** Guide pratique pour implémenter les fonctionnalités manquantes

---

## 🎯 STATUT ACTUEL

### ✅ Complété (Phase 1-2)
1. **Audit Complet** - Document `AUDIT_COMPLET_INTEGRATION_BACKEND.md`
2. **Modèles de Données** 
   - `subscription.dart` - Système d'abonnements (3 tiers)
   - `achievement_detailed.dart` - Système d'achievements (8 catégories, 5 raretés)
   - `reliability_score.dart` - Score de fiabilité (6 trust tiers)
   - Mise à jour `user.dart` - Score correct (int 0-1000)

### 🔄 En Cours (Phase 3)
**Prochaine priorité:** Créer les services d'intégration API

### ⏳ À Faire (Phases 4-6)
- Design System et composants UI
- Écrans d'abonnement, achievements, fiabilité
- Tests et documentation

---

## 🚀 ÉTAPE 1: GÉNÉRER LES FICHIERS .g.dart

### Pourquoi?
Les modèles utilisent `json_serializable` et `hive_ce` qui nécessitent la génération de code.

### Commandes à Exécuter
```bash
# Dans le répertoire du projet
cd /path/to/test-ui

# Installer les dépendances (si pas déjà fait)
flutter pub get

# Générer les fichiers .g.dart
flutter pub run build_runner build --delete-conflicting-outputs

# Vérifier que les fichiers sont générés
ls lib/app/data/models/*.g.dart
# Devrait afficher:
# - subscription.g.dart
# - achievement_detailed.g.dart
# - reliability_score.g.dart
# - (fichiers existants aussi)
```

### Si Erreurs
Si vous obtenez des erreurs de compilation:
1. Vérifiez que toutes les dépendances sont à jour dans `pubspec.yaml`
2. Ajoutez les imports manquants dans les fichiers
3. Relancez `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 🔧 ÉTAPE 2: METTRE À JOUR LE HIVE REGISTRAR

### Fichier à Modifier
`lib/hive_registrar.g.dart`

### Changements Nécessaires
Après génération des .g.dart, vous devrez ajouter les nouveaux adapters:

```dart
// Ajouter ces imports en haut du fichier
import 'package:snt_ui_test/app/data/models/subscription.dart';
import 'package:snt_ui_test/app/data/models/achievement_detailed.dart';
import 'package:snt_ui_test/app/data/models/reliability_score.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    // ... adapters existants ...
    
    // NOUVEAUX ADAPTERS À AJOUTER
    registerAdapter(SubscriptionTierAdapter());
    registerAdapter(SubscriptionStatusAdapter());
    registerAdapter(SubscriptionAdapter());
    registerAdapter(AchievementCategoryAdapter());
    registerAdapter(AchievementRarityAdapter());
    registerAdapter(AchievementDetailedAdapter());
    registerAdapter(TrustTierAdapter());
    registerAdapter(ScoreHistoryEntryAdapter());
    registerAdapter(ReliabilityScoreAdapter());
  }
}

// Même chose pour IsolatedHiveRegistrar
```

### Vérification
Lancer l'app et vérifier qu'il n'y a pas d'erreur Hive au démarrage.

---

## 🌐 ÉTAPE 3: CRÉER LES API MODELS

### Pourquoi?
Le backend envoie/reçoit des données JSON. Nous avons besoin de modèles pour la sérialisation.

### Fichier à Créer
`lib/app/data/models/api_subscription_models.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'subscription.dart';

part 'api_subscription_models.g.dart';

/// Request body pour créer/upgrade subscription
@JsonSerializable()
class SubscribeRequest {
  final int userId;
  final SubscriptionTier tier;
  
  SubscribeRequest({
    required this.userId,
    required this.tier,
  });
  
  factory SubscribeRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscribeRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscribeRequestToJson(this);
}

/// Response pour subscription endpoints
@JsonSerializable()
class SubscriptionResponse {
  final int id;
  final int userId;
  final String tier;
  final String status;
  final String startDate;
  final String? endDate;
  final int tontinesCreatedThisMonth;
  final String createdAt;
  final String updatedAt;
  
  SubscriptionResponse({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.tontinesCreatedThisMonth,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
  
  /// Convert to domain model
  Subscription toSubscription() {
    return Subscription(
      id: id,
      userId: userId,
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.name == tier,
        orElse: () => SubscriptionTier.FREE,
      ),
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      status: SubscriptionStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => SubscriptionStatus.PENDING,
      ),
      tontinesCreatedThisMonth: tontinesCreatedThisMonth,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

/// Check limits response
@JsonSerializable()
class CheckLimitsResponse {
  final bool canCreateTontine;
  final int tontineLimit;
  final int tontinesUsed;
  final int participantLimit;
  
  CheckLimitsResponse({
    required this.canCreateTontine,
    required this.tontineLimit,
    required this.tontinesUsed,
    required this.participantLimit,
  });
  
  factory CheckLimitsResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckLimitsResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$CheckLimitsResponseToJson(this);
}
```

### Fichier à Créer
`lib/app/data/models/api_achievement_models.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'achievement_detailed.dart';

part 'api_achievement_models.g.dart';

/// Achievement response from backend
@JsonSerializable()
class AchievementResponse {
  final int id;
  final String code;
  final String title;
  final String description;
  final String category;
  final String rarity;
  final int pointsAwarded;
  final String? unlockedAt;
  final double progress;
  final int currentValue;
  final int targetValue;
  final String? iconUrl;
  
  AchievementResponse({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.category,
    required this.rarity,
    required this.pointsAwarded,
    this.unlockedAt,
    required this.progress,
    required this.currentValue,
    required this.targetValue,
    this.iconUrl,
  });
  
  factory AchievementResponse.fromJson(Map<String, dynamic> json) =>
      _$AchievementResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AchievementResponseToJson(this);
  
  /// Convert to domain model
  AchievementDetailed toAchievementDetailed() {
    return AchievementDetailed(
      id: id,
      code: code,
      title: title,
      description: description,
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == category,
        orElse: () => AchievementCategory.SPECIAL,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (r) => r.name == rarity,
        orElse: () => AchievementRarity.COMMON,
      ),
      pointsAwarded: pointsAwarded,
      unlockedAt: unlockedAt != null ? DateTime.parse(unlockedAt!) : null,
      progress: progress,
      currentValue: currentValue,
      targetValue: targetValue,
      iconUrl: iconUrl,
    );
  }
}

/// List of achievements response
@JsonSerializable()
class AchievementsListResponse {
  final List<AchievementResponse> achievements;
  final int totalUnlocked;
  final int totalPoints;
  
  AchievementsListResponse({
    required this.achievements,
    required this.totalUnlocked,
    required this.totalPoints,
  });
  
  factory AchievementsListResponse.fromJson(Map<String, dynamic> json) =>
      _$AchievementsListResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AchievementsListResponseToJson(this);
}
```

### Fichier à Créer
`lib/app/data/models/api_reliability_models.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'reliability_score.dart';

part 'api_reliability_models.g.dart';

/// Reliability score response from backend
@JsonSerializable()
class ReliabilityScoreResponse {
  final int userId;
  final int score;
  final String trustTier;
  final String lastUpdated;
  final List<ScoreHistoryEntryResponse> history;
  final ScoreBreakdownResponse breakdown;
  
  ReliabilityScoreResponse({
    required this.userId,
    required this.score,
    required this.trustTier,
    required this.lastUpdated,
    required this.history,
    required this.breakdown,
  });
  
  factory ReliabilityScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$ReliabilityScoreResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ReliabilityScoreResponseToJson(this);
  
  /// Convert to domain model
  ReliabilityScore toReliabilityScore() {
    return ReliabilityScore(
      userId: userId,
      score: score,
      trustTier: TrustTier.fromScore(score),
      lastUpdated: DateTime.parse(lastUpdated),
      history: history.map((h) => h.toScoreHistoryEntry()).toList(),
      breakdown: breakdown.toScoreBreakdown(),
    );
  }
}

@JsonSerializable()
class ScoreHistoryEntryResponse {
  final String date;
  final int score;
  final String reason;
  final int? scoreDelta;
  
  ScoreHistoryEntryResponse({
    required this.date,
    required this.score,
    required this.reason,
    this.scoreDelta,
  });
  
  factory ScoreHistoryEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreHistoryEntryResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ScoreHistoryEntryResponseToJson(this);
  
  ScoreHistoryEntry toScoreHistoryEntry() {
    return ScoreHistoryEntry(
      date: DateTime.parse(date),
      score: score,
      reason: reason,
      scoreDelta: scoreDelta,
    );
  }
}

@JsonSerializable()
class ScoreBreakdownResponse {
  final int punctuality;
  final int regularity;
  final int completedTontines;
  final int penalties;
  final int socialBehavior;
  
  ScoreBreakdownResponse({
    required this.punctuality,
    required this.regularity,
    required this.completedTontines,
    required this.penalties,
    required this.socialBehavior,
  });
  
  factory ScoreBreakdownResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreBreakdownResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ScoreBreakdownResponseToJson(this);
  
  ScoreBreakdown toScoreBreakdown() {
    return ScoreBreakdown(
      punctuality: punctuality,
      regularity: regularity,
      completedTontines: completedTontines,
      penalties: penalties,
      socialBehavior: socialBehavior,
    );
  }
}
```

### Après Création
Relancer `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 🔌 ÉTAPE 4: CRÉER LES SERVICES

### A. SubscriptionService

**Fichier:** `lib/app/services/subscription_service.dart`

```dart
import 'package:get/get.dart';
import '../data/models/subscription.dart';
import '../data/models/api_subscription_models.dart';
// Import your API client here (Dio/Retrofit)

class SubscriptionService extends GetxService {
  // Observable subscription
  final Rx<Subscription?> currentSubscription = Rx<Subscription?>(null);
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  /// Initialize service and fetch current subscription
  Future<SubscriptionService> init() async {
    await fetchCurrentSubscription();
    return this;
  }
  
  /// Fetch active subscription for current user
  Future<void> fetchCurrentSubscription() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      // final response = await apiClient.getMySubscription();
      // currentSubscription.value = response.toSubscription();
      
      // MOCK DATA for now
      currentSubscription.value = Subscription(
        id: 1,
        userId: 1,
        tier: SubscriptionTier.FREE,
        startDate: DateTime.now().subtract(Duration(days: 10)),
        status: SubscriptionStatus.ACTIVE,
        tontinesCreatedThisMonth: 0,
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching subscription: $e');
      // Set default FREE tier on error
      currentSubscription.value = Subscription(
        id: 0,
        userId: 0,
        tier: SubscriptionTier.FREE,
        startDate: DateTime.now(),
        status: SubscriptionStatus.ACTIVE,
        tontinesCreatedThisMonth: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Check if user can create a new tontine
  Future<bool> canCreateTontine() async {
    final sub = currentSubscription.value;
    if (sub == null) return false;
    
    return sub.canCreateMoreTontines;
  }
  
  /// Get current limits
  SubscriptionLimits? getCurrentLimits() {
    final sub = currentSubscription.value;
    if (sub == null) return null;
    
    return SubscriptionLimits.fromSubscription(sub);
  }
  
  /// Upgrade to a new tier
  Future<bool> upgradeTier(SubscriptionTier newTier) async {
    try {
      isLoading.value = true;
      
      // TODO: Implement API call
      // final response = await apiClient.upgradeTier(newTier);
      // currentSubscription.value = response.toSubscription();
      
      // Show success message
      Get.snackbar(
        'Succès',
        'Abonnement mis à niveau vers ${newTier.displayName}',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à niveau l\'abonnement',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Increment tontines created this month (after successful creation)
  void incrementTontinesCreated() {
    final sub = currentSubscription.value;
    if (sub != null) {
      currentSubscription.value = sub.copyWith(
        tontinesCreatedThisMonth: sub.tontinesCreatedThisMonth + 1,
      );
    }
  }
}
```

### B. AchievementService

**Fichier:** `lib/app/services/achievement_service.dart`

```dart
import 'package:get/get.dart';
import '../data/models/achievement_detailed.dart';
import '../data/models/api_achievement_models.dart';

class AchievementService extends GetxService {
  // Observable lists
  final RxList<AchievementDetailed> allAchievements = <AchievementDetailed>[].obs;
  final RxList<AchievementDetailed> unlockedAchievements = <AchievementDetailed>[].obs;
  
  // Stats
  final RxInt totalPoints = 0.obs;
  final RxInt totalUnlocked = 0.obs;
  
  // Loading
  final RxBool isLoading = false.obs;
  
  Future<AchievementService> init() async {
    await fetchAchievements();
    return this;
  }
  
  /// Fetch all achievements for current user
  Future<void> fetchAchievements() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      // final response = await apiClient.getUserAchievements(userId);
      // allAchievements.value = response.achievements
      //     .map((a) => a.toAchievementDetailed())
      //     .toList();
      
      // MOCK DATA for now
      allAchievements.value = _getMockAchievements();
      
      _updateStats();
    } catch (e) {
      print('Error fetching achievements: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Get achievements grouped by category
  AchievementsByCategory getAchievementsByCategory() {
    final Map<AchievementCategory, List<AchievementDetailed>> grouped = {};
    
    for (var category in AchievementCategory.values) {
      grouped[category] = allAchievements
          .where((a) => a.category == category)
          .toList();
    }
    
    return AchievementsByCategory(grouped);
  }
  
  /// Get recently unlocked achievements (last 7 days)
  List<AchievementDetailed> getRecentlyUnlocked() {
    return unlockedAchievements
        .where((a) => a.isRecentlyUnlocked)
        .toList();
  }
  
  /// Simulate unlocking an achievement (for testing)
  void unlockAchievement(int achievementId) {
    final index = allAchievements.indexWhere((a) => a.id == achievementId);
    if (index != -1) {
      final achievement = allAchievements[index];
      if (!achievement.isUnlocked) {
        allAchievements[index] = achievement.copyWith(
          unlockedAt: DateTime.now(),
          progress: 1.0,
          currentValue: achievement.targetValue,
        );
        
        _updateStats();
        _showUnlockNotification(allAchievements[index]);
      }
    }
  }
  
  void _updateStats() {
    unlockedAchievements.value = allAchievements
        .where((a) => a.isUnlocked)
        .toList();
    
    totalUnlocked.value = unlockedAchievements.length;
    totalPoints.value = unlockedAchievements
        .fold(0, (sum, a) => sum + a.pointsAwarded);
  }
  
  void _showUnlockNotification(AchievementDetailed achievement) {
    // TODO: Show custom achievement unlock animation
    Get.snackbar(
      '🏆 Achievement Débloqué!',
      achievement.title,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 5),
    );
  }
  
  // Mock data for testing
  List<AchievementDetailed> _getMockAchievements() {
    return [
      AchievementDetailed(
        id: 1,
        code: 'FIRST_TONTINE',
        title: 'Première Tontine',
        description: 'Créer votre première tontine',
        category: AchievementCategory.LEADERSHIP,
        rarity: AchievementRarity.COMMON,
        pointsAwarded: 50,
        unlockedAt: DateTime.now().subtract(Duration(days: 2)),
        progress: 1.0,
        currentValue: 1,
        targetValue: 1,
      ),
      AchievementDetailed(
        id: 2,
        code: 'PERFECT_10',
        title: 'Perfect 10',
        description: '10 paiements consécutifs à temps',
        category: AchievementCategory.RELIABILITY,
        rarity: AchievementRarity.RARE,
        pointsAwarded: 150,
        progress: 0.6,
        currentValue: 6,
        targetValue: 10,
      ),
      // Add more mock achievements...
    ];
  }
}
```

### C. ReliabilityService

**Fichier:** `lib/app/services/reliability_service.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/reliability_score.dart';
import '../data/models/api_reliability_models.dart';

class ReliabilityService extends GetxService {
  final Rx<ReliabilityScore?> currentScore = Rx<ReliabilityScore?>(null);
  final RxBool isLoading = false.obs;
  
  Future<ReliabilityService> init() async {
    await fetchReliabilityScore();
    return this;
  }
  
  /// Fetch reliability score for current user
  Future<void> fetchReliabilityScore({int? userId}) async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API call
      // final response = await apiClient.getReliabilityScore(userId);
      // currentScore.value = response.toReliabilityScore();
      
      // MOCK DATA
      currentScore.value = _getMockScore();
    } catch (e) {
      print('Error fetching reliability score: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Calculate trust tier from score
  TrustTier calculateTier(int score) {
    return TrustTier.fromScore(score);
  }
  
  /// Get color for a trust tier
  Color getTierColor(TrustTier tier) {
    return tier.color;
  }
  
  /// Get icon for a trust tier
  String getTierIcon(TrustTier tier) {
    return tier.icon;
  }
  
  /// Get description for a trust tier
  String getTierDescription(TrustTier tier) {
    return tier.description;
  }
  
  ReliabilityScore _getMockScore() {
    return ReliabilityScore(
      userId: 1,
      score: 650, // GOLD tier
      trustTier: TrustTier.GOLD,
      lastUpdated: DateTime.now(),
      history: [
        ScoreHistoryEntry(
          date: DateTime.now().subtract(Duration(days: 1)),
          score: 650,
          reason: 'Paiement à temps',
          scoreDelta: 20,
        ),
        ScoreHistoryEntry(
          date: DateTime.now().subtract(Duration(days: 5)),
          score: 630,
          reason: 'Tontine complétée',
          scoreDelta: 50,
        ),
      ],
      breakdown: ScoreBreakdown(
        punctuality: 200,
        regularity: 150,
        completedTontines: 180,
        penalties: -30,
        socialBehavior: 150,
      ),
    );
  }
}
```

---

## 🎨 ÉTAPE 5: REFACTORISER LE DESIGN SYSTEM

### Fichier à Modifier
`lib/app/theme.dart`

### Changements Majeurs

1. **Ajouter SunuColors class** (voir AUDIT document, section Design System)
2. **Créer composants réutilisables** dans `lib/app/widgets/common/`

### Composants Prioritaires à Créer

#### 1. SunuButton
```dart
// lib/app/widgets/common/sunu_button.dart
import 'package:flutter/material.dart';

enum SunuButtonVariant { primary, secondary, text, icon }

class SunuButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final SunuButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  
  const SunuButton({
    Key? key,
    this.text,
    this.icon,
    this.onPressed,
    this.variant = SunuButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implementation based on variant
    // ...
  }
}
```

#### 2. SunuBadge
```dart
// lib/app/widgets/common/sunu_badge.dart
import 'package:flutter/material.dart';
import '../../data/models/subscription.dart';
import '../../data/models/reliability_score.dart';

class TierBadge extends StatelessWidget {
  final SubscriptionTier tier;
  final bool isCompact;
  
  const TierBadge({
    Key? key,
    required this.tier,
    this.isCompact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getTierColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tier.displayName.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isCompact ? 10 : 12,
        ),
      ),
    );
  }
  
  Color _getTierColor() {
    switch (tier) {
      case SubscriptionTier.FREE:
        return Colors.grey;
      case SubscriptionTier.PREMIUM:
        return Colors.blue;
      case SubscriptionTier.ENTERPRISE:
        return Colors.purple;
    }
  }
}

class TrustBadge extends StatelessWidget {
  final TrustTier tier;
  final bool showLabel;
  
  const TrustBadge({
    Key? key,
    required this.tier,
    this.showLabel = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: tier.color.withOpacity(0.2),
        border: Border.all(color: tier.color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tier.icon, style: TextStyle(fontSize: 16)),
          if (showLabel) ...[
            SizedBox(width: 4),
            Text(
              tier.displayName,
              style: TextStyle(
                color: tier.color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## 📱 ÉTAPE 6: CRÉER LES ÉCRANS PRIORITAIRES

### A. Écran de Plans d'Abonnement

**Fichier:** `lib/app/modules/subscription/views/subscription_plans_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/subscription.dart';
import '../../../services/subscription_service.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionPlansView extends GetView<SubscriptionController> {
  const SubscriptionPlansView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez Votre Plan'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildPlanCard(
              tier: SubscriptionTier.FREE,
              isCurrentPlan: controller.currentTier == SubscriptionTier.FREE,
            ),
            SizedBox(height: 16),
            _buildPlanCard(
              tier: SubscriptionTier.PREMIUM,
              isCurrentPlan: controller.currentTier == SubscriptionTier.PREMIUM,
              isRecommended: true,
            ),
            SizedBox(height: 16),
            _buildPlanCard(
              tier: SubscriptionTier.ENTERPRISE,
              isCurrentPlan: controller.currentTier == SubscriptionTier.ENTERPRISE,
            ),
          ],
        );
      }),
    );
  }
  
  Widget _buildPlanCard({
    required SubscriptionTier tier,
    bool isCurrentPlan = false,
    bool isRecommended = false,
  }) {
    return Card(
      elevation: isRecommended ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isRecommended 
            ? BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'RECOMMANDÉ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            SizedBox(height: 8),
            Text(
              tier.displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              tier.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            _buildPrice(tier),
            SizedBox(height: 20),
            _buildFeatures(tier),
            SizedBox(height: 20),
            if (isCurrentPlan)
              _buildCurrentPlanButton()
            else
              _buildUpgradeButton(tier),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrice(SubscriptionTier tier) {
    final price = tier.monthlyPrice;
    
    if (price == null) {
      return Text(
        tier == SubscriptionTier.FREE ? 'GRATUIT' : 'Sur Mesure',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$price',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 4),
        Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            'FCFA/mois',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeatures(SubscriptionTier tier) {
    final features = _getFeaturesForTier(tier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  List<String> _getFeaturesForTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.FREE:
        return [
          '1 tontine par mois',
          'Jusqu\'à 10 participants',
          'Tracking digital uniquement',
          'Fonctionnalités de base',
        ];
      case SubscriptionTier.PREMIUM:
        return [
          '10 tontines par mois',
          'Jusqu\'à 50 participants',
          'Toutes les fonctionnalités',
          'Statistiques détaillées',
          'Support prioritaire',
        ];
      case SubscriptionTier.ENTERPRISE:
        return [
          'Tontines illimitées',
          'Jusqu\'à 500 participants',
          'API access',
          'Dashboard administrateur',
          'Support dédié 24/7',
          'Personnalisation avancée',
        ];
    }
  }
  
  Widget _buildCurrentPlanButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PLAN ACTUEL',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
  
  Widget _buildUpgradeButton(SubscriptionTier tier) {
    return ElevatedButton(
      onPressed: () => controller.upgradeTo(tier),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'CHOISIR CE PLAN',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
```

**Controller:** `lib/app/modules/subscription/controllers/subscription_controller.dart`

```dart
import 'package:get/get.dart';
import '../../../data/models/subscription.dart';
import '../../../services/subscription_service.dart';

class SubscriptionController extends GetxController {
  final SubscriptionService _subscriptionService = Get.find();
  
  SubscriptionTier? get currentTier => 
      _subscriptionService.currentSubscription.value?.tier;
  
  RxBool get isLoading => _subscriptionService.isLoading;
  
  @override
  void onInit() {
    super.onInit();
    _subscriptionService.fetchCurrentSubscription();
  }
  
  Future<void> upgradeTo(SubscriptionTier tier) async {
    final success = await _subscriptionService.upgradeTier(tier);
    
    if (success) {
      Get.back(); // Return to previous screen
    }
  }
}
```

### B. Modifier l'Écran de Création de Tontine

**Fichier à modifier:** `lib/app/modules/tontine/views/create_tontine_view.dart`

**Ajouts en début du build():**

```dart
@override
Widget build(BuildContext context) {
  final subscriptionService = Get.find<SubscriptionService>();
  
  return Obx(() {
    final limits = subscriptionService.getCurrentLimits();
    final canCreate = limits?.canCreateTontine ?? false;
    
    // Show upgrade modal if limit reached
    if (!canCreate) {
      return _buildUpgradeRequiredView(limits);
    }
    
    // Show limit indicator in header
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une Tontine'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: _buildLimitIndicator(limits),
        ),
      ),
      body: _buildForm(),
    );
  });
}

Widget _buildLimitIndicator(SubscriptionLimits? limits) {
  if (limits == null) return SizedBox.shrink();
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: Colors.blue.withOpacity(0.1),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${limits.tontinesUsed}/${limits.tontineLimit} tontines ce mois',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: limits.usagePercentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  limits.usagePercentage > 0.8 
                      ? Colors.orange 
                      : Colors.blue,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        if (limits.remainingTontines > 0)
          Text(
            '${limits.remainingTontines} restantes',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
      ],
    ),
  );
}

Widget _buildUpgradeRequiredView(SubscriptionLimits? limits) {
  return Scaffold(
    appBar: AppBar(title: Text('Créer une Tontine')),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              'Limite Atteinte',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Vous avez atteint votre limite de ${limits?.tontineLimit ?? 0} tontine(s) pour ce mois.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/subscription-plans');
              },
              icon: Icon(Icons.upgrade),
              label: Text('PASSER À PREMIUM'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 52),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## 🧪 ÉTAPE 7: TESTER

### Tests Manuels à Effectuer

1. **Subscription Flow**
   - [ ] Ouvrir l'app (devrait charger FREE tier par défaut)
   - [ ] Naviguer vers subscription plans
   - [ ] Vérifier affichage des 3 tiers
   - [ ] Tester bouton "upgrade" (mock pour l'instant)

2. **Tontine Creation Limits**
   - [ ] Essayer de créer une tontine (FREE permet 1/mois)
   - [ ] Vérifier l'indicateur de limite en haut
   - [ ] Créer 1 tontine → vérifier compteur
   - [ ] Essayer d'en créer une 2e → blocker avec modal upgrade

3. **Achievements**
   - [ ] Naviguer vers profil (si écran créé)
   - [ ] Vérifier affichage des mock achievements
   - [ ] Tester déblocage manuel (pour développement)

4. **Reliability Score**
   - [ ] Vérifier affichage du score dans profil
   - [ ] Vérifier badge du trust tier
   - [ ] Tester affichage dans liste de participants (si implémenté)

### Tests Automatisés (À Créer)

**Fichier:** `test/models/subscription_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:snt_ui_test/app/data/models/subscription.dart';

void main() {
  group('Subscription Model Tests', () {
    test('FREE tier has correct limits', () {
      expect(SubscriptionTier.FREE.tontineLimit, 1);
      expect(SubscriptionTier.FREE.participantLimit, 10);
      expect(SubscriptionTier.FREE.allowsPawaPayPayments, false);
    });
    
    test('PREMIUM tier has correct limits', () {
      expect(SubscriptionTier.PREMIUM.tontineLimit, 10);
      expect(SubscriptionTier.PREMIUM.participantLimit, 50);
      expect(SubscriptionTier.PREMIUM.allowsPawaPayPayments, true);
    });
    
    test('Subscription can calculate remaining tontines', () {
      final subscription = Subscription(
        id: 1,
        userId: 1,
        tier: SubscriptionTier.PREMIUM,
        startDate: DateTime.now(),
        status: SubscriptionStatus.ACTIVE,
        tontinesCreatedThisMonth: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      expect(subscription.remainingTontines, 7);
      expect(subscription.canCreateMoreTontines, true);
    });
    
    test('Subscription blocks creation when limit reached', () {
      final subscription = Subscription(
        id: 1,
        userId: 1,
        tier: SubscriptionTier.FREE,
        startDate: DateTime.now(),
        status: SubscriptionStatus.ACTIVE,
        tontinesCreatedThisMonth: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      expect(subscription.canCreateMoreTontines, false);
      expect(subscription.remainingTontines, 0);
    });
  });
}
```

---

## 📚 RESSOURCES ET DOCUMENTATION

### Documentation Flutter/Dart
- **GetX:** https://pub.dev/packages/get
- **Hive:** https://pub.dev/packages/hive_ce
- **JSON Serialization:** https://docs.flutter.dev/data-and-backend/serialization/json
- **Material Design 3:** https://m3.material.io/

### Exemples de Code
- **Subscription UI:** https://dribbble.com/search/subscription-plans-mobile
- **Achievement Systems:** https://mobbin.com (chercher "gamification")
- **Score Displays:** Material Design components

### Outils Utiles
- **Flutter DevTools:** Pour debugging et profiling
- **Postman:** Pour tester les APIs backend
- **Figma:** Pour mockups UI (si besoin)

---

## ⚠️ POINTS D'ATTENTION

### 1. API Integration
Les services actuels utilisent des MOCK DATA. Pour connecter au vrai backend:

1. Configurer Dio/Retrofit avec l'URL du backend
2. Ajouter les headers d'authentification (JWT)
3. Remplacer les appels mock par de vrais appels API
4. Gérer les erreurs réseau

### 2. Hive Migration
Le changement du type `reliabilityScore` (double → int) nécessite:
- Une migration de données Hive
- Ou une réinitialisation de la base locale (OK pour dev)

### 3. Build Runner
**IMPORTANT:** Exécuter `flutter pub run build_runner build` après:
- Chaque création de modèle avec `@JsonSerializable`
- Chaque modification de modèle Hive
- Chaque ajout de champ dans un modèle existant

### 4. Performance
Avec les nouveaux modèles:
- Utiliser pagination pour listes longues (achievements, history)
- Cacher les données fréquemment accédées
- Éviter les rebuilds inutiles avec Obx

---

## 🎯 PROCHAINES PRIORITÉS

### Cette Semaine
1. ✅ Générer les .g.dart files
2. ✅ Mettre à jour Hive registrar
3. ✅ Créer API models
4. ✅ Implémenter SubscriptionService
5. ✅ Créer écran subscription_plans_view

### Semaine Prochaine
1. Implémenter AchievementService
2. Créer écrans achievements
3. Refactoriser theme.dart
4. Créer composants réutilisables
5. Intégrer dans home screen

### Dans 2 Semaines
1. Implémenter ReliabilityService
2. Créer écran reliability details
3. Améliorer écran de profil
4. Tests automatisés
5. Documentation utilisateur

---

## 🤝 BESOIN D'AIDE?

### Questions Fréquentes

**Q: Comment tester sans le backend?**
A: Utilisez les mock services fournis. Vous pouvez décommenter les vraies API calls quand le backend est prêt.

**Q: Les .g.dart files ne se génèrent pas?**
A: Vérifiez:
1. `flutter pub get` a été exécuté
2. Les imports sont corrects
3. Pas d'erreurs de syntaxe dans les modèles
4. `part 'file.g.dart';` est bien présent

**Q: L'app crash au démarrage?**
A: Probablement un problème Hive. Essayez:
```dart
await Hive.deleteBoxFromDisk('users');
await Hive.deleteBoxFromDisk('tontines');
```

**Q: Comment personnaliser les couleurs?**
A: Modifiez `SunuColors` dans `theme.dart`. Toute l'app utilisera les nouvelles couleurs.

### Contact
Pour des questions spécifiques, référez-vous à:
- L'audit complet: `AUDIT_COMPLET_INTEGRATION_BACKEND.md`
- Le backend documentation (si disponible)
- Les commentaires dans le code

---

**Bon courage! 💪 Vous avez tout ce qu'il faut pour réussir!**

*Ce document sera mis à jour au fur et à mesure de l'implémentation.*

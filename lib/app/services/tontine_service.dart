import 'dart:math';

import 'package:snt_ui_test/app/services/storage_service.dart';

import '../data/models/contribution.dart';
import '../data/models/tontine.dart';
import '../data/models/user.dart';

class TontineService {
  static List<Tontine> _tontines = [];
  static List<Contribution> _contributions = [];
  static AppUser? _currentUser;

  static Future<void> init() async {
    _currentUser = StorageService.getCurrentUser();
    if (_currentUser == null) {
      final newUser = AppUser(
        id: DateTime.now().millisecondsSinceEpoch,
        name: 'Cheikh',
        phone: '',
        createdAt: DateTime.now(),
        level: UserLevel.regular,
        sunuPoints: 0,
        reliabilityScore: 1.0,
        tontineIds: [],
        organizedTontineIds: [],
        preferences: UserPreferences(),
        achievements: [],
      );
      await StorageService.saveUser(newUser);
      _currentUser = StorageService.getCurrentUser();
    }
    _tontines = StorageService.getTontines();
    _contributions = StorageService.getContributions();
    if (_currentUser != null) {
      await _generateSampleData();
    }
  }

  // Create a new tontine
  static Future<int?> createTontine({
    required String name,
    required String description,
    String? imageUrl,
    required double contributionAmount,
    required TontineFrequency frequency,
    required DateTime startDate,
    required int maxParticipants,
    required TontineDrawOrder drawOrder,
    required double penaltyPercentage,
    required int organizerId,
    List<String> rules = const [],
  }) async {
    final tontine = Tontine(
      id: generateId(),
      name: name,
      description: description,
      imageUrl: imageUrl,
      contributionAmount: contributionAmount,
      frequency: frequency,
      startDate: startDate,
      maxParticipants: maxParticipants,
      drawOrder: drawOrder,
      penaltyPercentage: penaltyPercentage,
      organizerId: organizerId,
      status: TontineStatus.pending,
      participantIds: [organizerId],
      rules: rules,
      inviteCode: _generateInviteCode(),
      createdAt: DateTime.now(),
    );

    _tontines.add(tontine);
    await StorageService.saveTontines(_tontines);
    return tontine.id;
  }

  // Join a tontine
  static Future<bool> joinTontine(int tontineId, int userId) async {
    final tontineIndex = _tontines.indexWhere((t) => t.id == tontineId);
    if (tontineIndex == -1) return false;

    final tontine = _tontines[tontineIndex];
    if (tontine.participantIds.contains(userId)) return true;
    if (tontine.participantIds.length >= tontine.maxParticipants) return false;

    final updatedTontine = tontine.copyWith(
      participantIds: [...tontine.participantIds, userId],
    );

    _tontines[tontineIndex] = updatedTontine;
    await StorageService.saveTontines(_tontines);
    return true;
  }

  // Get tontines for a user
  static List<Tontine> getUserTontines(int userId) {
    return _tontines.where((t) => t.participantIds.contains(userId)).toList();
  }

  // Get organized tontines
  static List<Tontine> getOrganizedTontines(int userId) {
    return _tontines.where((t) => t.organizerId == userId).toList();
  }

  // Get tontine by ID
  static Tontine? getTontine(int tontineId) {
    try {
      return _tontines.firstWhere((t) => t.id == tontineId);
    } catch (e) {
      return null;
    }
  }

  // Get tontine by invite code
  static Tontine? getTontineByInviteCode(String inviteCode) {
    try {
      return _tontines.firstWhere((t) => t.inviteCode == inviteCode);
    } catch (e) {
      return null;
    }
  }

  // Start a tontine
  static Future<bool> startTontine(int tontineId) async {
    final tontineIndex = _tontines.indexWhere((t) => t.id == tontineId);
    if (tontineIndex == -1) return false;

    final tontine = _tontines[tontineIndex];
    if (tontine.participantIds.length < 2) return false;

    final updatedTontine = tontine.copyWith(
      status: TontineStatus.active,
      currentRound: 1,
      nextContributionDate: _calculateNextContributionDate(
        tontine.startDate,
        tontine.frequency,
      ),
    );

    _tontines[tontineIndex] = updatedTontine;
    await _generateContributionsForRound(updatedTontine, 1);
    await StorageService.saveTontines(_tontines);
    return true;
  }

  // Get contributions for a tontine and round
  static List<Contribution> getTontineContributions(
    int tontineId, {
    int? round,
  }) {
    return _contributions
        .where(
          (c) =>
              c.tontineId == tontineId && (round == null || c.round == round),
        )
        .toList();
  }

  // Get user contributions
  static List<Contribution> getUserContributions(int userId) {
    return _contributions.where((c) => c.participantId == userId).toList();
  }

  // Mark contribution as paid
  static Future<bool> markContributionPaid(
    int contributionId,
    String paymentReference,
  ) async {
    final contributionIndex = _contributions.indexWhere(
      (c) => c.id == contributionId,
    );
    if (contributionIndex == -1) return false;

    final contribution = _contributions[contributionIndex];
    final updatedContribution = contribution.copyWith(
      status: ContributionStatus.paid,
      paidDate: DateTime.now(),
      paymentReference: paymentReference,
    );

    _contributions[contributionIndex] = updatedContribution;
    await StorageService.saveContributions(_contributions);
    return true;
  }

  // Check if round is complete and can proceed to next
  static bool isRoundComplete(int tontineId, int round) {
    final roundContributions = getTontineContributions(tontineId, round: round);
    return roundContributions.isNotEmpty &&
        roundContributions.every((c) => c.status == ContributionStatus.paid);
  }

  // Get pot filling percentage for current round
  static double getPotFillingPercentage(int tontineId, int round) {
    final roundContributions = getTontineContributions(tontineId, round: round);
    if (roundContributions.isEmpty) return 0.0;

    final paidCount = roundContributions.where((c) => c.isPaid).length;
    return paidCount / roundContributions.length;
  }

  // Private helper methods
  static int generateId() {
    // Using a smaller random component to reduce chances of overflow with epoch,
    // but this is still not ideal for Hive keys if they need to be small integers.
    // Consider a robust unique ID generation strategy if this ID is a Hive key.
    // For now, let's cap the random part to ensure it's less likely to overflow
    // when added to millisecondsSinceEpoch, assuming millisecondsSinceEpoch
    // itself fits within a significant portion of the 32-bit range.
    // A better solution would be to not use this as a direct Hive key if Hive
    // has strict 0-0xFFFFFFFF limitations for *all* integer keys.
    return (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF) +
        Random().nextInt(1000);
  }

  static String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
      ),
    );
  }

  static DateTime _calculateNextContributionDate(
    DateTime startDate,
    TontineFrequency frequency,
  ) {
    switch (frequency) {
      case TontineFrequency.daily:
        return startDate.add(const Duration(days: 1));
      case TontineFrequency.weekly:
        return startDate.add(const Duration(days: 7));
      case TontineFrequency.biweekly:
        return startDate.add(const Duration(days: 14));
      case TontineFrequency.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case TontineFrequency.quarterly:
        return DateTime(startDate.year, startDate.month + 3, startDate.day);
    }
  }

  static Future<void> _generateContributionsForRound(
    Tontine tontine,
    int round,
  ) async {
    final contributions = tontine.participantIds
        .map(
          (participantId) => Contribution(
            id: generateId(), // This might still be an issue if Hive keys are strictly 0-0xFFFFFFFF
            tontineId: tontine.id ?? 0,
            participantId: participantId,
            round: round,
            amount: tontine.contributionAmount,
            dueDate: tontine.nextContributionDate ?? DateTime.now(),
            status: ContributionStatus.pending,
          ),
        )
        .toList();

    _contributions.addAll(contributions);
    await StorageService.saveContributions(_contributions);
  }

  // Generate sample data for demonstration
  static Future<void> _generateSampleData() async {
    // Vider d'abord les données existantes pour forcer la regénération
    _tontines.clear();
    _contributions.clear();

    final currentUser = StorageService.getCurrentUser();
    if (currentUser == null) {
      return;
    }

    int nextContributionId = 1;

    // 1. Tontine où l'utilisateur est organisateur - ACTIVE avec progression avancée
    final activeTontineAsOrganizer = Tontine(
      id: 1,
      name: 'Entrepreneurs du Plateau',
      description:
          'Tontine mensuelle pour entrepreneurs ambitieux du quartier Plateau',
      imageUrl: null,
      contributionAmount: 75000,
      frequency: TontineFrequency.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      maxParticipants: 8,
      drawOrder: TontineDrawOrder.random,
      penaltyPercentage: 10.0,
      organizerId: currentUser.id ?? 0,
      status: TontineStatus.active,
      participantIds: [currentUser.id ?? 0, 2, 3, 4, 5, 6, 7, 8],
      rules: [
        'Paiement avant le 5 de chaque mois',
        'Pénalité de 10% après 3 jours de retard',
        'Tirage équitable par rotation',
        'Pas de sortie avant la fin du cycle',
      ],
      inviteCode: 'PLAT85',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      currentRound: 4,
      nextContributionDate: DateTime.now().add(const Duration(days: 12)),
      currentWinnerId: 5,
    );

    // 2. Tontine où l'utilisateur est participant - ACTIVE début de cycle
    final activeTontineAsParticipant = Tontine(
      id: 2,
      name: 'Tontine Solidarité Femmes',
      description: 'Épargne collective pour l\'autonomisation des femmes',
      imageUrl: null,
      contributionAmount: 15000,
      frequency: TontineFrequency.weekly,
      startDate: DateTime.now().subtract(const Duration(days: 8)),
      maxParticipants: 15,
      drawOrder: TontineDrawOrder.merit,
      penaltyPercentage: 5.0,
      organizerId: 1001,
      status: TontineStatus.active,
      participantIds: [
        1001,
        currentUser.id ?? 0,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
      ],
      rules: [
        'Paiement chaque lundi avant 18h',
        'Priorité aux membres les plus actifs',
        'Entraide mutuelle encouragée',
        'Réunions mensuelles obligatoires',
      ],
      inviteCode: 'SOLID2',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      currentRound: 2,
      nextContributionDate: DateTime.now().add(const Duration(days: 3)),
      currentWinnerId: 10,
    );

    // 3. Tontine en attente de participants - PENDING (organisateur)
    final pendingTontineAsOrganizer = Tontine(
      id: 3,
      name: 'Projet Maison 2025',
      description: 'Épargne pour construction ou rénovation de maison',
      imageUrl: null,
      contributionAmount: 200000,
      frequency: TontineFrequency.monthly,
      startDate: DateTime.now().add(const Duration(days: 7)),
      maxParticipants: 6,
      drawOrder: TontineDrawOrder.fixed,
      penaltyPercentage: 15.0,
      organizerId: currentUser.id ?? 0,
      status: TontineStatus.pending,
      participantIds: [currentUser.id ?? 0, 21, 22],
      rules: [
        'Contribution le 1er de chaque mois',
        'Ordre fixe déterminé par ancienneté',
        'Pénalité stricte de 15%',
        'Preuves d\'utilisation requises',
      ],
      inviteCode: 'MAIS25',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      currentRound: 0,
      nextContributionDate: null,
      currentWinnerId: null,
    );

    // 4. Tontine quotidienne rapide - ACTIVE (participant)
    final dailyTontine = Tontine(
      id: 4,
      name: 'Express Dakar',
      description: 'Tontine quotidienne pour liquidités immédiates',
      imageUrl: null,
      contributionAmount: 5000,
      frequency: TontineFrequency.daily,
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      maxParticipants: 10,
      drawOrder: TontineDrawOrder.random,
      penaltyPercentage: 20.0,
      organizerId: 1002,
      status: TontineStatus.active,
      participantIds: [
        1002,
        currentUser.id ?? 0,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
      ],
      rules: [
        'Paiement avant 12h chaque jour',
        'Tirage automatique à 13h',
        'Pénalité immédiate de 20%',
        'Cycle de 10 jours seulement',
      ],
      inviteCode: 'EXPR10',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      currentRound: 4,
      nextContributionDate: DateTime.now().add(const Duration(hours: 18)),
      currentWinnerId: 32,
    );

    // 5. Tontine terminée avec succès - COMPLETED (organisateur)
    final completedTontine = Tontine(
      id: 5,
      name: 'Vacances Été 2024',
      description: 'Épargne collective pour voyage de groupe',
      imageUrl: null,
      contributionAmount: 50000,
      frequency: TontineFrequency.biweekly,
      startDate: DateTime.now().subtract(const Duration(days: 120)),
      maxParticipants: 6,
      drawOrder: TontineDrawOrder.hybrid,
      penaltyPercentage: 8.0,
      organizerId: currentUser.id ?? 0,
      status: TontineStatus.completed,
      participantIds: [currentUser.id ?? 0, 40, 41, 42, 43, 44],
      rules: [
        'Paiement bi-mensuel régulier',
        'Ordre hybride (mérite + hasard)',
        'Utilisation voyage vérifiée',
        'Photos de voyage partagées',
      ],
      inviteCode: 'VAC24K',
      createdAt: DateTime.now().subtract(const Duration(days: 140)),
      currentRound: 6,
      nextContributionDate: null,
      currentWinnerId: null,
    );

    // 6. Tontine trimestrielle haut montant - ACTIVE (participant)
    final quarterlyTontine = Tontine(
      id: 6,
      name: 'Business Angels Dakar',
      description: 'Investissement trimestriel pour projets entrepreneuriaux',
      imageUrl: null,
      contributionAmount: 500000,
      frequency: TontineFrequency.quarterly,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      maxParticipants: 4,
      drawOrder: TontineDrawOrder.merit,
      penaltyPercentage: 25.0,
      organizerId: 1003,
      status: TontineStatus.active,
      participantIds: [1003, currentUser.id ?? 0, 50, 51],
      rules: [
        'Contribution chaque début de trimestre',
        'Présentation obligatoire du projet',
        'Comité de sélection au mérite',
        'Suivi des investissements',
      ],
      inviteCode: 'BANG4K',
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      currentRound: 1,
      nextContributionDate: DateTime.now().add(const Duration(days: 60)),
      currentWinnerId: 1003,
    );

    // 7. Tontine famille étendue - ACTIVE (organisateur)
    final familyTontine = Tontine(
      id: 7,
      name: 'Famille Diop United',
      description: 'Tontine familiale pour soutien mutuel et projets communs',
      imageUrl: null,
      contributionAmount: 35000,
      frequency: TontineFrequency.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 75)),
      maxParticipants: 12,
      drawOrder: TontineDrawOrder.fixed,
      penaltyPercentage: 5.0,
      organizerId: currentUser.id ?? 0,
      status: TontineStatus.active,
      participantIds: [
        currentUser.id ?? 0,
        101,
        102,
        103,
        104,
        105,
        106,
        107,
        108,
        109,
        110,
        111,
      ],
      rules: [
        'Ordre basé sur l\'âge (aînés d\'abord)',
        'Tolérance familiale pour retards',
        'Utilisation transparente des fonds',
        'Solidarité en cas de difficulté',
      ],
      inviteCode: 'DIOP12',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      currentRound: 6,
      nextContributionDate: DateTime.now().add(const Duration(days: 8)),
      currentWinnerId: 103,
    );

    _tontines.addAll([
      activeTontineAsOrganizer,
      activeTontineAsParticipant,
      pendingTontineAsOrganizer,
      dailyTontine,
      completedTontine,
      quarterlyTontine,
      familyTontine,
    ]);

    // Create realistic sample contributions for multiple tontines
    final contributions = <Contribution>[
      // Contributions pour Entrepreneurs du Plateau (round 4)
      ...activeTontineAsOrganizer.participantIds.map(
        (userId) => Contribution(
          id: nextContributionId++,
          tontineId: activeTontineAsOrganizer.id ?? 0,
          participantId: userId,
          round: 4,
          amount: activeTontineAsOrganizer.contributionAmount,
          dueDate:
              activeTontineAsOrganizer.nextContributionDate ?? DateTime.now(),
          status: userId == (currentUser.id ?? 0) || userId == 2 || userId == 3
              ? ContributionStatus.paid
              : ContributionStatus.pending,
          paidDate: userId == (currentUser.id ?? 0)
              ? DateTime.now().subtract(const Duration(hours: 6))
              : userId == 2
              ? DateTime.now().subtract(const Duration(hours: 3))
              : userId == 3
              ? DateTime.now().subtract(const Duration(hours: 1))
              : null,
          paymentReference: userId == (currentUser.id ?? 0)
              ? 'WAVE789123'
              : userId == 2
              ? 'ORANGE456789'
              : userId == 3
              ? 'FREE987654'
              : null,
        ),
      ),

      // Contributions pour Solidarité Femmes (round 2)
      ...activeTontineAsParticipant.participantIds.map(
        (userId) => Contribution(
          id: nextContributionId++,
          tontineId: activeTontineAsParticipant.id ?? 0,
          participantId: userId,
          round: 2,
          amount: activeTontineAsParticipant.contributionAmount,
          dueDate:
              activeTontineAsParticipant.nextContributionDate ?? DateTime.now(),
          status: [1001, currentUser.id ?? 0, 10, 11, 12].contains(userId)
              ? ContributionStatus.paid
              : ContributionStatus.pending,
          paidDate: userId == (currentUser.id ?? 0)
              ? DateTime.now().subtract(const Duration(hours: 12))
              : [1001, 10, 11, 12].contains(userId)
              ? DateTime.now().subtract(
                  Duration(hours: Random().nextInt(24) + 1),
                )
              : null,
          paymentReference: userId == (currentUser.id ?? 0)
              ? 'MOBICASH123'
              : [1001, 10, 11, 12].contains(userId)
              ? 'AUTO${Random().nextInt(999999)}'
              : null,
        ),
      ),

      // Contributions pour Express Dakar (round 4)
      ...dailyTontine.participantIds.map(
        (userId) => Contribution(
          id: nextContributionId++,
          tontineId: dailyTontine.id ?? 0,
          participantId: userId,
          round: 4,
          amount: dailyTontine.contributionAmount,
          dueDate: dailyTontine.nextContributionDate ?? DateTime.now(),
          status: ContributionStatus.paid,
          paidDate: DateTime.now().subtract(
            Duration(hours: Random().nextInt(6) + 1),
          ),
          paymentReference: 'EXPR${Random().nextInt(999999)}',
        ),
      ),

      // Contributions pour Business Angels (round 1)
      ...quarterlyTontine.participantIds.map(
        (userId) => Contribution(
          id: nextContributionId++,
          tontineId: quarterlyTontine.id ?? 0,
          participantId: userId,
          round: 1,
          amount: quarterlyTontine.contributionAmount,
          dueDate: quarterlyTontine.nextContributionDate ?? DateTime.now(),
          status: userId == 1003
              ? ContributionStatus.paid
              : ContributionStatus.pending,
          paidDate: userId == 1003
              ? DateTime.now().subtract(const Duration(days: 2))
              : null,
          paymentReference: userId == 1003 ? 'BANK_TRANSFER_001' : null,
        ),
      ),

      // Contributions pour Famille Diop (round 6)
      ...familyTontine.participantIds.map(
        (userId) => Contribution(
          id: nextContributionId++,
          tontineId: familyTontine.id ?? 0,
          participantId: userId,
          round: 6,
          amount: familyTontine.contributionAmount,
          dueDate: familyTontine.nextContributionDate ?? DateTime.now(),
          status: [currentUser.id ?? 0, 101, 105, 106, 103].contains(userId)
              ? ContributionStatus.paid
              : ContributionStatus.pending,
          paidDate: [currentUser.id ?? 0, 101, 105, 106, 103].contains(userId)
              ? DateTime.now().subtract(Duration(days: Random().nextInt(3) + 1))
              : null,
          paymentReference:
              [currentUser.id ?? 0, 101, 105, 106, 103].contains(userId)
              ? 'FAM${Random().nextInt(999999)}'
              : null,
        ),
      ),
    ];

    _contributions.addAll(contributions);

    await StorageService.saveTontines(_tontines);
    await StorageService.saveContributions(_contributions);

    print(
      'DEBUG TontineService: Generated ${_tontines.length} tontines for user ${currentUser.id}',
    );
    print(
      'DEBUG TontineService: Generated ${contributions.length} contributions',
    );
    print('DEBUG TontineService: Sample tontine participant IDs:');
    for (var tontine in _tontines) {
      print('  Tontine ${tontine.id}: ${tontine.participantIds}');
    }
  }
}

import 'dart:math';

import 'package:snt_ui_test/app/services/storage_service.dart';

import '../data/models/contribution.dart';
import '../data/models/tontine.dart';

class TontineService {
  static List<Tontine> _tontines = [];
  static List<Contribution> _contributions = [];

  static Future<void> init() async {
    _tontines = StorageService.getTontines();
    _contributions = StorageService.getContributions();
    await _generateSampleData();
  }

  // Create a new tontine
  static Future<String> createTontine({
    required String name,
    required String description,
    String? imageUrl,
    required double contributionAmount,
    required TontineFrequency frequency,
    required DateTime startDate,
    required int maxParticipants,
    required TontineDrawOrder drawOrder,
    required double penaltyPercentage,
    required String organizerId,
    List<String> rules = const [],
  }) async {
    final tontine = Tontine(
      id: _generateId(),
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
  static Future<bool> joinTontine(String tontineId, String userId) async {
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
  static List<Tontine> getUserTontines(String userId) {
    return _tontines.where((t) => t.participantIds.contains(userId)).toList();
  }

  // Get organized tontines
  static List<Tontine> getOrganizedTontines(String userId) {
    return _tontines.where((t) => t.organizerId == userId).toList();
  }

  // Get tontine by ID
  static Tontine? getTontine(String tontineId) {
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
  static Future<bool> startTontine(String tontineId) async {
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
    String tontineId, {
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
  static List<Contribution> getUserContributions(String userId) {
    return _contributions.where((c) => c.participantId == userId).toList();
  }

  // Mark contribution as paid
  static Future<bool> markContributionPaid(
    String contributionId,
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
  static bool isRoundComplete(String tontineId, int round) {
    final roundContributions = getTontineContributions(tontineId, round: round);
    return roundContributions.isNotEmpty &&
        roundContributions.every((c) => c.status == ContributionStatus.paid);
  }

  // Get pot filling percentage for current round
  static double getPotFillingPercentage(String tontineId, int round) {
    final roundContributions = getTontineContributions(tontineId, round: round);
    if (roundContributions.isEmpty) return 0.0;

    final paidCount = roundContributions.where((c) => c.isPaid).length;
    return paidCount / roundContributions.length;
  }

  // Private helper methods
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
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
            id: _generateId(),
            tontineId: tontine.id,
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
    if (_tontines.isNotEmpty) return;

    final currentUser = StorageService.getCurrentUser();
    if (currentUser == null) return;

    // Create sample tontine
    final sampleTontine = Tontine(
      id: 'sample_1',
      name: 'Tontine Famille',
      description: 'Tontine familiale pour épargner ensemble',
      imageUrl:
          'https://pixabay.com/get/g901a3217dfdbfbc2026587c978c1bec295cde87c599a7b9b7919f53a08427bb1d79c61c44daec0192469441d06924cc08bcdd389ce5855911e3b9052b68ab66c_1280.jpg',
      contributionAmount: 25000,
      frequency: TontineFrequency.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      maxParticipants: 12,
      drawOrder: TontineDrawOrder.random,
      penaltyPercentage: 5.0,
      organizerId: currentUser.id,
      status: TontineStatus.active,
      participantIds: [currentUser.id, 'user_2', 'user_3', 'user_4', 'user_5'],
      rules: [
        'Paiement avant le 15 de chaque mois',
        'Pénalité de 5% en cas de retard',
        'Tirage aléatoire équitable',
        'Respect mutuel obligatoire',
      ],
      inviteCode: 'FAM123',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      currentRound: 3,
      nextContributionDate: DateTime.now().add(const Duration(days: 15)),
      currentWinnerId: currentUser.id,
    );

    _tontines.add(sampleTontine);

    // Create sample contributions
    final contributions = [
      Contribution(
        id: 'contrib_1',
        tontineId: 'sample_1',
        participantId: currentUser.id,
        round: 3,
        amount: 25000,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: ContributionStatus.paid,
        paidDate: DateTime.now().subtract(const Duration(hours: 2)),
        paymentReference: 'WAVE123456',
      ),
      Contribution(
        id: 'contrib_2',
        tontineId: 'sample_1',
        participantId: 'user_2',
        round: 3,
        amount: 25000,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: ContributionStatus.paid,
        paidDate: DateTime.now().subtract(const Duration(hours: 1)),
        paymentReference: 'ORANGE789',
      ),
      Contribution(
        id: 'contrib_3',
        tontineId: 'sample_1',
        participantId: 'user_3',
        round: 3,
        amount: 25000,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: ContributionStatus.paid,
        paidDate: DateTime.now().subtract(const Duration(minutes: 30)),
        paymentReference: 'FREE456',
      ),
      Contribution(
        id: 'contrib_4',
        tontineId: 'sample_1',
        participantId: 'user_4',
        round: 3,
        amount: 25000,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: ContributionStatus.pending,
      ),
      Contribution(
        id: 'contrib_5',
        tontineId: 'sample_1',
        participantId: 'user_5',
        round: 3,
        amount: 25000,
        dueDate: DateTime.now().add(const Duration(days: 15)),
        status: ContributionStatus.pending,
      ),
    ];

    _contributions.addAll(contributions);

    await StorageService.saveTontines(_tontines);
    await StorageService.saveContributions(_contributions);
  }
}

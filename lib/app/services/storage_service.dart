import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/contribution.dart';
import '../data/models/tontine.dart';
import '../data/models/user.dart';

class StorageService {
  static const String _userKey = 'current_user';
  static const String _tontinesKey = 'tontines';
  static const String _contributionsKey = 'contributions';
  static const String _roundsKey = 'tontine_rounds';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User management
  static Future<void> saveUser(AppUser user) async {
    final userData = {
      'id': user.id,
      'name': user.name,
      'phone': user.phone,
      'email': user.email,
      'profileImageUrl': user.profileImageUrl,
      'createdAt': user.createdAt.toIso8601String(),
      'level': user.level.name,
      'sunuPoints': user.sunuPoints,
      'reliabilityScore': user.reliabilityScore,
      'tontineIds': user.tontineIds,
      'organizedTontineIds': user.organizedTontineIds,
      'preferences': {
        'darkMode': user.preferences.darkMode,
        'language': user.preferences.language,
        'notificationsEnabled': user.preferences.notificationsEnabled,
        'soundEnabled': user.preferences.soundEnabled,
        'currencyFormat': user.preferences.currencyFormat,
      },
    };
    await _prefs?.setString(_userKey, json.encode(userData));
  }

  static AppUser? getCurrentUser() {
    final userData = _prefs?.getString(_userKey);
    if (userData == null) return null;

    final Map<String, dynamic> data = json.decode(userData);
    return AppUser(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      profileImageUrl: data['profileImageUrl'],
      createdAt: DateTime.parse(data['createdAt']),
      level: UserLevel.values.firstWhere((l) => l.name == data['level']),
      sunuPoints: data['sunuPoints'] ?? 0,
      reliabilityScore: data['reliabilityScore']?.toDouble() ?? 5.0,
      tontineIds: List<String>.from(data['tontineIds'] ?? []),
      organizedTontineIds: List<String>.from(data['organizedTontineIds'] ?? []),
      preferences: UserPreferences(
        darkMode: data['preferences']['darkMode'] ?? false,
        language: data['preferences']['language'] ?? 'fr',
        notificationsEnabled:
            data['preferences']['notificationsEnabled'] ?? true,
        soundEnabled: data['preferences']['soundEnabled'] ?? true,
        currencyFormat: data['preferences']['currencyFormat'] ?? 'FCFA',
      ),
    );
  }

  // Tontine management
  static Future<void> saveTontines(List<Tontine> tontines) async {
    final tontineData = tontines
        .map(
          (t) => {
            'id': t.id,
            'name': t.name,
            'description': t.description,
            'imageUrl': t.imageUrl,
            'contributionAmount': t.contributionAmount,
            'frequency': t.frequency.name,
            'startDate': t.startDate.toIso8601String(),
            'endDate': t.endDate?.toIso8601String(),
            'maxParticipants': t.maxParticipants,
            'drawOrder': t.drawOrder.name,
            'penaltyPercentage': t.penaltyPercentage,
            'organizerId': t.organizerId,
            'status': t.status.name,
            'participantIds': t.participantIds,
            'rules': t.rules,
            'inviteCode': t.inviteCode,
            'createdAt': t.createdAt.toIso8601String(),
            'currentRound': t.currentRound,
            'nextContributionDate': t.nextContributionDate?.toIso8601String(),
            'currentWinnerId': t.currentWinnerId,
          },
        )
        .toList();

    await _prefs?.setString(_tontinesKey, json.encode(tontineData));
  }

  static List<Tontine> getTontines() {
    final tontinesData = _prefs?.getString(_tontinesKey);
    if (tontinesData == null) return [];

    final List<dynamic> data = json.decode(tontinesData);
    return data
        .map(
          (t) => Tontine(
            id: t['id'],
            name: t['name'],
            description: t['description'],
            imageUrl: t['imageUrl'],
            contributionAmount: t['contributionAmount']?.toDouble() ?? 0.0,
            frequency: TontineFrequency.values.firstWhere(
              (f) => f.name == t['frequency'],
            ),
            startDate: DateTime.parse(t['startDate']),
            endDate: t['endDate'] != null ? DateTime.parse(t['endDate']) : null,
            maxParticipants: t['maxParticipants'],
            drawOrder: TontineDrawOrder.values.firstWhere(
              (d) => d.name == t['drawOrder'],
            ),
            penaltyPercentage: t['penaltyPercentage']?.toDouble() ?? 0.0,
            organizerId: t['organizerId'],
            status: TontineStatus.values.firstWhere(
              (s) => s.name == t['status'],
            ),
            participantIds: List<String>.from(t['participantIds'] ?? []),
            rules: List<String>.from(t['rules'] ?? []),
            inviteCode: t['inviteCode'],
            createdAt: DateTime.parse(t['createdAt']),
            currentRound: t['currentRound'] ?? 0,
            nextContributionDate: t['nextContributionDate'] != null
                ? DateTime.parse(t['nextContributionDate'])
                : null,
            currentWinnerId: t['currentWinnerId'],
          ),
        )
        .toList();
  }

  // Contributions management
  static Future<void> saveContributions(
    List<Contribution> contributions,
  ) async {
    final contributionData = contributions
        .map(
          (c) => {
            'id': c.id,
            'tontineId': c.tontineId,
            'participantId': c.participantId,
            'round': c.round,
            'amount': c.amount,
            'dueDate': c.dueDate.toIso8601String(),
            'paidDate': c.paidDate?.toIso8601String(),
            'status': c.status.name,
            'paymentReference': c.paymentReference,
            'penaltyAmount': c.penaltyAmount,
            'notes': c.notes,
          },
        )
        .toList();

    await _prefs?.setString(_contributionsKey, json.encode(contributionData));
  }

  static List<Contribution> getContributions() {
    final contributionsData = _prefs?.getString(_contributionsKey);
    if (contributionsData == null) return [];

    final List<dynamic> data = json.decode(contributionsData);
    return data
        .map(
          (c) => Contribution(
            id: c['id'],
            tontineId: c['tontineId'],
            participantId: c['participantId'],
            round: c['round'],
            amount: c['amount']?.toDouble() ?? 0.0,
            dueDate: DateTime.parse(c['dueDate']),
            paidDate: c['paidDate'] != null
                ? DateTime.parse(c['paidDate'])
                : null,
            status: ContributionStatus.values.firstWhere(
              (s) => s.name == c['status'],
            ),
            paymentReference: c['paymentReference'],
            penaltyAmount: c['penaltyAmount']?.toDouble(),
            notes: c['notes'],
          ),
        )
        .toList();
  }

  static Future<void> clearAllData() async {
    await _prefs?.clear();
  }
}

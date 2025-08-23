import 'package:hive_ce/hive.dart';

part 'tontine.g.dart';

@HiveType(typeId: 3)
class Tontine {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final double contributionAmount;
  @HiveField(5)
  final TontineFrequency frequency;
  @HiveField(6)
  final DateTime startDate;
  @HiveField(7)
  final DateTime? endDate;
  @HiveField(8)
  final int maxParticipants;
  @HiveField(9)
  final TontineDrawOrder drawOrder;
  @HiveField(10)
  final double penaltyPercentage;
  @HiveField(11)
  final int organizerId;
  @HiveField(12)
  final TontineStatus status;
  @HiveField(13)
  final List<int> participantIds;
  @HiveField(14)
  final List<String> rules;
  @HiveField(15)
  final String inviteCode;
  @HiveField(16)
  final DateTime createdAt;
  @HiveField(17)
  final int currentRound;
  @HiveField(18)
  final DateTime? nextContributionDate;
  @HiveField(19)
  final int? currentWinnerId;

  const Tontine({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.maxParticipants,
    required this.drawOrder,
    required this.penaltyPercentage,
    required this.organizerId,
    required this.status,
    required this.participantIds,
    required this.rules,
    required this.inviteCode,
    required this.createdAt,
    this.currentRound = 0,
    this.nextContributionDate,
    this.currentWinnerId,
  });

  int get totalRounds => participantIds.length;
  double get totalPot => contributionAmount * participantIds.length;
  bool get isComplete => currentRound >= totalRounds;

  String get formattedNextPaymentDate => nextContributionDate != null
      ? '${nextContributionDate!.day}/${nextContributionDate!.month}/${nextContributionDate!.year}'
      : 'N/A';

  get progress => participantIds.isEmpty
      ? 0.0
      : (currentRound / totalRounds).clamp(0.0, 1.0);

  get members => participantIds.length;

  Tontine copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? contributionAmount,
    TontineFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    TontineDrawOrder? drawOrder,
    double? penaltyPercentage,
    int? organizerId,
    TontineStatus? status,
    List<int>? participantIds,
    List<String>? rules,
    String? inviteCode,
    DateTime? createdAt,
    int? currentRound,
    DateTime? nextContributionDate,
    int? currentWinnerId,
  }) => Tontine(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    contributionAmount: contributionAmount ?? this.contributionAmount,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    maxParticipants: maxParticipants ?? this.maxParticipants,
    drawOrder: drawOrder ?? this.drawOrder,
    penaltyPercentage: penaltyPercentage ?? this.penaltyPercentage,
    organizerId: organizerId ?? this.organizerId,
    status: status ?? this.status,
    participantIds: participantIds ?? this.participantIds,
    rules: rules ?? this.rules,
    inviteCode: inviteCode ?? this.inviteCode,
    createdAt: createdAt ?? this.createdAt,
    currentRound: currentRound ?? this.currentRound,
    nextContributionDate: nextContributionDate ?? this.nextContributionDate,
    currentWinnerId: currentWinnerId ?? this.currentWinnerId,
  );
}

@HiveType(typeId: 4)
enum TontineFrequency {
  @HiveField(0)
  daily('Quotidien'),
  @HiveField(1)
  weekly('Hebdomadaire'),
  @HiveField(2)
  biweekly('Bimensuel'),
  @HiveField(3)
  monthly('Mensuel'),
  @HiveField(4)
  quarterly('Trimestriel');

  const TontineFrequency(this.label);
  final String label;
}

@HiveType(typeId: 5)
enum TontineDrawOrder {
  @HiveField(0)
  fixed('Ordre fixe'),
  @HiveField(1)
  random('Tirage aléatoire'),
  @HiveField(2)
  merit('Ordre au mérite'),
  @HiveField(3)
  hybrid('Hybride');

  const TontineDrawOrder(this.label);
  final String label;
}

@HiveType(typeId: 6)
enum TontineStatus {
  @HiveField(0)
  pending('En attente'),
  @HiveField(1)
  active('Active'),
  @HiveField(2)
  completed('Terminée'),
  @HiveField(3)
  cancelled('Annulée');

  const TontineStatus(this.label);
  final String label;
}

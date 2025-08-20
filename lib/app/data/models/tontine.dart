class Tontine {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double contributionAmount;
  final TontineFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final int maxParticipants;
  final TontineDrawOrder drawOrder;
  final double penaltyPercentage;
  final String organizerId;
  final TontineStatus status;
  final List<String> participantIds;
  final List<String> rules;
  final String inviteCode;
  final DateTime createdAt;
  final int currentRound;
  final DateTime? nextContributionDate;
  final String? currentWinnerId;
  
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
  
  Tontine copyWith({
    String? id,
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
    String? organizerId,
    TontineStatus? status,
    List<String>? participantIds,
    List<String>? rules,
    String? inviteCode,
    DateTime? createdAt,
    int? currentRound,
    DateTime? nextContributionDate,
    String? currentWinnerId,
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

enum TontineFrequency {
  daily('Quotidien'),
  weekly('Hebdomadaire'),
  biweekly('Bimensuel'),
  monthly('Mensuel'),
  quarterly('Trimestriel');
  
  const TontineFrequency(this.label);
  final String label;
}

enum TontineDrawOrder {
  fixed('Ordre fixe'),
  random('Tirage aléatoire'),
  merit('Ordre au mérite'),
  hybrid('Hybride');
  
  const TontineDrawOrder(this.label);
  final String label;
}

enum TontineStatus {
  pending('En attente'),
  active('Active'),
  completed('Terminée'),
  cancelled('Annulée');
  
  const TontineStatus(this.label);
  final String label;
}
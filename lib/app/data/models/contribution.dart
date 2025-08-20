class Contribution {
  final String id;
  final String tontineId;
  final String participantId;
  final int round;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final ContributionStatus status;
  final String? paymentReference;
  final double? penaltyAmount;
  final String? notes;
  
  const Contribution({
    required this.id,
    required this.tontineId,
    required this.participantId,
    required this.round,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.paymentReference,
    this.penaltyAmount,
    this.notes,
  });
  
  bool get isPaid => status == ContributionStatus.paid;
  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isPaid;
  double get totalAmount => amount + (penaltyAmount ?? 0);
  
  Contribution copyWith({
    String? id,
    String? tontineId,
    String? participantId,
    int? round,
    double? amount,
    DateTime? dueDate,
    DateTime? paidDate,
    ContributionStatus? status,
    String? paymentReference,
    double? penaltyAmount,
    String? notes,
  }) => Contribution(
    id: id ?? this.id,
    tontineId: tontineId ?? this.tontineId,
    participantId: participantId ?? this.participantId,
    round: round ?? this.round,
    amount: amount ?? this.amount,
    dueDate: dueDate ?? this.dueDate,
    paidDate: paidDate ?? this.paidDate,
    status: status ?? this.status,
    paymentReference: paymentReference ?? this.paymentReference,
    penaltyAmount: penaltyAmount ?? this.penaltyAmount,
    notes: notes ?? this.notes,
  );
}

enum ContributionStatus {
  pending('En attente'),
  paid('Payé'),
  late('En retard'),
  failed('Échec');
  
  const ContributionStatus(this.label);
  final String label;
}

class TontineRound {
  final int roundNumber;
  final String tontineId;
  final String winnerId;
  final double totalAmount;
  final DateTime distributionDate;
  final List<Contribution> contributions;
  final RoundStatus status;
  
  const TontineRound({
    required this.roundNumber,
    required this.tontineId,
    required this.winnerId,
    required this.totalAmount,
    required this.distributionDate,
    required this.contributions,
    required this.status,
  });
  
  double get collectedAmount => contributions
      .where((c) => c.isPaid)
      .fold(0.0, (sum, c) => sum + c.totalAmount);
      
  bool get isComplete => contributions.every((c) => c.isPaid);
  
  TontineRound copyWith({
    int? roundNumber,
    String? tontineId,
    String? winnerId,
    double? totalAmount,
    DateTime? distributionDate,
    List<Contribution>? contributions,
    RoundStatus? status,
  }) => TontineRound(
    roundNumber: roundNumber ?? this.roundNumber,
    tontineId: tontineId ?? this.tontineId,
    winnerId: winnerId ?? this.winnerId,
    totalAmount: totalAmount ?? this.totalAmount,
    distributionDate: distributionDate ?? this.distributionDate,
    contributions: contributions ?? this.contributions,
    status: status ?? this.status,
  );
}

enum RoundStatus {
  collecting('Collection'),
  ready('Prêt'),
  distributed('Distribué'),
  completed('Terminé');
  
  const RoundStatus(this.label);
  final String label;
}
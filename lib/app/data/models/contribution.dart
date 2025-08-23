import 'package:hive_ce/hive.dart';

part 'contribution.g.dart';

@HiveType(typeId: 1)
class Contribution {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String tontineId;
  @HiveField(2)
  final String participantId;
  @HiveField(3)
  final int round;
  @HiveField(4)
  final double amount;
  @HiveField(5)
  final DateTime dueDate;
  @HiveField(6)
  final DateTime? paidDate;
  @HiveField(7)
  final ContributionStatus status;
  @HiveField(8)
  final String? paymentReference;
  @HiveField(9)
  final double? penaltyAmount;
  @HiveField(10)
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

@HiveType(typeId: 2)
enum ContributionStatus {
  @HiveField(0)
  pending('En attente'),
  @HiveField(1)
  paid('Payé'),
  @HiveField(2)
  late('En retard'),
  @HiveField(3)
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

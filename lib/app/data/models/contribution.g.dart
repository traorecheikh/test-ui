// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContributionAdapter extends TypeAdapter<Contribution> {
  @override
  final typeId = 1;

  @override
  Contribution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contribution(
      id: (fields[0] as num).toInt(),
      tontineId: (fields[1] as num).toInt(),
      participantId: (fields[2] as num).toInt(),
      round: (fields[3] as num).toInt(),
      amount: (fields[4] as num).toDouble(),
      dueDate: fields[5] as DateTime,
      paidDate: fields[6] as DateTime?,
      status: fields[7] as ContributionStatus,
      paymentReference: fields[8] as String?,
      penaltyAmount: (fields[9] as num?)?.toDouble(),
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Contribution obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tontineId)
      ..writeByte(2)
      ..write(obj.participantId)
      ..writeByte(3)
      ..write(obj.round)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.paidDate)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.paymentReference)
      ..writeByte(9)
      ..write(obj.penaltyAmount)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContributionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContributionStatusAdapter extends TypeAdapter<ContributionStatus> {
  @override
  final typeId = 2;

  @override
  ContributionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContributionStatus.pending;
      case 1:
        return ContributionStatus.paid;
      case 2:
        return ContributionStatus.late;
      case 3:
        return ContributionStatus.failed;
      default:
        return ContributionStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ContributionStatus obj) {
    switch (obj) {
      case ContributionStatus.pending:
        writer.writeByte(0);
      case ContributionStatus.paid:
        writer.writeByte(1);
      case ContributionStatus.late:
        writer.writeByte(2);
      case ContributionStatus.failed:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContributionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

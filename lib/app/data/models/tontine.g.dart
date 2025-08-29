// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tontine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TontineAdapter extends TypeAdapter<Tontine> {
  @override
  final typeId = 3;

  @override
  Tontine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tontine(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String?,
      contributionAmount: (fields[4] as num).toDouble(),
      frequency: fields[5] as TontineFrequency,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime?,
      maxParticipants: (fields[8] as num).toInt(),
      drawOrder: fields[9] as TontineDrawOrder,
      penaltyPercentage: (fields[10] as num).toDouble(),
      organizerId: (fields[11] as num).toInt(),
      status: fields[12] as TontineStatus,
      participantIds: (fields[13] as List).cast<int>(),
      rules: (fields[14] as List).cast<String>(),
      inviteCode: fields[15] as String,
      createdAt: fields[16] as DateTime,
      currentRound: fields[17] == null ? 0 : (fields[17] as num).toInt(),
      nextContributionDate: fields[18] as DateTime?,
      currentWinnerId: (fields[19] as num?)?.toInt(),
      category: fields[20] as TontineCategory? ?? TontineCategory.regular,
    );
  }

  @override
  void write(BinaryWriter writer, Tontine obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.contributionAmount)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.maxParticipants)
      ..writeByte(9)
      ..write(obj.drawOrder)
      ..writeByte(10)
      ..write(obj.penaltyPercentage)
      ..writeByte(11)
      ..write(obj.organizerId)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.participantIds)
      ..writeByte(14)
      ..write(obj.rules)
      ..writeByte(15)
      ..write(obj.inviteCode)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.currentRound)
      ..writeByte(18)
      ..write(obj.nextContributionDate)
      ..writeByte(19)
      ..write(obj.currentWinnerId)
      ..writeByte(20)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TontineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TontineFrequencyAdapter extends TypeAdapter<TontineFrequency> {
  @override
  final typeId = 4;

  @override
  TontineFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TontineFrequency.daily;
      case 1:
        return TontineFrequency.weekly;
      case 2:
        return TontineFrequency.biweekly;
      case 3:
        return TontineFrequency.monthly;
      case 4:
        return TontineFrequency.quarterly;
      default:
        return TontineFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, TontineFrequency obj) {
    switch (obj) {
      case TontineFrequency.daily:
        writer.writeByte(0);
      case TontineFrequency.weekly:
        writer.writeByte(1);
      case TontineFrequency.biweekly:
        writer.writeByte(2);
      case TontineFrequency.monthly:
        writer.writeByte(3);
      case TontineFrequency.quarterly:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TontineFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TontineDrawOrderAdapter extends TypeAdapter<TontineDrawOrder> {
  @override
  final typeId = 5;

  @override
  TontineDrawOrder read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TontineDrawOrder.fixed;
      case 1:
        return TontineDrawOrder.random;
      case 2:
        return TontineDrawOrder.merit;
      case 3:
        return TontineDrawOrder.hybrid;
      default:
        return TontineDrawOrder.fixed;
    }
  }

  @override
  void write(BinaryWriter writer, TontineDrawOrder obj) {
    switch (obj) {
      case TontineDrawOrder.fixed:
        writer.writeByte(0);
      case TontineDrawOrder.random:
        writer.writeByte(1);
      case TontineDrawOrder.merit:
        writer.writeByte(2);
      case TontineDrawOrder.hybrid:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TontineDrawOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TontineStatusAdapter extends TypeAdapter<TontineStatus> {
  @override
  final typeId = 6;

  @override
  TontineStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TontineStatus.pending;
      case 1:
        return TontineStatus.active;
      case 2:
        return TontineStatus.completed;
      case 3:
        return TontineStatus.cancelled;
      default:
        return TontineStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TontineStatus obj) {
    switch (obj) {
      case TontineStatus.pending:
        writer.writeByte(0);
      case TontineStatus.active:
        writer.writeByte(1);
      case TontineStatus.completed:
        writer.writeByte(2);
      case TontineStatus.cancelled:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TontineStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TontineCategoryAdapter extends TypeAdapter<TontineCategory> {
  @override
  final typeId = 7;

  @override
  TontineCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TontineCategory.regular;
      case 1:
        return TontineCategory.cagnotte;
      default:
        return TontineCategory.regular;
    }
  }

  @override
  void write(BinaryWriter writer, TontineCategory obj) {
    switch (obj) {
      case TontineCategory.regular:
        writer.writeByte(0);
      case TontineCategory.cagnotte:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TontineCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

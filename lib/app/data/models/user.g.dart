// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final typeId = 10;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      phone: fields[2] as String,
      email: fields[3] as String?,
      profileImageUrl: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      level: fields[6] == null ? UserLevel.novice : fields[6] as UserLevel,
      sunuPoints: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      reliabilityScore: fields[8] == null ? 5.0 : (fields[8] as num).toDouble(),
      tontineIds: fields[9] == null
          ? const []
          : (fields[9] as List).cast<int>(),
      organizedTontineIds: fields[10] == null
          ? const []
          : (fields[10] as List).cast<int>(),
      preferences: fields[11] as UserPreferences,
      achievements: fields[12] == null
          ? const []
          : (fields[12] as List).cast<Achievement>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.profileImageUrl)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.sunuPoints)
      ..writeByte(8)
      ..write(obj.reliabilityScore)
      ..writeByte(9)
      ..write(obj.tontineIds)
      ..writeByte(10)
      ..write(obj.organizedTontineIds)
      ..writeByte(11)
      ..write(obj.preferences)
      ..writeByte(12)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final typeId = 12;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      darkMode: fields[0] == null ? false : fields[0] as bool,
      language: fields[1] == null ? 'fr' : fields[1] as String,
      notificationsEnabled: fields[2] == null ? true : fields[2] as bool,
      soundEnabled: fields[3] == null ? true : fields[3] as bool,
      currencyFormat: fields[4] == null ? 'FCFA' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.notificationsEnabled)
      ..writeByte(3)
      ..write(obj.soundEnabled)
      ..writeByte(4)
      ..write(obj.currencyFormat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final typeId = 13;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      dateEarned: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserLevelAdapter extends TypeAdapter<UserLevel> {
  @override
  final typeId = 11;

  @override
  UserLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserLevel.novice;
      case 1:
        return UserLevel.regular;
      case 2:
        return UserLevel.pro;
      case 3:
        return UserLevel.expert;
      case 4:
        return UserLevel.legend;
      default:
        return UserLevel.novice;
    }
  }

  @override
  void write(BinaryWriter writer, UserLevel obj) {
    switch (obj) {
      case UserLevel.novice:
        writer.writeByte(0);
      case UserLevel.regular:
        writer.writeByte(1);
      case UserLevel.pro:
        writer.writeByte(2);
      case UserLevel.expert:
        writer.writeByte(3);
      case UserLevel.legend:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

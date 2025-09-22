// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FaqItemAdapter extends TypeAdapter<FaqItem> {
  @override
  final typeId = 14;

  @override
  FaqItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FaqItem(
      id: fields[0] as String,
      questionKey: fields[1] as String,
      answerKey: fields[2] as String,
      category: fields[3] as FaqCategory,
      keywords: (fields[4] as List).cast<String>(),
      iconPath: fields[5] as String?,
      isPopular: fields[6] == null ? false : fields[6] as bool,
      priority: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      relatedQuestionIds: fields[8] == null
          ? const []
          : (fields[8] as List).cast<String>(),
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime?,
      isActive: fields[11] == null ? true : fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FaqItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionKey)
      ..writeByte(2)
      ..write(obj.answerKey)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.keywords)
      ..writeByte(5)
      ..write(obj.iconPath)
      ..writeByte(6)
      ..write(obj.isPopular)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.relatedQuestionIds)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final typeId = 16;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      id: fields[0] as String,
      type: fields[1] as ChatMessageType,
      content: fields[2] as String,
      timestamp: fields[3] as DateTime,
      questionId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.questionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FaqAnalyticsAdapter extends TypeAdapter<FaqAnalytics> {
  @override
  final typeId = 18;

  @override
  FaqAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FaqAnalytics(
      questionId: fields[0] as String,
      viewCount: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      helpfulCount: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      notHelpfulCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      firstViewed: fields[4] as DateTime,
      lastViewed: fields[5] as DateTime,
      searchTerms: fields[6] == null
          ? const []
          : (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FaqAnalytics obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.viewCount)
      ..writeByte(2)
      ..write(obj.helpfulCount)
      ..writeByte(3)
      ..write(obj.notHelpfulCount)
      ..writeByte(4)
      ..write(obj.firstViewed)
      ..writeByte(5)
      ..write(obj.lastViewed)
      ..writeByte(6)
      ..write(obj.searchTerms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FaqCategoryAdapter extends TypeAdapter<FaqCategory> {
  @override
  final typeId = 15;

  @override
  FaqCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FaqCategory.security;
      case 1:
        return FaqCategory.howItWorks;
      case 2:
        return FaqCategory.money;
      case 3:
        return FaqCategory.social;
      case 4:
        return FaqCategory.technical;
      case 5:
        return FaqCategory.legal;
      default:
        return FaqCategory.security;
    }
  }

  @override
  void write(BinaryWriter writer, FaqCategory obj) {
    switch (obj) {
      case FaqCategory.security:
        writer.writeByte(0);
      case FaqCategory.howItWorks:
        writer.writeByte(1);
      case FaqCategory.money:
        writer.writeByte(2);
      case FaqCategory.social:
        writer.writeByte(3);
      case FaqCategory.technical:
        writer.writeByte(4);
      case FaqCategory.legal:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageTypeAdapter extends TypeAdapter<ChatMessageType> {
  @override
  final typeId = 17;

  @override
  ChatMessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatMessageType.bot;
      case 1:
        return ChatMessageType.user;
      case 2:
        return ChatMessageType.suggestion;
      case 3:
        return ChatMessageType.system;
      case 4:
        return ChatMessageType.quickAction;
      default:
        return ChatMessageType.bot;
    }
  }

  @override
  void write(BinaryWriter writer, ChatMessageType obj) {
    switch (obj) {
      case ChatMessageType.bot:
        writer.writeByte(0);
      case ChatMessageType.user:
        writer.writeByte(1);
      case ChatMessageType.suggestion:
        writer.writeByte(2);
      case ChatMessageType.system:
        writer.writeByte(3);
      case ChatMessageType.quickAction:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

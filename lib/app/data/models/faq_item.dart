import 'package:hive_ce/hive.dart';

part 'faq_item.g.dart';

@HiveType(typeId: 14)
class FaqItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String questionKey;
  @HiveField(2)
  final String answerKey;
  @HiveField(3)
  final FaqCategory category;
  @HiveField(4)
  final List<String> keywords;
  @HiveField(5)
  final String? iconPath;
  @HiveField(6)
  final bool isPopular;
  @HiveField(7)
  final int priority;
  @HiveField(8)
  final List<String> relatedQuestionIds;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final DateTime? updatedAt;
  @HiveField(11)
  final bool isActive;

  const FaqItem({
    required this.id,
    required this.questionKey,
    required this.answerKey,
    required this.category,
    required this.keywords,
    this.iconPath,
    this.isPopular = false,
    this.priority = 0,
    this.relatedQuestionIds = const [],
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  FaqItem copyWith({
    String? id,
    String? questionKey,
    String? answerKey,
    FaqCategory? category,
    List<String>? keywords,
    String? iconPath,
    bool? isPopular,
    int? priority,
    List<String>? relatedQuestionIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) => FaqItem(
    id: id ?? this.id,
    questionKey: questionKey ?? this.questionKey,
    answerKey: answerKey ?? this.answerKey,
    category: category ?? this.category,
    keywords: keywords ?? this.keywords,
    iconPath: iconPath ?? this.iconPath,
    isPopular: isPopular ?? this.isPopular,
    priority: priority ?? this.priority,
    relatedQuestionIds: relatedQuestionIds ?? this.relatedQuestionIds,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isActive: isActive ?? this.isActive,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FaqItem{id: $id, questionKey: $questionKey, category: $category}';
  }
}

@HiveType(typeId: 15)
enum FaqCategory {
  @HiveField(0)
  security('🛡️', 'security', 'security_category'),
  @HiveField(1)
  howItWorks('🎯', 'how_it_works', 'how_it_works_category'),
  @HiveField(2)
  money('💰', 'money_payments', 'money_payments_category'),
  @HiveField(3)
  social('👥', 'social_features', 'social_features_category'),
  @HiveField(4)
  technical('⚙️', 'technical_support', 'technical_support_category'),
  @HiveField(5)
  legal('📋', 'legal_compliance', 'legal_compliance_category');

  const FaqCategory(this.emoji, this.key, this.titleKey);

  final String emoji;
  final String key;
  final String titleKey;
}

@HiveType(typeId: 16)
class ChatMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final ChatMessageType type;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final String? questionId;

  const ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.questionId,
  });

  ChatMessage copyWith({
    String? id,
    ChatMessageType? type,
    String? content,
    DateTime? timestamp,
    String? questionId,
  }) => ChatMessage(
    id: id ?? this.id,
    type: type ?? this.type,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
    questionId: questionId ?? this.questionId,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 17)
enum ChatMessageType {
  @HiveField(0)
  bot('bot'),
  @HiveField(1)
  user('user'),
  @HiveField(2)
  suggestion('suggestion'),
  @HiveField(3)
  system('system'),
  @HiveField(4)
  quickAction('quick_action');

  const ChatMessageType(this.key);
  final String key;
}

@HiveType(typeId: 18)
class FaqAnalytics {
  @HiveField(0)
  final String questionId;
  @HiveField(1)
  final int viewCount;
  @HiveField(2)
  final int helpfulCount;
  @HiveField(3)
  final int notHelpfulCount;
  @HiveField(4)
  final DateTime firstViewed;
  @HiveField(5)
  final DateTime lastViewed;
  @HiveField(6)
  final List<String> searchTerms;

  const FaqAnalytics({
    required this.questionId,
    this.viewCount = 0,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
    required this.firstViewed,
    required this.lastViewed,
    this.searchTerms = const [],
  });

  FaqAnalytics copyWith({
    String? questionId,
    int? viewCount,
    int? helpfulCount,
    int? notHelpfulCount,
    DateTime? firstViewed,
    DateTime? lastViewed,
    List<String>? searchTerms,
  }) => FaqAnalytics(
    questionId: questionId ?? this.questionId,
    viewCount: viewCount ?? this.viewCount,
    helpfulCount: helpfulCount ?? this.helpfulCount,
    notHelpfulCount: notHelpfulCount ?? this.notHelpfulCount,
    firstViewed: firstViewed ?? this.firstViewed,
    lastViewed: lastViewed ?? this.lastViewed,
    searchTerms: searchTerms ?? this.searchTerms,
  );

  double get helpfulnessRatio {
    final totalFeedback = helpfulCount + notHelpfulCount;
    if (totalFeedback == 0) return 0.0;
    return helpfulCount / totalFeedback;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqAnalytics &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId;

  @override
  int get hashCode => questionId.hashCode;
}
import 'dart:async';
import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

import '../data/models/faq_item.dart';
import 'storage_service.dart';

/// Enterprise-level FAQ service with comprehensive error handling,
/// analytics tracking, and performance optimization
class FaqService extends GetxService {
  static const String _faqBoxName = 'faq_box';
  static const String _analyticsBoxName = 'faq_analytics_box';
  static const String _chatHistoryBoxName = 'faq_chat_history_box';

  static Box<FaqItem>? _faqBox;
  static Box<FaqAnalytics>? _analyticsBox;
  static Box<ChatMessage>? _chatHistoryBox;

  final Uuid _uuid = const Uuid();
  final RxBool _isInitialized = false.obs;
  final RxString _lastError = ''.obs;

  // Performance metrics
  final RxInt _totalQuestions = 0.obs;
  final RxInt _popularQuestions = 0.obs;
  final RxDouble _averageHelpfulness = 0.0.obs;

  // Getters
  bool get isInitialized => _isInitialized.value;
  String get lastError => _lastError.value;
  int get totalQuestions => _totalQuestions.value;
  int get popularQuestions => _popularQuestions.value;
  double get averageHelpfulness => _averageHelpfulness.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeService();
  }

  /// Initialize the FAQ service with error handling and data seeding
  Future<void> _initializeService() async {
    try {
      dev.log('FaqService: Initializing FAQ service...', name: 'FAQ_SERVICE');

      await _openHiveBoxes();
      await _seedInitialData();
      await _updateMetrics();

      _isInitialized.value = true;
      _lastError.value = '';

      dev.log('FaqService: Service initialized successfully', name: 'FAQ_SERVICE');
    } catch (e, stackTrace) {
      _lastError.value = 'Failed to initialize FAQ service: $e';
      dev.log(
        'FaqService: Initialization failed',
        error: e,
        stackTrace: stackTrace,
        name: 'FAQ_SERVICE',
      );
      rethrow;
    }
  }

  /// Open and initialize Hive boxes with error handling
  Future<void> _openHiveBoxes() async {
    try {
      _faqBox = await Hive.openBox<FaqItem>(_faqBoxName);
      _analyticsBox = await Hive.openBox<FaqAnalytics>(_analyticsBoxName);
      _chatHistoryBox = await Hive.openBox<ChatMessage>(_chatHistoryBoxName);

      dev.log('FaqService: Hive boxes opened successfully', name: 'FAQ_SERVICE');
    } catch (e) {
      dev.log('FaqService: Failed to open Hive boxes', error: e, name: 'FAQ_SERVICE');
      rethrow;
    }
  }

  /// Seed initial FAQ data if not already present
  Future<void> _seedInitialData() async {
    try {
      if (_faqBox?.isEmpty ?? true) {
        final initialFaqs = _getInitialFaqData();

        for (final faq in initialFaqs) {
          await _faqBox?.put(faq.id, faq);
        }

        dev.log('FaqService: Seeded ${initialFaqs.length} initial FAQ items', name: 'FAQ_SERVICE');
      }
    } catch (e) {
      dev.log('FaqService: Failed to seed initial data', error: e, name: 'FAQ_SERVICE');
      rethrow;
    }
  }

  /// Get the 10 CORE FAQ QUESTIONS - These will NEVER change
  /// STATIC FOUNDATION for current non-AI version
  /// FUTURE: Same 10 questions + answers will be enhanced with Genkit NLP
  List<FaqItem> _getInitialFaqData() {
    final now = DateTime.now();

    // THE 10 CRITICAL QUESTIONS - Static foundation for AI evolution
    return [
      FaqItem(
        id: '1',
        questionKey: 'faq_money_safety_question',
        answerKey: 'faq_money_safety_answer',
        category: FaqCategory.security,
        keywords: ['argent', 'sécurité', 'voler', 'sûr', 'money', 'safe', 'steal', 'secure'],
        isPopular: true,
        priority: 10,
        relatedQuestionIds: ['2', '9'],
        createdAt: now,
        iconPath: 'security',
      ),
      FaqItem(
        id: '2',
        questionKey: 'faq_money_flow_question',
        answerKey: 'faq_money_flow_answer',
        category: FaqCategory.money,
        keywords: ['paiement', 'argent', 'va', 'cotisation', 'payment', 'money', 'flow', 'où'],
        isPopular: true,
        priority: 9,
        relatedQuestionIds: ['1', '3'],
        createdAt: now,
        iconPath: 'payment',
      ),
      FaqItem(
        id: '3',
        questionKey: 'faq_receive_money_question',
        answerKey: 'faq_receive_money_answer',
        category: FaqCategory.money,
        keywords: ['recevoir', 'tour', 'gagner', 'receive', 'money', 'turn', 'win', 'comment'],
        isPopular: true,
        priority: 8,
        relatedQuestionIds: ['2', '4'],
        createdAt: now,
        iconPath: 'receive',
      ),
      FaqItem(
        id: '4',
        questionKey: 'faq_member_not_pay_question',
        answerKey: 'faq_member_not_pay_answer',
        category: FaqCategory.security,
        keywords: ['paie pas', 'défaut', 'problème', 'not pay', 'default', 'problem', 'member'],
        isPopular: true,
        priority: 7,
        relatedQuestionIds: ['1', '5'],
        createdAt: now,
        iconPath: 'warning',
      ),
      FaqItem(
        id: '5',
        questionKey: 'faq_fair_selection_question',
        answerKey: 'faq_fair_selection_answer',
        category: FaqCategory.howItWorks,
        keywords: ['choisit', 'gagne', 'juste', 'transparent', 'fair', 'selection', 'winner', 'tirage'],
        isPopular: true,
        priority: 6,
        relatedQuestionIds: ['4', '6'],
        createdAt: now,
        iconPath: 'fairness',
      ),
      FaqItem(
        id: '6',
        questionKey: 'faq_vs_whatsapp_question',
        answerKey: 'faq_vs_whatsapp_answer',
        category: FaqCategory.howItWorks,
        keywords: ['WhatsApp', 'différence', 'pourquoi', 'why', 'difference', 'better', 'avantage'],
        isPopular: true,
        priority: 5,
        relatedQuestionIds: ['5', '7'],
        createdAt: now,
        iconPath: 'comparison',
      ),
      FaqItem(
        id: '7',
        questionKey: 'faq_tech_skills_question',
        answerKey: 'faq_tech_skills_answer',
        category: FaqCategory.howItWorks,
        keywords: ['technologie', 'difficile', 'tech', 'easy', 'difficult', 'skills', 'simple'],
        isPopular: true,
        priority: 4,
        relatedQuestionIds: ['6', '8'],
        createdAt: now,
        iconPath: 'tech',
      ),
      FaqItem(
        id: '8',
        questionKey: 'faq_demo_mode_question',
        answerKey: 'faq_demo_mode_answer',
        category: FaqCategory.howItWorks,
        keywords: ['essayer', 'démo', 'test', 'demo', 'try', 'practice', 'apprendre'],
        isPopular: true,
        priority: 3,
        relatedQuestionIds: ['7', '9'],
        createdAt: now,
        iconPath: 'demo',
      ),
      FaqItem(
        id: '9',
        questionKey: 'faq_app_disappears_question',
        answerKey: 'faq_app_disappears_answer',
        category: FaqCategory.security,
        keywords: ['disparaît', 'arrête', 'sécurité', 'disappear', 'security', 'backup', 'données'],
        isPopular: true,
        priority: 2,
        relatedQuestionIds: ['1', '10'],
        createdAt: now,
        iconPath: 'backup',
      ),
      FaqItem(
        id: '10',
        questionKey: 'faq_invite_friends_question',
        answerKey: 'faq_invite_friends_answer',
        category: FaqCategory.social,
        keywords: ['inviter', 'famille', 'amis', 'invite', 'friends', 'family', 'share', 'partager'],
        isPopular: true,
        priority: 1,
        relatedQuestionIds: ['9', '1'],
        createdAt: now,
        iconPath: 'invite',
      ),
    ];
  }

  /// Get all FAQ items with error handling
  List<FaqItem> getAllFaqs() {
    try {
      if (!_isInitialized.value) {
        dev.log('FaqService: Service not initialized', name: 'FAQ_SERVICE');
        return [];
      }

      final faqs = _faqBox?.values.where((faq) => faq.isActive).toList() ?? [];
      faqs.sort((a, b) => b.priority.compareTo(a.priority));

      return faqs;
    } catch (e) {
      dev.log('FaqService: Error getting all FAQs', error: e, name: 'FAQ_SERVICE');
      _lastError.value = 'Failed to load FAQ items: $e';
      return [];
    }
  }

  /// Get FAQs by category with performance optimization
  List<FaqItem> getFaqsByCategory(FaqCategory category) {
    try {
      return getAllFaqs()
          .where((faq) => faq.category == category)
          .toList();
    } catch (e) {
      dev.log('FaqService: Error getting FAQs by category', error: e, name: 'FAQ_SERVICE');
      return [];
    }
  }

  /// Get popular FAQs based on analytics and priority
  List<FaqItem> getPopularFaqs({int limit = 6}) {
    try {
      return getAllFaqs()
          .where((faq) => faq.isPopular)
          .take(limit)
          .toList();
    } catch (e) {
      dev.log('FaqService: Error getting popular FAQs', error: e, name: 'FAQ_SERVICE');
      return [];
    }
  }

  /// Search FAQs with simple keyword matching (Static Version)
  /// TODO: Replace with Genkit NLP processing in future AI version
  List<FaqItem> searchFaqs(String query) {
    try {
      if (query.trim().isEmpty) return getAllFaqs();

      // FUTURE: This is where Genkit NLP will be integrated
      // For now: Simple static keyword matching for the 10 core questions
      return _performStaticSearch(query);
    } catch (e) {
      dev.log('FaqService: Error searching FAQs', error: e, name: 'FAQ_SERVICE');
      return [];
    }
  }

  /// Static keyword matching - will be enhanced with Genkit NLP
  List<FaqItem> _performStaticSearch(String query) {
    final searchTerms = query.toLowerCase().split(' ');
    final allFaqs = getAllFaqs();
    final results = <FaqItem>[];

    for (final faq in allFaqs) {
      // Simple keyword matching in predefined keywords
      bool matches = false;

      for (final term in searchTerms) {
        for (final keyword in faq.keywords) {
          if (keyword.toLowerCase().contains(term)) {
            matches = true;
            break;
          }
        }
        if (matches) break;
      }

      if (matches) {
        results.add(faq);
      }
    }

    // Sort popular items first (static prioritization)
    results.sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return b.priority.compareTo(a.priority);
    });

    // Track search analytics
    _trackSearchAnalytics(query, results.map((e) => e.id).toList());

    return results;
  }

  /// Get FAQ item by ID with error handling
  FaqItem? getFaqById(String id) {
    try {
      return _faqBox?.get(id);
    } catch (e) {
      dev.log('FaqService: Error getting FAQ by ID', error: e, name: 'FAQ_SERVICE');
      return null;
    }
  }

  /// Get related questions for a given FAQ
  List<FaqItem> getRelatedFaqs(String faqId, {int limit = 3}) {
    try {
      final faq = getFaqById(faqId);
      if (faq == null) return [];

      final relatedIds = faq.relatedQuestionIds;
      final relatedFaqs = <FaqItem>[];

      for (final id in relatedIds) {
        final relatedFaq = getFaqById(id);
        if (relatedFaq != null && relatedFaq.isActive) {
          relatedFaqs.add(relatedFaq);
        }
        if (relatedFaqs.length >= limit) break;
      }

      // If not enough related FAQs, fill with same category
      if (relatedFaqs.length < limit) {
        final sameCategoryFaqs = getFaqsByCategory(faq.category)
            .where((f) => f.id != faqId && !relatedFaqs.contains(f))
            .take(limit - relatedFaqs.length);
        relatedFaqs.addAll(sameCategoryFaqs);
      }

      return relatedFaqs;
    } catch (e) {
      dev.log('FaqService: Error getting related FAQs', error: e, name: 'FAQ_SERVICE');
      return [];
    }
  }

  /// Track FAQ view analytics
  Future<void> trackFaqView(String faqId) async {
    try {
      final now = DateTime.now();
      var analytics = _analyticsBox?.get(faqId);

      if (analytics == null) {
        analytics = FaqAnalytics(
          questionId: faqId,
          viewCount: 1,
          firstViewed: now,
          lastViewed: now,
        );
      } else {
        analytics = analytics.copyWith(
          viewCount: analytics.viewCount + 1,
          lastViewed: now,
        );
      }

      await _analyticsBox?.put(faqId, analytics);
      await _updateMetrics();

      dev.log('FaqService: Tracked view for FAQ $faqId', name: 'FAQ_SERVICE');
    } catch (e) {
      dev.log('FaqService: Error tracking FAQ view', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Track FAQ helpfulness feedback
  Future<void> trackFaqFeedback(String faqId, bool isHelpful) async {
    try {
      var analytics = _analyticsBox?.get(faqId);

      if (analytics == null) {
        final now = DateTime.now();
        analytics = FaqAnalytics(
          questionId: faqId,
          helpfulCount: isHelpful ? 1 : 0,
          notHelpfulCount: isHelpful ? 0 : 1,
          firstViewed: now,
          lastViewed: now,
        );
      } else {
        analytics = analytics.copyWith(
          helpfulCount: isHelpful ? analytics.helpfulCount + 1 : analytics.helpfulCount,
          notHelpfulCount: !isHelpful ? analytics.notHelpfulCount + 1 : analytics.notHelpfulCount,
          lastViewed: DateTime.now(),
        );
      }

      await _analyticsBox?.put(faqId, analytics);
      await _updateMetrics();

      dev.log('FaqService: Tracked feedback for FAQ $faqId: helpful=$isHelpful', name: 'FAQ_SERVICE');
    } catch (e) {
      dev.log('FaqService: Error tracking FAQ feedback', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Save chat message to history
  Future<void> saveChatMessage(ChatMessage message) async {
    try {
      await _chatHistoryBox?.put(message.id, message);
      dev.log('FaqService: Saved chat message ${message.id}', name: 'FAQ_SERVICE');
    } catch (e) {
      dev.log('FaqService: Error saving chat message', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Get chat history with pagination
  List<ChatMessage> getChatHistory({int limit = 50, int offset = 0}) {
    try {
      final messages = _chatHistoryBox?.values.toList() ?? [];
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return messages.skip(offset).take(limit).toList();
    } catch (e) {
      dev.log('FaqService: Error getting chat history', error: e, name: 'FAQ_SERVICE');
      return [];
    }
  }

  /// Clear chat history
  Future<void> clearChatHistory() async {
    try {
      await _chatHistoryBox?.clear();
      dev.log('FaqService: Cleared chat history', name: 'FAQ_SERVICE');
    } catch (e) {
      dev.log('FaqService: Error clearing chat history', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Get FAQ analytics summary
  Map<String, dynamic> getAnalyticsSummary() {
    try {
      final analytics = _analyticsBox?.values.toList() ?? [];

      final totalViews = analytics.fold<int>(0, (sum, a) => sum + a.viewCount);
      final totalFeedback = analytics.fold<int>(0, (sum, a) => sum + a.helpfulCount + a.notHelpfulCount);
      final totalHelpful = analytics.fold<int>(0, (sum, a) => sum + a.helpfulCount);

      final avgHelpfulness = totalFeedback > 0 ? totalHelpful / totalFeedback : 0.0;

      return {
        'totalQuestions': _totalQuestions.value,
        'totalViews': totalViews,
        'totalFeedback': totalFeedback,
        'averageHelpfulness': avgHelpfulness,
        'popularQuestions': _popularQuestions.value,
      };
    } catch (e) {
      dev.log('FaqService: Error getting analytics summary', error: e, name: 'FAQ_SERVICE');
      return {};
    }
  }

  /// Private method to track search analytics
  void _trackSearchAnalytics(String query, List<String> resultIds) {
    try {
      // Track search terms for each result
      for (final id in resultIds.take(5)) { // Track top 5 results only
        var analytics = _analyticsBox?.get(id);

        if (analytics != null) {
          final updatedSearchTerms = List<String>.from(analytics.searchTerms);
          if (!updatedSearchTerms.contains(query.toLowerCase())) {
            updatedSearchTerms.add(query.toLowerCase());
          }

          final updatedAnalytics = analytics.copyWith(
            searchTerms: updatedSearchTerms,
            lastViewed: DateTime.now(),
          );

          _analyticsBox?.put(id, updatedAnalytics);
        }
      }
    } catch (e) {
      dev.log('FaqService: Error tracking search analytics', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Update performance metrics
  Future<void> _updateMetrics() async {
    try {
      final allFaqs = getAllFaqs();
      _totalQuestions.value = allFaqs.length;
      _popularQuestions.value = allFaqs.where((faq) => faq.isPopular).length;

      final analytics = _analyticsBox?.values.toList() ?? [];
      if (analytics.isNotEmpty) {
        final avgHelpfulness = analytics
            .map((a) => a.helpfulnessRatio)
            .reduce((a, b) => a + b) / analytics.length;
        _averageHelpfulness.value = avgHelpfulness;
      }
    } catch (e) {
      dev.log('FaqService: Error updating metrics', error: e, name: 'FAQ_SERVICE');
    }
  }

  /// Generate unique ID for messages
  String generateMessageId() => _uuid.v4();

  // ==========================================
  // FUTURE AI INTEGRATION POINTS WITH GENKIT
  // ==========================================

  /// FUTURE: Process user query with Genkit NLP
  /// This will replace _performStaticSearch() when AI is ready
  /*
  Future<List<FaqItem>> _processWithGenkit(String userQuery) async {
    // TODO: Integrate Genkit here
    // 1. Use Genkit to understand user intent
    // 2. Map intent to one of the 10 core questions
    // 3. Return the matching static FAQ item(s)
    // 4. Keep same data structure, just smarter matching
    return [];
  }
  */

  /// FUTURE: Generate AI-enhanced response
  /// This will enhance the static answers with more natural language
  /*
  Future<String> _generateEnhancedResponse(FaqItem faq, String userQuery) async {
    // TODO: Use Genkit to:
    // 1. Take the static answer as foundation
    // 2. Make it more natural/personalized to user's specific question
    // 3. Keep the same core information and trust messages
    // 4. Return enhanced but consistent response
    return faq.answerKey.tr; // Fallback to static
  }
  */

  /// Clean up resources
  @override
  void onClose() {
    dev.log('FaqService: Cleaning up service', name: 'FAQ_SERVICE');
    super.onClose();
  }

  /// Export FAQ data for backup
  Map<String, dynamic> exportFaqData() {
    try {
      final faqs = getAllFaqs();
      final analytics = _analyticsBox?.values.toList() ?? [];

      return {
        'faqs': faqs.map((f) => {
          'id': f.id,
          'questionKey': f.questionKey,
          'answerKey': f.answerKey,
          'category': f.category.key,
          'keywords': f.keywords,
          'isPopular': f.isPopular,
          'priority': f.priority,
          'relatedQuestionIds': f.relatedQuestionIds,
          'createdAt': f.createdAt.toIso8601String(),
          'updatedAt': f.updatedAt?.toIso8601String(),
          'isActive': f.isActive,
        }).toList(),
        'analytics': analytics.map((a) => {
          'questionId': a.questionId,
          'viewCount': a.viewCount,
          'helpfulCount': a.helpfulCount,
          'notHelpfulCount': a.notHelpfulCount,
          'firstViewed': a.firstViewed.toIso8601String(),
          'lastViewed': a.lastViewed.toIso8601String(),
          'searchTerms': a.searchTerms,
        }).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      dev.log('FaqService: Error exporting FAQ data', error: e, name: 'FAQ_SERVICE');
      return {};
    }
  }
}
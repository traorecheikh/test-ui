import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../../../data/models/faq_item.dart';
import '../../../services/faq_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_snackbar.dart';

/// Enterprise-level FAQ controller with comprehensive state management,
/// error handling, and performance optimization
class FaqController extends GetxController with GetTickerProviderStateMixin {
  // Dependencies
  late final FaqService _faqService;

  // Controllers
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();

  // Animation controllers
  late AnimationController _typingAnimationController;
  late AnimationController _messageAnimationController;

  // Reactive state variables
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxList<FaqItem> filteredItems = <FaqItem>[].obs;
  final RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxBool showScrollToTop = false.obs;

  // Chat state
  final RxBool isChatMode = true.obs;
  final RxBool isSearchMode = false.obs;
  final RxString lastQuestionId = ''.obs;
  final RxInt totalMessages = 0.obs;

  // Performance state
  final RxBool isSearching = false.obs;
  final RxDouble searchProgress = 0.0.obs;
  Timer? _searchDebounceTimer;

  // Analytics state
  final RxMap<String, dynamic> analyticsData = <String, dynamic>{}.obs;

  // Constants
  static const int _maxChatMessages = 100;
  static const Duration _typingDelay = Duration(milliseconds: 1500);
  static const Duration _searchDebounce = Duration(milliseconds: 300);
  static const Duration _messageDelay = Duration(milliseconds: 800);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeController();
  }

  /// Initialize the controller with all dependencies and state
  Future<void> _initializeController() async {
    try {
      dev.log('FaqController: Initializing controller...', name: 'FAQ_CONTROLLER');

      isLoading.value = true;
      hasError.value = false;

      // Initialize services
      _faqService = Get.find<FaqService>();

      // Initialize animations
      _initializeAnimations();

      // Setup listeners
      _setupListeners();

      // Load initial data
      await _loadInitialData();

      // Initialize chat
      await _initializeChat();

      isLoading.value = false;
      dev.log('FaqController: Controller initialized successfully', name: 'FAQ_CONTROLLER');

    } catch (e, stackTrace) {
      hasError.value = true;
      errorMessage.value = 'Failed to initialize FAQ: $e';
      isLoading.value = false;

      dev.log(
        'FaqController: Initialization failed',
        error: e,
        stackTrace: stackTrace,
        name: 'FAQ_CONTROLLER',
      );

      _showErrorSnackbar('Failed to initialize FAQ system');
    }
  }

  /// Initialize animation controllers
  void _initializeAnimations() {
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _messageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  /// Setup reactive listeners
  void _setupListeners() {
    // Search query listener with debouncing
    searchController.addListener(_onSearchChanged);

    // Scroll listener for scroll-to-top button
    scrollController.addListener(_onScrollChanged);

    // Listen to chat messages for auto-scroll
    ever(chatMessages, _onChatMessagesChanged);

    // Listen to loading state for error handling
    ever(hasError, _onErrorStateChanged);
  }

  /// Load initial data
  Future<void> _loadInitialData() async {
    try {
      // Load all FAQs
      final allFaqs = _faqService.getAllFaqs();
      filteredItems.assignAll(allFaqs);

      // Load analytics
      analyticsData.value = _faqService.getAnalyticsSummary();

      dev.log('FaqController: Loaded ${allFaqs.length} FAQ items', name: 'FAQ_CONTROLLER');

    } catch (e) {
      throw Exception('Failed to load FAQ data: $e');
    }
  }

  /// Initialize chat with welcome message
  Future<void> _initializeChat() async {
    try {
      chatMessages.clear();

      // Add welcome message
      await _addBotMessage('bot_welcome_message'.tr);

      // Add quick actions after delay
      Timer(_messageDelay, () {
        _showQuickActions();
      });

    } catch (e) {
      dev.log('FaqController: Error initializing chat', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Search functionality with debouncing and performance optimization
  void _onSearchChanged() {
    final query = searchController.text;
    searchQuery.value = query;

    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Start new debounced search
    _searchDebounceTimer = Timer(_searchDebounce, () {
      _performSearch(query);
    });
  }

  /// Perform search with progress indication
  Future<void> _performSearch(String query) async {
    try {
      isSearching.value = true;
      searchProgress.value = 0.0;

      // Simulate progress for UX
      _animateSearchProgress();

      if (query.trim().isEmpty) {
        // Reset to all FAQs
        _filterItems();
      } else {
        // Perform actual search
        final results = _faqService.searchFaqs(query);
        filteredItems.assignAll(results);

        dev.log('FaqController: Search for "$query" returned ${results.length} results', name: 'FAQ_CONTROLLER');
      }

      // Update UI state
      if (query.isNotEmpty && filteredItems.isEmpty) {
        _addBotMessage('no_results_message'.tr);
        _showAlternativeSuggestions();
      }

    } catch (e) {
      dev.log('FaqController: Search error', error: e, name: 'FAQ_CONTROLLER');
      _showErrorSnackbar('Search failed. Please try again.');
    } finally {
      isSearching.value = false;
      searchProgress.value = 1.0;
    }
  }

  /// Animate search progress bar
  void _animateSearchProgress() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (searchProgress.value >= 1.0 || !isSearching.value) {
        timer.cancel();
        return;
      }
      searchProgress.value += 0.1;
    });
  }

  /// Filter items based on current state
  void _filterItems() {
    final allFaqs = _faqService.getAllFaqs();

    if (selectedCategory.value == 'all') {
      filteredItems.assignAll(allFaqs);
    } else {
      final categoryEnum = FaqCategory.values.firstWhere(
        (cat) => cat.key == selectedCategory.value,
        orElse: () => FaqCategory.security,
      );

      final filtered = _faqService.getFaqsByCategory(categoryEnum);
      filteredItems.assignAll(filtered);
    }
  }

  /// Handle scroll changes for UI improvements
  void _onScrollChanged() {
    final showButton = scrollController.hasClients &&
                      scrollController.offset > 200;

    if (showScrollToTop.value != showButton) {
      showScrollToTop.value = showButton;
    }
  }

  /// Handle chat messages changes for auto-scroll
  void _onChatMessagesChanged(List<ChatMessage> messages) {
    if (messages.length != totalMessages.value) {
      totalMessages.value = messages.length;

      // Auto-scroll to bottom after new message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      // Limit chat history
      if (messages.length > _maxChatMessages) {
        chatMessages.removeRange(0, messages.length - _maxChatMessages);
      }
    }
  }

  /// Handle error state changes
  void _onErrorStateChanged(bool hasError) {
    if (hasError && errorMessage.value.isNotEmpty) {
      _showErrorSnackbar(errorMessage.value);
    }
  }

  /// Category selection
  void selectCategory(String category) {
    try {
      selectedCategory.value = category;
      _filterItems();

      // Provide haptic feedback
      _triggerHapticFeedback();

      dev.log('FaqController: Selected category: $category', name: 'FAQ_CONTROLLER');

    } catch (e) {
      dev.log('FaqController: Error selecting category', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Ask a specific question (Static Version)
  /// TODO: This will be enhanced with Genkit NLP for better understanding
  Future<void> askQuestion(String questionId) async {
    try {
      final faq = _faqService.getFaqById(questionId);
      if (faq == null) {
        _showErrorSnackbar('Question not found');
        return;
      }

      // Track analytics
      await _faqService.trackFaqView(questionId);
      lastQuestionId.value = questionId;

      // Add user question to chat
      await _addUserMessage(faq.questionKey.tr);

      // Show typing indicator (simulated for UX)
      await _showTypingIndicator();

      // STATIC: Direct answer from predefined responses
      // FUTURE: This will use Genkit to process and understand user intent
      await _addStaticBotResponse(faq);

      // Show related questions (static for now)
      await _showRelatedQuestions(questionId);

      // Provide haptic feedback
      _triggerHapticFeedback();

      dev.log('FaqController: Asked question: $questionId', name: 'FAQ_CONTROLLER');

    } catch (e) {
      dev.log('FaqController: Error asking question', error: e, name: 'FAQ_CONTROLLER');
      _showErrorSnackbar('Failed to process question');
    }
  }

  /// Static bot response - will be replaced with Genkit AI processing
  Future<void> _addStaticBotResponse(FaqItem faq) async {
    // STATIC: Return predefined answer
    await _addBotMessage(faq.answerKey.tr);

    // FUTURE: This is where Genkit will:
    // 1. Understand user intent better
    // 2. Provide more natural responses
    // 3. Still use the same core 10 FAQ answers as foundation
  }

  /// Add user message to chat
  Future<void> _addUserMessage(String content) async {
    final message = ChatMessage(
      id: _faqService.generateMessageId(),
      type: ChatMessageType.user,
      content: content,
      timestamp: DateTime.now(),
    );

    chatMessages.add(message);
    await _faqService.saveChatMessage(message);

    // Animate message appearance
    _messageAnimationController.forward(from: 0);
  }

  /// Add bot message to chat
  Future<void> _addBotMessage(String content) async {
    final message = ChatMessage(
      id: _faqService.generateMessageId(),
      type: ChatMessageType.bot,
      content: content,
      timestamp: DateTime.now(),
    );

    chatMessages.add(message);
    await _faqService.saveChatMessage(message);

    // Animate message appearance
    _messageAnimationController.forward(from: 0);
  }

  /// Add suggestion message to chat
  Future<void> _addSuggestionMessage(String questionText, String questionId) async {
    final message = ChatMessage(
      id: _faqService.generateMessageId(),
      type: ChatMessageType.suggestion,
      content: questionText,
      timestamp: DateTime.now(),
      questionId: questionId,
    );

    chatMessages.add(message);
    await _faqService.saveChatMessage(message);
  }

  /// Show typing indicator
  Future<void> _showTypingIndicator() async {
    isTyping.value = true;
    _typingAnimationController.repeat();

    await Future.delayed(_typingDelay);

    isTyping.value = false;
    _typingAnimationController.stop();
  }

  /// Show quick actions
  void _showQuickActions() {
    try {
      final popularFaqs = _faqService.getPopularFaqs(limit: 4);

      Timer(const Duration(milliseconds: 500), () {
        _addBotMessage('bot_quick_actions'.tr);
      });

      Timer(const Duration(milliseconds: 1000), () {
        for (final faq in popularFaqs) {
          _addSuggestionMessage(faq.questionKey.tr, faq.id);
        }
      });

    } catch (e) {
      dev.log('FaqController: Error showing quick actions', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Show related questions
  Future<void> _showRelatedQuestions(String questionId) async {
    try {
      final relatedFaqs = _faqService.getRelatedFaqs(questionId, limit: 3);

      if (relatedFaqs.isNotEmpty) {
        Timer(_messageDelay, () {
          _addBotMessage('related_questions'.tr);
        });

        Timer(_messageDelay * 1.5, () {
          for (final faq in relatedFaqs) {
            _addSuggestionMessage(faq.questionKey.tr, faq.id);
          }
        });
      }

    } catch (e) {
      dev.log('FaqController: Error showing related questions', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Show alternative suggestions when no results found
  void _showAlternativeSuggestions() {
    try {
      Timer(_messageDelay, () {
        _addBotMessage('alternative_suggestions'.tr);
        _showQuickActions();
      });
    } catch (e) {
      dev.log('FaqController: Error showing alternatives', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Track FAQ helpfulness
  Future<void> trackFeedback(String questionId, bool isHelpful) async {
    try {
      await _faqService.trackFaqFeedback(questionId, isHelpful);

      // Update analytics
      analyticsData.value = _faqService.getAnalyticsSummary();

      // Show feedback message
      final feedbackMessage = isHelpful ? 'feedback_helpful'.tr : 'feedback_not_helpful'.tr;
      _addBotMessage(feedbackMessage);

      // Provide haptic feedback
      _triggerHapticFeedback();

      dev.log('FaqController: Tracked feedback: $questionId = $isHelpful', name: 'FAQ_CONTROLLER');

    } catch (e) {
      dev.log('FaqController: Error tracking feedback', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Switch between chat and search modes
  void toggleMode() {
    try {
      if (isChatMode.value) {
        // Switch to search mode
        isChatMode.value = false;
        isSearchMode.value = true;
        searchController.clear();
        _filterItems();
      } else {
        // Switch to chat mode
        isChatMode.value = true;
        isSearchMode.value = false;
        if (chatMessages.isEmpty) {
          _initializeChat();
        }
      }

      // Provide haptic feedback
      _triggerHapticFeedback();

    } catch (e) {
      dev.log('FaqController: Error toggling mode', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Reset chat conversation
  Future<void> resetChat() async {
    try {
      chatMessages.clear();
      await _faqService.clearChatHistory();
      await _initializeChat();

      _showSuccessSnackbar('Chat reset successfully');

      dev.log('FaqController: Chat reset', name: 'FAQ_CONTROLLER');

    } catch (e) {
      dev.log('FaqController: Error resetting chat', error: e, name: 'FAQ_CONTROLLER');
      _showErrorSnackbar('Failed to reset chat');
    }
  }

  /// Scroll to top of list
  void scrollToTop() {
    try {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      dev.log('FaqController: Error scrolling to top', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Scroll to bottom of chat
  void _scrollToBottom() {
    try {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      dev.log('FaqController: Error scrolling to bottom', error: e, name: 'FAQ_CONTROLLER');
    }
  }

  /// Trigger haptic feedback
  void _triggerHapticFeedback() {
    try {
      Vibration.hasVibrator().then((hasVibrator) {
        if (hasVibrator == true) {
          Vibration.vibrate(duration: 50);
        }
      });
    } catch (e) {
      // Haptic feedback is optional, don't log errors
    }
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    CustomSnackbar.show(
      title: 'Success',
      message: message,
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    CustomSnackbar.show(
      title: 'Error',
      message: message,
    );
  }

  /// Get FAQ categories for UI
  List<Map<String, dynamic>> getCategories() {
    return [
      {'key': 'all', 'label': 'all_categories'.tr, 'emoji': '📋'},
      ...FaqCategory.values.map((category) => {
        'key': category.key,
        'label': category.titleKey.tr,
        'emoji': category.emoji,
      }),
    ];
  }

  /// Get analytics summary for UI
  Map<String, dynamic> getAnalyticsSummary() {
    return analyticsData.value;
  }

  /// Export chat history
  Future<Map<String, dynamic>> exportChatHistory() async {
    try {
      final history = _faqService.getChatHistory();

      return {
        'chatHistory': history.map((msg) => {
          'id': msg.id,
          'type': msg.type.key,
          'content': msg.content,
          'timestamp': msg.timestamp.toIso8601String(),
          'questionId': msg.questionId,
        }).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
        'totalMessages': history.length,
      };

    } catch (e) {
      dev.log('FaqController: Error exporting chat history', error: e, name: 'FAQ_CONTROLLER');
      return {};
    }
  }

  /// Refresh FAQ data
  Future<void> refresh() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      await _loadInitialData();

      if (isChatMode.value && chatMessages.isEmpty) {
        await _initializeChat();
      }

      _showSuccessSnackbar('FAQ data refreshed');

    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to refresh: $e';
      _showErrorSnackbar('Failed to refresh FAQ data');
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle deep link to specific FAQ
  Future<void> navigateToFaq(String questionId) async {
    try {
      // Switch to chat mode if needed
      if (!isChatMode.value) {
        toggleMode();
      }

      // Clear current chat and ask the question
      await resetChat();
      await askQuestion(questionId);

    } catch (e) {
      dev.log('FaqController: Error navigating to FAQ', error: e, name: 'FAQ_CONTROLLER');
      _showErrorSnackbar('Failed to navigate to question');
    }
  }

  @override
  void onClose() {
    // Clean up resources
    searchController.dispose();
    scrollController.dispose();
    pageController.dispose();
    _typingAnimationController.dispose();
    _messageAnimationController.dispose();
    _searchDebounceTimer?.cancel();

    dev.log('FaqController: Controller disposed', name: 'FAQ_CONTROLLER');
    super.onClose();
  }
}
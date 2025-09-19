import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snt_ui_test/generated/assets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingPageData {
  final String lottie;
  final String titleKey;
  final String subtitleKey;
  final String descKey;

  const _OnboardingPageData({
    required this.lottie,
    required this.titleKey,
    required this.subtitleKey,
    required this.descKey,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Content aligned with the PRD and marketing strategy
  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      lottie: Assets.assetsLottiesOnboarding1,
      subtitleKey: 'onboarding_subtitle_1',
      titleKey: 'onboarding_title_1',
      descKey: 'onboarding_desc_1',
    ),
    _OnboardingPageData(
      lottie: Assets.assetsLottiesOnboarding2,
      subtitleKey: 'onboarding_subtitle_2',
      titleKey: 'onboarding_title_2',
      descKey: 'onboarding_desc_2',
    ),
    _OnboardingPageData(
      lottie: Assets.imagesCommunity,
      subtitleKey: 'onboarding_subtitle_3',
      titleKey: 'onboarding_title_3',
      descKey: 'onboarding_desc_3',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    } else {
      _onGetStarted();
    }
  }

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    Get.offAllNamed('/login'); // Assuming '/login' is the correct route
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Placeholder for logo if needed
                  const SizedBox(width: 50),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _onGetStarted,
                      child: Text(
                        'onboarding_skip'.tr,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    )
                  else
                    const SizedBox(height: 48), // Keep space consistent
                ],
              ),
            ),

            // PageView for content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return _OnboardingPage(
                    data: page,
                    isActive: i == _currentPage,
                  );
                },
              ),
            ),

            // Footer with indicator and button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                children: [
                  // Custom Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(
                                  alpha: (0.3 * 255),
                                ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle:
                            (theme.textTheme.titleMedium ?? const TextStyle())
                                .copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'onboarding_get_started'.tr
                            : 'onboarding_next'.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isActive;

  const _OnboardingPage({required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 240,
              child: Center(
                child: data.lottie.contains("lottie")
                    ? Lottie.asset(
                        data.lottie,
                        fit: BoxFit.contain,
                        backgroundLoading: false,
                        repeat: false,
                        errorBuilder: (context, error, stack) => Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                        ),
                      )
                    : Image.asset(
                        data.lottie,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.subtitleKey.tr,
                  style: (theme.textTheme.titleMedium ?? const TextStyle())
                      .copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.titleKey.tr,
                  style: (theme.textTheme.headlineMedium ?? const TextStyle())
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  data.descKey.tr,
                  style: (theme.textTheme.bodyLarge ?? const TextStyle())
                      .copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: (0.7 * 255),
                        ),
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

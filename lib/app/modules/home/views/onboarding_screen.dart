import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      lottie: 'assets/lottie/onboard1.json',
      title: 'Gérez vos tontines facilement',
      desc: 'Créez, rejoignez et suivez vos tontines en toute simplicité.',
    ),
    _OnboardingPage(
      lottie: 'assets/lottie/onboard2.json',
      title: 'Transparence & Sécurité',
      desc: 'Toutes les transactions sont claires et sécurisées.',
    ),
    _OnboardingPage(
      lottie: 'assets/lottie/onboard3.json',
      title: 'Communauté & entraide',
      desc: 'Participez à une communauté de confiance et d’entraide.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Skip button (not on last page)
                if (_currentPage < _pages.length - 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 16),
                      child: GestureDetector(
                        onTap: _onGetStarted,
                        child: AnimatedOpacity(
                          opacity: 1,
                          duration: 300.ms,
                          child:
                              Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'Passer',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .slideX(begin: 0.2, duration: 300.ms),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, i) {
                      final page = _pages[i];
                      // Animated page transitions: fade + slide
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double pageOffset = 0;
                          try {
                            pageOffset = _pageController.hasClients
                                ? _pageController.page! - i
                                : 0;
                          } catch (_) {}
                          final opacity = (1 - pageOffset.abs()).clamp(
                            0.0,
                            1.0,
                          );
                          final slide = 40.0 * pageOffset;
                          return Opacity(
                            opacity: opacity,
                            child: Transform.translate(
                              offset: Offset(slide, 0),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 32,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Lottie.asset(page.lottie, width: 220, height: 220, repeat: true)
                              //     .animate().fadeIn(duration: 600.ms),
                              const SizedBox(height: 32),
                              Text(
                                page.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().slideY(begin: -0.2, duration: 400.ms),
                              const SizedBox(height: 18),
                              Text(
                                page.desc,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.8),
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(
                                duration: 500.ms,
                                delay: 200.ms,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    final isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: isActive ? 32 : 16,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton(
                          onPressed: _onGetStarted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                          ),
                        ).animate().scaleXY(
                          begin: 0.95,
                          end: 1.0,
                          duration: 200.ms,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String lottie;
  final String title;
  final String desc;

  const _OnboardingPage({
    required this.lottie,
    required this.title,
    required this.desc,
  });
}

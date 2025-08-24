import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/theme.dart';

class ComingSoonTeaser extends StatelessWidget {
  final String featureName;

  const ComingSoonTeaser({super.key, required this.featureName});

  static void show(BuildContext context, {required String featureName}) {
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ComingSoonTeaser(featureName: featureName);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Fade and scale transition
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Feature-specific content
    String title, message;
    IconData mainIcon;
    List<String> features;
    Color accentColor;

    if (featureName == 'Sunu Points') {
      title = 'Les SunuPoints arrivent !';
      message = 'Gagnez des récompenses pour chaque action positive dans la communauté.';
      mainIcon = Icons.star_border_rounded;
      features = ['Niveaux & Badges Exclusifs', 'Récompenses du Marketplace', 'Défis Hebdomadaires'];
      accentColor = theme.colorScheme.secondary;
    } else { // 'Rapports'
      title = 'Vos Finances, en Clair';
      message = 'Des analyses détaillées pour suivre votre épargne comme un pro.';
      mainIcon = Icons.insights_rounded;
      features = ['Suivi de Performance', 'Rapports PDF Exportables', 'Projections Personnalisées'];
      accentColor = Colors.blue.shade400;
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: SingleChildScrollView( // Prevents overflow
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important for sizing
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(mainIcon, size: 80.sp, color: accentColor),
                ),
                AppSpacing.largeHeightSpacerWidget,

                // Content
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                AppSpacing.mediumHeightSpacer,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                AppSpacing.largeHeightSpacerWidget,

                // Features
                ...features.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: accentColor, size: 22),
                      AppSpacing.mediumWidthSpacer,
                      Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                )),
                AppSpacing.extraLargeHeightSpacerWidget,

                // CTA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('J\'ai hâte de voir ça !'),
                ),
                AppSpacing.smallHeightSpacerWidget,
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Plus tard',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
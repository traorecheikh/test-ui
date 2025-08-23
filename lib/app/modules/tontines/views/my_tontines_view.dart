import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import '../../../routes/app_pages.dart';
import '../../../widgets/tontine_card.dart';
import '../../home/controllers/home_controller.dart';

class MyTontinesView extends GetView<HomeController> {
  const MyTontinesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        title: Text(
          'Vos Tontines',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.add_circled, color: theme.colorScheme.primary, size: 28),
            onPressed: () => Get.toNamed(Routes.create),
            tooltip: 'Créer une tontine',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState(theme);
        }
        if (controller.userTontines.isEmpty) {
          return _buildEmptyState(theme, context);
        }
        return _buildTontineGrid(theme);
      }),
    );
  }

  Widget _buildTontineGrid(ThemeData theme) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      crossAxisCount: 1,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      itemCount: controller.userTontines.length,
      itemBuilder: (context, i) {
        final tontine = controller.userTontines[i];
        return SizedBox(
          height: 220,
          child: TontineCard(
            tontine: tontine,
            onTap: () => Get.toNamed(Routes.detail, arguments: tontine.id),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      crossAxisCount: 1,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: theme.colorScheme.surface.withOpacity(0.5),
          highlightColor: theme.colorScheme.surface,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.collections,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Commencez votre aventure d\'épargne',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Créez une nouvelle tontine ou rejoignez un groupe existant pour commencer.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.create),
              icon: const Icon(CupertinoIcons.add, size: 20),
              label: const Text('Créer une Tontine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement Join Tontine functionality
              },
              icon: const Icon(CupertinoIcons.person_add, size: 20),
              label: const Text('Rejoindre une Tontine'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
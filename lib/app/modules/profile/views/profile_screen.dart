import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/user.dart';
import '../../../utils/formatters.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final theme = Theme.of(context);
      final user = controller.currentUser.value;
      if (user == null) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70.h,
            leading: Icon(CupertinoIcons.back),
            backgroundColor: theme.colorScheme.background,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Profil',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Center(child: Text('user_not_found'.tr)),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: theme.colorScheme.primary),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Profil',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            children: [
              _buildHeaderSection(theme, user),
              SizedBox(height: 32.h),
              _buildPersonalInfoCard(theme, user),
              SizedBox(height: 24.h),
              _buildStatsCard(theme, user),
              if (user.achievements.isNotEmpty) ...[
                SizedBox(height: 24.h),
                _buildAchievementsCard(theme, user),
              ],
              SizedBox(height: 24.h),
              _buildParticipationCard(theme, user),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeaderSection(ThemeData theme, AppUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Animated avatar
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            radius: 44.r,
            backgroundColor: theme.colorScheme.primary,
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                ? Text(
                    user.name
                        .trim()
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
                        .take(2)
                        .join(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          'Bonjour, ${user.name.split(' ').first}!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'Niveau: ${user.level.label}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(ThemeData theme, AppUser user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'personal_info'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('phone'.tr),
              subtitle: Text(Formatters.formatPhoneNumber(user.phone)),
              contentPadding: EdgeInsets.zero,
            ),
            if (user.email != null && user.email!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email),
                title: Text('email'.tr),
                subtitle: Text(user.email!),
                contentPadding: EdgeInsets.zero,
              ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('member_since'.tr),
              subtitle: Text(Formatters.formatDate(user.createdAt)),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, AppUser user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 0,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.star, color: Colors.white, size: 32.sp),
                SizedBox(height: 8.h),
                Text(
                  '${user.sunuPoints}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'points'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(Icons.verified_user, color: Colors.white, size: 32),
                SizedBox(height: 8.h),
                Text(
                  user.reliabilityScore.toStringAsFixed(1),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'reliability'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(ThemeData theme, AppUser user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'achievements'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 16.w,
              runSpacing: 12.h,
              children: user.achievements
                  .map((a) => _buildAchievementChip(theme, a))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementChip(ThemeData theme, Achievement achievement) {
    return Chip(
      label: Text(achievement.title, style: theme.textTheme.bodyMedium),
      avatar: Icon(Icons.emoji_events, color: theme.colorScheme.primary),
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildParticipationCard(ThemeData theme, AppUser user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'participation'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.group,
                      color: theme.colorScheme.primary,
                      size: 32.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${user.tontineIds.length}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'tontines_joined'.tr,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: theme.colorScheme.secondary,
                      size: 32.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${user.organizedTontineIds.length}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'tontines_organized'.tr,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

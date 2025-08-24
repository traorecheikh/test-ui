import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../controllers/tontine_detail_controller.dart';

class TontineDetailScreen extends GetView<TontineDetailController> {
  final int tontineId;
  const TontineDetailScreen({super.key, required this.tontineId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tontine = controller.tontine.value;
      if (tontine == null) {
        return const SizedBox();
      }
      return Scaffold(
        body: ListView(
          children: [
            SizedBox(height: 24.h),
            _buildParticipantSocialStream(Theme.of(context), tontine),
            SizedBox(height: 32.h),
            _buildContextualInsights(Theme.of(context), tontine),
          ],
        ),
      );
    });
  }

  Widget _buildParticipantSocialStream(ThemeData theme, tontine) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Communauté',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showAllParticipantsBottomSheet(theme, tontine),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(128),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir tous',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.primary,
                        size: 14.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: math.min(tontine.participantIds.length, 5),
              itemBuilder: (context, index) {
                final participantId = tontine.participantIds[index];
                final isOrganizer = participantId == tontine.organizerId;
                final contribution = controller.currentRoundContributions
                    .where((c) => c.participantId == participantId)
                    .firstOrNull;
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 16.w),
                  child: _buildParticipantAvatar(
                    theme,
                    participantId,
                    isOrganizer,
                    contribution,
                    index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantAvatar(
    ThemeData theme,
    int participantId,
    bool isOrganizer,
    contribution,
    int index,
  ) {
    final name =
        AppConstants.sampleParticipantNames[index %
            AppConstants.sampleParticipantNames.length];
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    final isPaid = contribution?.isPaid ?? false;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withAlpha(179),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPaid ? Colors.green : Colors.orange.withAlpha(128),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isPaid ? Colors.green : Colors.orange).withAlpha(
                      77,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (isOrganizer)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.star, color: Colors.white, size: 12.w),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  isPaid ? Icons.check : Icons.schedule,
                  color: Colors.white,
                  size: 12.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          name.split(' ')[0],
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          isPaid ? 'Payé' : 'En attente',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: isPaid ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildContextualInsights(ThemeData theme, tontine) {
    final insights = controller.contextualInsights;
    if (insights.isEmpty) return const SizedBox();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conseils Personnalisés',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16.h),
          ...insights
              .map((insight) => _buildInsightCard(theme, insight))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildInsightCard(ThemeData theme, Map<String, dynamic> insight) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: insight['color'].withAlpha(25),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: insight['color'].withAlpha(51), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: insight['color'].withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: Icon(insight['icon'], color: insight['color'], size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: insight['color'],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  insight['message'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withAlpha(204),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAllParticipantsBottomSheet(ThemeData theme, tontine) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withAlpha(51),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    color: theme.colorScheme.primary,
                    size: 24.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Tous les Participants',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${tontine.participantIds.length}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: tontine.participantIds.length,
                itemBuilder: (context, index) {
                  final participantId = tontine.participantIds[index];
                  final isOrganizer = participantId == tontine.organizerId;
                  final contribution = controller.currentRoundContributions
                      .where((c) => c.participantId == participantId)
                      .firstOrNull;
                  return _buildParticipantListItem(
                    theme,
                    participantId,
                    isOrganizer,
                    contribution,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildParticipantListItem(
    ThemeData theme,
    int participantId,
    bool isOrganizer,
    contribution,
    int index,
  ) {
    final name =
        AppConstants.sampleParticipantNames[index %
            AppConstants.sampleParticipantNames.length];
    final initials = name.split(' ').map((n) => n[0]).take(2).join();
    final isPaid = contribution?.isPaid ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPaid
              ? Colors.green.withAlpha(77)
              : Colors.orange.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withAlpha(179),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (isOrganizer)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Colors.white, size: 12.w),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                if (isOrganizer)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(51),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Organisateur',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaid ? Icons.check : Icons.schedule,
                  color: Colors.white,
                  size: 16.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  isPaid ? 'Payé' : 'En attente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

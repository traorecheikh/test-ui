import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/faq_item.dart';
import '../../../theme.dart';
import '../controllers/faq_controller.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: _buildContent(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.colorScheme.primary,
          size: AppIconSizes.medium,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'help_support'.tr,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Obx(() => controller.isLoading.value
        ? _buildLoading(theme)
        : _buildQuestionsList(theme));
  }

  Widget _buildLoading(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildQuestionsList(ThemeData theme) {
    return ListView.builder(
      padding: AppPaddings.pageHome,
      itemCount: controller.filteredItems.length,
      itemBuilder: (context, index) {
        final faq = controller.filteredItems[index];
        return _buildQuestionCard(faq, theme, index);
      },
    );
  }

  Widget _buildQuestionCard(FaqItem faq, ThemeData theme, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.medium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [AppShadows.small],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAnswerDialog(faq, theme),
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: Padding(
            padding: AppPaddings.cardContent,
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Center(
                    child: Text(
                      faq.category.emoji,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                AppSpacing.mediumWidthSpacer,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faq.questionKey.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.smallHeightSpacer,
                      Text(
                        faq.category.titleKey.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.primary,
                  size: AppIconSizes.small,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAnswerDialog(FaqItem faq, ThemeData theme) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.large),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Center(
                      child: Text(
                        faq.category.emoji,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),
                  AppSpacing.mediumWidthSpacer,
                  Expanded(
                    child: Text(
                      faq.questionKey.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: AppIconSizes.medium,
                    ),
                  ),
                ],
              ),
              AppSpacing.largeHeightSpacer,
              Text(
                faq.answerKey.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              AppSpacing.largeHeightSpacer,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text('Compris'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
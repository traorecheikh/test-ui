import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snt_ui_test/app/theme.dart';

import '../../widgets/payment_status_modal.dart';

void showPaymentSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: false, // Set to false for standard bottom sheet
    backgroundColor: Colors.transparent,
    builder: (context) => const PaymentMethodSheet(),
    isDismissible: true,
  );
}

// The content of the bottom sheet
class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key});

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'wave', 'name': 'Wave', 'image': 'assets/images/payment/wave.png'},
    {
      'id': 'orange_money',
      'name': 'Orange Money',
      'image': 'assets/images/payment/orange_money.png',
    },
    {
      'id': 'free',
      'name': 'Free Money',
      'image': 'assets/images/payment/free.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: AppPaddings.pageHome.copyWith(top: 0),
                child: Column(
                  children: List.generate(_paymentMethods.length, (index) {
                    final method = _paymentMethods[index];
                    return Column(
                      children: [
                        _buildMethodRow(method, theme),
                        if (index < _paymentMethods.length - 1)
                          AppSpacing.mediumHeightSpacerWidget,
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodRow(Map<String, dynamic> method, ThemeData theme) {
    return InkWell(
      onTap: () {
        // Show payment status modal matching Coming Soon Teaser style
        PaymentStatusModal.show(
          context,
          status: PaymentStatus
              .successful, // or PaymentStatus.failed based on actual payment result
        );
        // If you want to handle payment result dynamically, replace with actual logic
      },
      borderRadius: BorderRadius.circular(
        AppRadius.medium,
      ), // Consistent with app radius
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ), // Much more generous padding
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w, // Adjusted icon size for richness
              height: 40.h, // Adjusted icon size for richness
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(method['image']),
                  fit: BoxFit.cover, // Ensure image covers the circle
                ),
              ),
            ),
            AppSpacing.largeWidthSpacerWidget, // Increased spacing
            Expanded(
              child: Text(method['name'], style: theme.textTheme.titleMedium),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: AppIconSizes.large,
            ), // Always show arrow
          ],
        ),
      ),
    );
  }
}

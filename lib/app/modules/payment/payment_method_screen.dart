import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Import Get for navigation
import 'package:google_fonts/google_fonts.dart';
import 'package:snt_ui_test/app/modules/payment/payment_status_screen.dart';
import 'package:snt_ui_test/app/routes/app_pages.dart'; // Import app_pages for routes
import 'package:snt_ui_test/app/theme.dart';

// Main screen widget to launch the bottom sheet
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentMethodSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paiement',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showPaymentSheet(context),
          child: const Text('Sélectionner une méthode de paiement'),
        ),
      ),
    );
  }
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
    return DraggableScrollableSheet(
      initialChildSize: 0.55, // Reduced height for thumb friendliness
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, controller) {
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
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  padding: AppPaddings.pageHome.copyWith(
                    top: 0,
                  ), // Adjust padding
                  itemCount: _paymentMethods.length,
                  separatorBuilder: (context, index) => AppSpacing
                      .mediumHeightSpacerWidget, // Use AppSpacing for separation
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return _buildMethodRow(method, theme);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMethodRow(Map<String, dynamic> method, ThemeData theme) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.PAYMENT_STATUS,
          arguments: {
            'paymentMethod': method['name'],
            'paymentMethodImage': method['image'],
            'amount': 10000.0,
            'status': PaymentStatus
                .successful, // or 'failed' based on actual payment result
          },
        );
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

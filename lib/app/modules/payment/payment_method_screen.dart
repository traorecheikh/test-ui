import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snt_ui_test/app/theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Méthode de Paiement',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPaddings.pageHome,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionnez une méthode',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.smallHeightSpacer,
            Text(
              'Choisissez une des options pour continuer votre paiement.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            AppSpacing.extraLargeHeightSpacerWidget,
            Expanded(
              child: ListView(
                children:
                    [
                          _buildPaymentMethod(
                            theme,
                            'Wave',
                            'assets/images/payment/wave.png',
                            'wave',
                          ),
                          _buildPaymentMethod(
                            theme,
                            'Orange Money',
                            'assets/images/payment/om.png',
                            'orange_money',
                          ),
                          _buildPaymentMethod(
                            theme,
                            'Free Money',
                            'assets/images/payment/free.png',
                            'free',
                          ),
                        ]
                        .animate(interval: 100.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMethod != null ? () {} : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: theme.colorScheme.primary
                      .withOpacity(0.5),
                ),
                child: Text(
                  'Continuer',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            AppSpacing.mediumHeightSpacer,
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    ThemeData theme,
    String title,
    String imagePath,
    String method,
  ) {
    final bool isSelected = _selectedMethod == method;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => _onMethodSelected(method),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.05)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: isSelected ? 1 : 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                height: 40,
                width: 40,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 40, color: Colors.red),
              ),
              AppSpacing.mediumWidthSpacer,
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

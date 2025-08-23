import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../controllers/join_tontine_controller.dart';

class JoinTontineScreen extends GetView<JoinTontineController> {
  const JoinTontineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.group, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 10),
            const Text('Rejoindre une Tontine'),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(theme),
              const SizedBox(height: 32),
              if (controller.foundTontine.value != null) ...[
                _buildTontinePreview(theme),
                const SizedBox(height: 32),
              ],
              if (controller.searchError?.value.isNotEmpty == true)
                _buildErrorMessage(theme),
              const Spacer(),
              _buildInstructions(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.vpn_key,
              color: theme.colorScheme.primary.withOpacity(0.18),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "Code d'Invitation",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextFormField(
                  controller: controller.codeController,
                  decoration: InputDecoration(
                    labelText: 'Code à 6 caractères',
                    hintText: 'ABC123',
                    prefixIcon: const Icon(Icons.vpn_key),
                    suffixIcon: controller.isSearching.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 20, letterSpacing: 2),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (value) {
                    if (value.length == 6) {
                      controller.searchTontine(value);
                    } else {
                      controller.clearSearch();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: controller.showQRScanner,
              icon: Icon(
                Icons.qr_code_scanner,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Scanner',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTontinePreview(ThemeData theme) {
    return Obx(() {
      final tontine = controller.foundTontine.value;
      if (tontine == null) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tontine Trouvée',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          _TontinePreviewCard(tontine: tontine),
          const SizedBox(height: 16),
          _buildTontineDetails(theme),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => GodlyVibrateButton(
                onTap: controller.isJoining.value
                    ? null
                    : controller.joinTontine,
                child: ElevatedButton(
                  onPressed: controller.isJoining.value
                      ? null
                      : controller.joinTontine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: controller.isJoining.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Rejoindre cette Tontine'),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTontineDetails(ThemeData theme) {
    final tontine = controller.foundTontine.value;
    if (tontine == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails de la Tontine',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            theme,
            'Contribution',
            Formatters.formatCurrency(tontine.contributionAmount),
            Icons.account_balance_wallet,
          ),
          _buildDetailRow(
            theme,
            'Participants',
            '${tontine.participantIds.length}/${tontine.maxParticipants}',
            Icons.people,
          ),
          _buildDetailRow(
            theme,
            'Fréquence',
            tontine.frequency.label,
            Icons.schedule,
          ),
          _buildDetailRow(
            theme,
            'Ordre de tirage',
            tontine.drawOrder.label,
            Icons.shuffle,
          ),
          _buildDetailRow(
            theme,
            'Pénalité',
            '${tontine.penaltyPercentage}%',
            Icons.warning,
          ),
          if (tontine.rules.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Règles:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            ...tontine.rules
                .take(3)
                .map(
                  (rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        Expanded(
                          child: Text(rule, style: theme.textTheme.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
            if (tontine.rules.length > 3)
              Text(
                '... et ${tontine.rules.length - 3} autres règles',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Obx(() {
      final error = controller.searchError?.value;
      if (error?.isEmpty == true) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInstructions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Comment rejoindre une tontine ?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '1. Demandez le code d\'invitation à l\'organisateur\n'
            '2. Saisissez le code de 6 caractères ci-dessus\n'
            '3. Ou scannez le QR code avec l\'appareil photo\n'
            '4. Vérifiez les détails et rejoignez la tontine',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TontinePreviewCard extends StatelessWidget {
  final Tontine tontine;

  const _TontinePreviewCard({required this.tontine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _getHeaderIcon(),
                  color: _getStatusColor(theme),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tontine.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(theme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tontine.status.label.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(theme),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                CupertinoIcons.group,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${tontine.participantIds.length} / ${tontine.maxParticipants} Membres',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    switch (tontine.status) {
      case TontineStatus.active:
        return Colors.green.shade600;
      case TontineStatus.pending:
        return Colors.blue.shade600;
      case TontineStatus.completed:
        return theme.colorScheme.primary;
      case TontineStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  IconData _getHeaderIcon() {
    switch (tontine.frequency) {
      case TontineFrequency.daily:
        return Icons.wb_sunny;
      case TontineFrequency.weekly:
        return Icons.calendar_today;
      case TontineFrequency.monthly:
        return Icons.calendar_month;
      default:
        return CupertinoIcons.group;
    }
  }
}

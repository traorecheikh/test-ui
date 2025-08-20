import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/tontine.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/godly_vibrate_button.dart';
import '../controllers/create_tontine_controller.dart';

class CreateTontineScreen extends GetView<CreateTontineController> {
  const CreateTontineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.group_add, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 10),
            const Text('Créer une Tontine'),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildBasicInfoSection(theme),
                  const SizedBox(height: 32),
                  _buildFinancialSection(theme),
                  const SizedBox(height: 32),
                  _buildParticipantsSection(theme),
                  const SizedBox(height: 32),
                  _buildScheduleSection(theme),
                  const SizedBox(height: 32),
                  _buildImageSection(theme),
                  const SizedBox(height: 32),
                  _buildRulesSection(theme),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.08)),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GodlyVibrateButton(
                  onTap: controller.isLoading.value ? null : () => Get.back(),
                  child: OutlinedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                flex: 2,
                child: GodlyVibrateButton(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.createTontine,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.createTontine,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Créer la Tontine'),
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

  Widget _buildBasicInfoSection(ThemeData theme) {
    return _buildSection(theme, 'Informations de Base', [
      TextFormField(
        controller: controller.nameController,
        decoration: const InputDecoration(
          labelText: 'Nom de la tontine *',
          hintText: 'Ex: Tontine Famille',
          prefixIcon: Icon(Icons.group),
        ),
        validator: controller.nameValidator,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: controller.descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description *',
          hintText: 'Décrivez l\'objectif de votre tontine',
          prefixIcon: Icon(Icons.description),
        ),
        maxLines: 3,
        validator: controller.descriptionValidator,
      ),
    ]);
  }

  Widget _buildFinancialSection(ThemeData theme) {
    return _buildSection(theme, 'Configuration Financière', [
      TextFormField(
        controller: controller.amountController,
        decoration: const InputDecoration(
          labelText: 'Montant de contribution (FCFA) *',
          hintText: '25000',
          prefixIcon: Icon(Icons.account_balance_wallet),
          suffixText: 'FCFA',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: controller.amountValidator,
      ),
      const SizedBox(height: 16),
      Obx(
        () => DropdownButtonFormField<TontineFrequency>(
          value: controller.selectedFrequency.value,
          decoration: const InputDecoration(
            labelText: 'Fréquence des contributions',
            prefixIcon: Icon(Icons.schedule),
          ),
          items: TontineFrequency.values.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text(frequency.label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.selectedFrequency.value = value;
          },
        ),
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: controller.penaltyController,
        decoration: const InputDecoration(
          labelText: 'Pénalité de retard (%)',
          hintText: '5',
          prefixIcon: Icon(Icons.warning),
          suffixText: '%',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        validator: controller.penaltyValidator,
      ),
    ]);
  }

  Widget _buildParticipantsSection(ThemeData theme) {
    return _buildSection(theme, 'Configuration des Participants', [
      TextFormField(
        controller: controller.maxParticipantsController,
        decoration: const InputDecoration(
          labelText: 'Nombre maximum de participants',
          hintText: '12',
          prefixIcon: Icon(Icons.people),
          helperText: '2 à 50 participants',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: controller.maxParticipantsValidator,
      ),
      const SizedBox(height: 16),
      Obx(
        () => DropdownButtonFormField<TontineDrawOrder>(
          value: controller.selectedDrawOrder.value,
          decoration: const InputDecoration(
            labelText: 'Ordre de distribution',
            prefixIcon: Icon(Icons.shuffle),
          ),
          items: TontineDrawOrder.values.map((order) {
            return DropdownMenuItem(value: order, child: Text(order.label));
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.selectedDrawOrder.value = value;
          },
        ),
      ),
    ]);
  }

  Widget _buildScheduleSection(ThemeData theme) {
    return _buildSection(theme, 'Planification', [
      Obx(
        () => ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date de début'),
          subtitle: Text(Formatters.formatDate(controller.startDate.value)),
          onTap: controller.selectStartDate,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildImageSection(ThemeData theme) {
    return _buildSection(theme, 'Image de la Tontine (Optionnel)', [
      const Text(
        'Choisissez une image pour votre tontine:',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 12),
      Obx(
        () => SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.sampleImages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => controller.selectedImageUrl.value = null,
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: controller.selectedImageUrl.value == null
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.outline.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.selectedImageUrl.value == null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: controller.selectedImageUrl.value == null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                );
              }
              final imageUrl = controller.sampleImages[index - 1];
              return GestureDetector(
                onTap: () => controller.selectedImageUrl.value = imageUrl,
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.selectedImageUrl.value == imageUrl
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }

  Widget _buildRulesSection(ThemeData theme) {
    return _buildSection(theme, 'Règles de la Tontine', [
      const Text(
        'Règles par défaut (vous pouvez les modifier):',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 8),
      Obx(
        () => Column(
          children: controller.rules.asMap().entries.map((entry) {
            final index = entry.key;
            final rule = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(rule)),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () => controller.editRule(index),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      TextButton.icon(
        onPressed: controller.addRule,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une règle'),
      ),
    ]);
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              color: theme.colorScheme.primary.withOpacity(0.18),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}

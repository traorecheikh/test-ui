import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_tontine_controller.dart';

/// Modern, step-by-step Create Tontine UI following best UX/UI practices.
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
      ),
      body: Obx(
        () => Stepper(
          type: StepperType.vertical,
          currentStep: controller.currentStep.value,
          onStepContinue: controller.nextStep,
          onStepCancel: controller.previousStep,
          controlsBuilder: (context, details) {
            return Row(
              children: [
                if (controller.currentStep.value > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Retour'),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    controller.isLastStep ? 'Créer la Tontine' : 'Suivant',
                  ),
                ),
              ],
            );
          },
          steps: [
            Step(
              title: const Text('Informations de Base'),
              content: _buildBasicInfoSection(theme),
              isActive: controller.currentStep.value == 0,
            ),
            Step(
              title: const Text('Configuration Financière'),
              content: _buildFinancialSection(theme),
              isActive: controller.currentStep.value == 1,
            ),
            Step(
              title: const Text('Participants & Organisation'),
              content: _buildParticipantsSection(theme),
              isActive: controller.currentStep.value == 2,
            ),
            Step(
              title: const Text('Règles & Pénalités'),
              content: _buildRulesSection(theme),
              isActive: controller.currentStep.value == 3,
            ),
            Step(
              title: const Text('Aperçu & Confirmation'),
              content: _buildPreviewSection(theme),
              isActive: controller.currentStep.value == 4,
            ),
          ],
        ),
      ),
    );
  }

  /// Step 1: Basic Info
  Widget _buildBasicInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            labelText: 'Nom de la tontine *',
            hintText: 'Ex: Tontine Famille',
            prefixIcon: Icon(Icons.group),
            helperText: 'Le nom doit être unique et descriptif.',
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
            helperText: 'Expliquez le but et les règles principales.',
          ),
          maxLines: 3,
          validator: controller.descriptionValidator,
        ),
      ],
    );
  }

  /// Step 2: Financials
  Widget _buildFinancialSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.amountController,
          decoration: const InputDecoration(
            labelText: 'Montant de contribution (FCFA) *',
            hintText: '25000',
            prefixIcon: Icon(Icons.account_balance_wallet),
            suffixText: 'FCFA',
            helperText:
                'Le montant que chaque participant doit verser à chaque tour.',
          ),
          keyboardType: TextInputType.number,
          validator: controller.amountValidator,
        ),
        const SizedBox(height: 16),
        Obx(
          () => DropdownButtonFormField(
            value: controller.selectedFrequency.value,
            decoration: const InputDecoration(
              labelText: 'Fréquence des contributions',
              prefixIcon: Icon(Icons.schedule),
              helperText: 'Choisissez la fréquence des versements.',
            ),
            items: controller.frequencyOptions,
            onChanged: (value) {
              if (value != null) controller.selectedFrequency.value = value;
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => DropdownButtonFormField(
            value: controller.selectedCurrency.value,
            decoration: const InputDecoration(
              labelText: 'Devise',
              prefixIcon: Icon(Icons.attach_money),
              helperText: 'Sélectionnez la devise utilisée.',
            ),
            items: controller.currencyOptions,
            onChanged: (value) {
              if (value != null) controller.selectedCurrency.value = value;
            },
          ),
        ),
      ],
    );
  }

  /// Step 3: Participants & Organisation
  Widget _buildParticipantsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.maxParticipantsController,
                decoration: const InputDecoration(
                  labelText: 'Nombre max. de participants',
                  prefixIcon: Icon(Icons.people),
                  helperText: 'Limite le nombre de membres dans la tontine.',
                ),
                keyboardType: TextInputType.number,
                validator: controller.maxParticipantsValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.maxHandsController,
                decoration: const InputDecoration(
                  labelText: 'Mains max. par participant',
                  prefixIcon: Icon(Icons.pan_tool),
                  helperText: 'Nombre de parts qu\'un membre peut prendre.',
                ),
                keyboardType: TextInputType.number,
                validator: controller.maxHandsValidator,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => SwitchListTile(
            title: const Text('L\'organisateur participe'),
            value: controller.organizerParticipates.value,
            onChanged: (value) =>
                controller.organizerParticipates.value = value,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.organizerHandsController,
          decoration: const InputDecoration(
            labelText: 'Nombre de mains de l\'organisateur',
            prefixIcon: Icon(Icons.pan_tool_alt),
            helperText: 'Combien de parts l\'organisateur prend.',
          ),
          keyboardType: TextInputType.number,
          validator: controller.organizerHandsValidator,
        ),
      ],
    );
  }

  /// Step 4: Rules & Penalties
  Widget _buildRulesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.gracePeriodController,
                decoration: InputDecoration(
                  labelText: 'Délai de grâce (jours)',
                  prefixIcon: const Icon(Icons.timer),
                  suffixIcon: Tooltip(
                    message:
                        'Nombre de jours avant qu\'une pénalité soit appliquée.',
                    child: const Icon(Icons.info_outline),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: controller.gracePeriodValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.penaltyRateController,
                decoration: InputDecoration(
                  labelText: 'Taux de pénalité (%)',
                  prefixIcon: const Icon(Icons.percent),
                  suffixIcon: Tooltip(
                    message: 'Pourcentage appliqué en cas de retard.',
                    child: const Icon(Icons.info_outline),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: controller.penaltyRateValidator,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.maxPenaltyController,
          decoration: InputDecoration(
            labelText: 'Pénalité max. (%)',
            prefixIcon: const Icon(Icons.warning),
            suffixIcon: Tooltip(
              message: 'Pourcentage maximum de pénalité cumulée.',
              child: const Icon(Icons.info_outline),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: controller.maxPenaltyValidator,
        ),
      ],
    );
  }

  /// Step 5: Preview & Confirmation
  Widget _buildPreviewSection(ThemeData theme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aperçu de la Tontine', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Nom: ${controller.nameController.text}'),
            Text('Description: ${controller.descriptionController.text}'),
            Text(
              'Montant:  {controller.amountController.text}  {controller.selectedCurrency.value ?? '
              '}',
            ),
            Text(
              'Fréquence:  {controller.selectedFrequency.value ?? '
              '}',
            ),
            Text(
              'Participants max: ${controller.maxParticipantsController.text}',
            ),
            Text('Mains max: ${controller.maxHandsController.text}'),
            Text(
              'Organisateur participe: ${controller.organizerParticipates.value ? 'Oui' : 'Non'}',
            ),
            Text(
              'Mains organisateur: ${controller.organizerHandsController.text}',
            ),
            Text(
              'Délai de grâce: ${controller.gracePeriodController.text} jours',
            ),
            Text('Taux de pénalité: ${controller.penaltyRateController.text}%'),
            Text('Pénalité max: ${controller.maxPenaltyController.text}%'),
          ],
        ),
      ),
    );
  }
}

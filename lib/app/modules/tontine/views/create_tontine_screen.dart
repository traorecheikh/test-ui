import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_tontine_controller.dart';

class CreateTontineScreen extends GetView<CreateTontineController> {
  const CreateTontineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.xmark,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          onPressed: () => Get.back(),
          tooltip: 'Annuler',
        ),
        title: Text(
          'Nouvelle Tontine',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => _ProgressIndicator(
              currentStep: controller.currentStep.value,
              totalSteps: controller.stepCount,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.stepCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildStep(context, index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => _NavigationControls(
          isFirstStep: controller.currentStep.value == 0,
          isLastStep: controller.currentStep.value == controller.stepCount - 1,
          onBackPressed: controller.previousStep,
          onNextPressed: controller.nextStep,
          onFinishPressed: () {
            // TODO: Implement submission logic
            Get.back(); // Go back for now
          },
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int stepIndex) {
    final List<Widget> steps = [
      _Step1BasicInfo(),
      _Step2Financials(),
      _Step3Participants(),
      _Step4Penalties(),
      _Step5Preview(),
    ];
    return steps[stepIndex];
  }
}

// --- ANIMATION WIDGET ---
class _AnimatedStaggeredList extends StatefulWidget {
  final List<Widget> children;

  const _AnimatedStaggeredList({required this.children});

  @override
  State<_AnimatedStaggeredList> createState() => _AnimatedStaggeredListState();
}

class _AnimatedStaggeredListState extends State<_AnimatedStaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 * widget.children.length),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.children.length, (index) {
          final intervalStart = (1.0 / widget.children.length) * index;
          final intervalEnd = intervalStart + (1.0 / widget.children.length);

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  intervalStart,
                  intervalEnd,
                  curve: Curves.easeOutCubic,
                ),
              );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: widget.children[index],
          );
        }),
      ),
    );
  }
}

// --- STEP WIDGETS ---

class _Step1BasicInfo extends GetView<CreateTontineController> {
  @override
  Widget build(BuildContext context) {
    return _AnimatedStaggeredList(
      children: [
        _StepHeader(
          icon: CupertinoIcons.pencil_ellipsis_rectangle,
          title: 'Dites-nous en plus',
          subtitle: 'Commencez par les informations de base de votre tontine.',
        ),
        const SizedBox(height: 32),
        _InputGroup(
          children: [
            _FluffyTextField(
              controller: controller.nameController,
              label: 'Nom de la tontine',
              hint: 'Ex: Tontine des entrepreneurs',
              icon: CupertinoIcons.group_solid,
              validator: controller.nameValidator,
            ),
            const SizedBox(height: 24),
            _FluffyTextField(
              controller: controller.descriptionController,
              label: 'Description',
              hint: 'Quel est l’objectif de cette tontine ?',
              icon: CupertinoIcons.text_alignleft,
              validator: controller.descriptionValidator,
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }
}

class _Step2Financials extends GetView<CreateTontineController> {
  @override
  Widget build(BuildContext context) {
    return _AnimatedStaggeredList(
      children: [
        _StepHeader(
          icon: CupertinoIcons.money_dollar_circle,
          title: 'Aspects Financiers',
          subtitle: 'Définissez les montants et la fréquence des cotisations.',
        ),
        const SizedBox(height: 32),
        _InputGroup(
          children: [
            _FluffyTextField(
              controller: controller.amountController,
              label: 'Montant de la cotisation',
              hint: 'Ex: 50000',
              icon: CupertinoIcons.money_dollar,
              keyboardType: TextInputType.number,
              validator: controller.amountValidator,
            ),
            const SizedBox(height: 24),
            Obx(
              () => _FluffyDropdown(
                value: controller.selectedCurrency.value,
                items: controller.currencyOptions,
                onChanged: (val) => controller.selectedCurrency.value = val,
                label: 'Devise',
                icon: CupertinoIcons.globe,
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => _FluffyDropdown(
                value: controller.selectedFrequency.value,
                items: controller.frequencyOptions,
                onChanged: (val) => controller.selectedFrequency.value = val,
                label: 'Fréquence des cotisations',
                icon: CupertinoIcons.calendar,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Step3Participants extends GetView<CreateTontineController> {
  @override
  Widget build(BuildContext context) {
    return _AnimatedStaggeredList(
      children: [
        _StepHeader(
          icon: CupertinoIcons.person_2,
          title: 'Membres & Organisation',
          subtitle: 'Qui peut participer et comment ?',
        ),
        const SizedBox(height: 32),
        _InputGroup(
          children: [
            _FluffyTextField(
              controller: controller.maxParticipantsController,
              label: 'Maximum de participants',
              hint: 'Ex: 12',
              icon: CupertinoIcons.person_2_fill,
              keyboardType: TextInputType.number,
              validator: controller.maxParticipantsValidator,
            ),
            const SizedBox(height: 24),
            _FluffyTextField(
              controller: controller.maxHandsController,
              label: 'Mains max. par participant',
              hint: 'Ex: 1',
              icon: CupertinoIcons.hand_raised_fill,
              keyboardType: TextInputType.number,
              validator: controller.maxHandsValidator,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _InputGroup(
          children: [
            Obx(
              () => _SwitchTile(
                label: 'L’organisateur participe-t-il ?',
                value: controller.organizerParticipates.value,
                onChanged: (val) =>
                    controller.organizerParticipates.value = val,
                icon: CupertinoIcons.person_crop_circle_badge_checkmark,
              ),
            ),
            Obx(() {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: Visibility(
                  visible: controller.organizerParticipates.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _FluffyTextField(
                      controller: controller.organizerHandsController,
                      label: 'Nombre de mains de l’organisateur',
                      hint: 'Ex: 1',
                      icon: CupertinoIcons.hand_raised_fill,
                      keyboardType: TextInputType.number,
                      validator: controller.organizerHandsValidator,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

class _Step4Penalties extends GetView<CreateTontineController> {
  @override
  Widget build(BuildContext context) {
    return _AnimatedStaggeredList(
      children: [
        _StepHeader(
          icon: CupertinoIcons.exclamationmark_shield,
          title: 'Règles & Pénalités',
          subtitle: 'Que se passe-t-il en cas de retard de paiement ?',
        ),
        const SizedBox(height: 32),
        _InputGroup(
          children: [
            Obx(
              () => _SwitchTile(
                label: 'Activer les pénalités de retard',
                value: controller.penaltiesEnabled.value,
                onChanged: (val) => controller.penaltiesEnabled.value = val,
                icon: CupertinoIcons.exclamationmark_triangle_fill,
              ),
            ),
            Obx(() {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: Visibility(
                  visible: controller.penaltiesEnabled.value,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      _FluffyTextField(
                        controller: controller.gracePeriodController,
                        label: 'Délai de grâce (en jours)',
                        hint: 'Ex: 3',
                        icon: CupertinoIcons.timer_fill,
                        keyboardType: TextInputType.number,
                        validator: controller.gracePeriodValidator,
                      ),
                      const SizedBox(height: 24),
                      _FluffyTextField(
                        controller: controller.penaltyRateController,
                        label: 'Taux de pénalité (%)',
                        hint: 'Ex: 5',
                        icon: CupertinoIcons.percent,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: controller.penaltyRateValidator,
                      ),
                      const SizedBox(height: 24),
                      _FluffyTextField(
                        controller: controller.maxPenaltyController,
                        label: 'Pénalité maximale (%)',
                        hint: 'Ex: 50',
                        icon: CupertinoIcons.chart_pie_fill,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: controller.maxPenaltyValidator,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

class _Step5Preview extends GetView<CreateTontineController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _AnimatedStaggeredList(
      children: [
        _StepHeader(
          icon: CupertinoIcons.checkmark_seal_fill,
          title: 'Presque Fini !',
          subtitle: 'Vérifiez les informations avant de créer votre tontine.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreviewRow(
                theme,
                'Nom',
                controller.nameController.text,
                CupertinoIcons.group_solid,
              ),
              _buildPreviewRow(
                theme,
                'Montant',
                '${controller.amountController.text} ${controller.selectedCurrency.value}',
                CupertinoIcons.money_dollar,
              ),
              _buildPreviewRow(
                theme,
                'Fréquence',
                controller.selectedFrequency.value ?? '-',
                CupertinoIcons.calendar,
              ),
              _buildPreviewRow(
                theme,
                'Participants',
                controller.maxParticipantsController.text,
                CupertinoIcons.person_2_fill,
              ),
              if (controller.penaltiesEnabled.value)
                _buildPreviewRow(
                  theme,
                  'Pénalité',
                  '${controller.penaltyRateController.text}% après ${controller.gracePeriodController.text} jours',
                  CupertinoIcons.exclamationmark_shield_fill,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
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

// --- UI Building Blocks ---

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (currentStep + 1) / totalSteps;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'Étape ${currentStep + 1} sur $totalSteps',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(percentage * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 48),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _InputGroup extends StatelessWidget {
  final List<Widget> children;

  const _InputGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _FluffyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;

  const _FluffyTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            filled: true,
            fillColor: theme.colorScheme.primary.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FluffyDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onChanged;
  final String label;
  final IconData icon;

  const _FluffyDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: theme.colorScheme.primary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            filled: true,
            fillColor: theme.colorScheme.primary.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final IconData icon;

  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
      ],
    );
  }
}

class _NavigationControls extends StatelessWidget {
  final bool isFirstStep;
  final bool isLastStep;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onFinishPressed;

  const _NavigationControls({
    required this.isFirstStep,
    required this.isLastStep,
    required this.onBackPressed,
    required this.onNextPressed,
    required this.onFinishPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            TextButton.icon(
              onPressed: onBackPressed,
              icon: const Icon(CupertinoIcons.arrow_left),
              label: const Text('Retour'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: isLastStep ? onFinishPressed : onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              elevation: 5,
              shadowColor: theme.colorScheme.primary.withOpacity(0.3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLastStep ? 'Terminer' : 'Suivant',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isLastStep
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.arrow_right,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

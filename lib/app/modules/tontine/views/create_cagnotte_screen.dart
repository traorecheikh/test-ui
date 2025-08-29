import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snt_ui_test/app/modules/tontine/controllers/create_cagnotte_controller.dart';

class CreateCagnotteScreen extends GetView<CreateCagnotteController> {
  const CreateCagnotteScreen({super.key});

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
          'Nouvelle Cagnotte',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _StepHeader(
              icon: CupertinoIcons.cube_box_fill,
              title: 'Créez votre Cagnotte',
              subtitle: 'Rassemblez des fonds pour un objectif commun.',
            ),
            const SizedBox(height: 32),
            _InputGroup(
              children: [
                _FluffyTextField(
                  controller: controller.nameController,
                  label: 'Nom de la cagnotte',
                  hint: 'Ex: Cagnotte pour l\'anniversaire de...', 
                  icon: CupertinoIcons.gift_fill,
                ),
                const SizedBox(height: 24),
                _FluffyTextField(
                  controller: controller.descriptionController,
                  label: 'Description',
                  hint: 'Quel est l’objectif de cette cagnotte ?',
                  icon: CupertinoIcons.text_alignleft,
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InputGroup(
              children: [
                _FluffyTextField(
                  controller: controller.amountController,
                  label: 'Montant de la cotisation',
                  hint: 'Ex: 5000',
                  icon: CupertinoIcons.money_dollar,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _FluffyTextField(
                  controller: controller.maxParticipantsController,
                  label: 'Maximum de participants',
                  hint: 'Ex: 20',
                  icon: CupertinoIcons.person_2_fill,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _NavigationControls(
        onFinishPressed: controller.submitCagnotte,
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

class _NavigationControls extends StatelessWidget {
  final VoidCallback onFinishPressed;

  const _NavigationControls({
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
          const Spacer(),
          ElevatedButton(
            onPressed: onFinishPressed,
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Créer la Cagnotte',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
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
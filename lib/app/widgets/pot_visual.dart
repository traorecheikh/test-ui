import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class PotVisualWidget extends StatefulWidget {
  final double currentAmount;
  final double targetAmount;
  final int paidParticipants;
  final int totalParticipants;
  final bool isAnimated;
  final VoidCallback? onTap;

  const PotVisualWidget({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    required this.paidParticipants,
    required this.totalParticipants,
    this.isAnimated = true,
    this.onTap,
  });

  @override
  State<PotVisualWidget> createState() => _PotVisualWidgetState();
}

class _PotVisualWidgetState extends State<PotVisualWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fillAnimation;
  late Animation<double> _dropAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fillAnimation =
        Tween<double>(
          begin: 0.0,
          end: widget.currentAmount / widget.targetAmount,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _dropAnimation = Tween<double>(begin: -20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    if (widget.isAnimated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.currentAmount / widget.targetAmount;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildPotHeader(theme),
            const SizedBox(height: 16),
            _buildPotVisual(theme, percentage),
            const SizedBox(height: 16),
            _buildPotInfo(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPotHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'POT VISUEL',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(widget.currentAmount / widget.targetAmount),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(widget.currentAmount / widget.targetAmount * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPotVisual(ThemeData theme, double percentage) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Pot container
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              // Liquid fill
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(47),
                  bottomRight: Radius.circular(47),
                ),
                child: Container(
                  width: 94,
                  height:
                      94 *
                      (widget.isAnimated ? _fillAnimation.value : percentage),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _getLiquidColor(percentage).withValues(alpha: 0.8),
                        _getLiquidColor(percentage),
                      ],
                    ),
                  ),
                ),
              ),
              // Animated drops
              if (widget.isAnimated && percentage > 0)
                ..._buildAnimatedDrops(theme, percentage),
              // Pot icon
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getPotIcon(percentage),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPotInfo(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Formatters.formatCurrency(widget.currentAmount),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              '/ ${Formatters.formatCurrency(widget.targetAmount)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: widget.currentAmount / widget.targetAmount,
                backgroundColor: theme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getLiquidColor(widget.currentAmount / widget.targetAmount),
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Versé: ${widget.paidParticipants}/${widget.totalParticipants} personnes',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAnimatedDrops(ThemeData theme, double percentage) {
    if (percentage < 0.1) return [];

    return [
      Positioned(
        top: 30 + _dropAnimation.value,
        left: 35,
        child: Container(
          width: 8,
          height: 12,
          decoration: BoxDecoration(
            color: _getLiquidColor(percentage),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ),
      Positioned(
        top: 25 + _dropAnimation.value,
        right: 30,
        child: Container(
          width: 6,
          height: 10,
          decoration: BoxDecoration(
            color: _getLiquidColor(percentage).withValues(alpha: 0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
        ),
      ),
    ];
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 1.0) return Colors.green;
    if (percentage >= 0.75) return Colors.orange;
    if (percentage >= 0.5) return Colors.blue;
    return Colors.red;
  }

  Color _getLiquidColor(double percentage) {
    if (percentage >= 1.0) return Colors.green;
    if (percentage >= 0.75) return Colors.orange;
    if (percentage >= 0.5) return Colors.blue;
    return Colors.red.withValues(alpha: 0.7);
  }

  IconData _getPotIcon(double percentage) {
    if (percentage >= 1.0) return Icons.celebration;
    if (percentage >= 0.75) return Icons.trending_up;
    if (percentage >= 0.5) return Icons.savings;
    return Icons.hourglass_empty;
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.white.withOpacity(0.85),
              theme.colorScheme.primaryContainer.withOpacity(0.1),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPotHeader(theme),
              const SizedBox(height: 4),
              Expanded(
                flex: 3,
                child: _buildPotVisual(theme, percentage),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: _buildPotInfo(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPotHeader(ThemeData theme) {
    final percentage = widget.currentAmount / widget.targetAmount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(percentage).withOpacity(0.1),
            _getStatusColor(percentage).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(percentage).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getStatusColor(percentage).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.savings,
                  color: _getStatusColor(percentage),
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'CAGNOTTE',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(percentage),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(percentage),
                  _getStatusColor(percentage).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(percentage).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotVisual(ThemeData theme, double percentage) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 60,
            maxHeight: 100,
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
            alignment: Alignment.center,
            children: [
              // Enhanced outer glow with Teranga cultural colors
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    colors: [
                      _getTerangaGlow(percentage).withOpacity(0.15),
                      _getTerangaGlow(percentage).withOpacity(0.08),
                      _getTerangaGlow(percentage).withOpacity(0.03),
                      Colors.transparent,
                    ],
                    stops: const [0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
              // Cultural ornamental ring
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getTerangaAccent(percentage).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: CustomPaint(
                  painter: _TontineOrnamentPainter(
                    color: _getTerangaAccent(percentage).withOpacity(0.3),
                    progress: widget.isAnimated ? _fillAnimation.value : percentage,
                  ),
                ),
              ),
              // Main traditional pot with African-inspired curves
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.8),
                      _getTerangaBase(percentage).withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  border: Border.all(
                    color: _getLiquidColor(percentage).withOpacity(0.4),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getLiquidColor(percentage).withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 12,
                      offset: const Offset(-3, -3),
                    ),
                    BoxShadow(
                      color: _getTerangaGlow(percentage).withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 5),
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
              // Enhanced liquid fill with cultural gradient
              Positioned(
                bottom: 1.5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  child: Container(
                    width: 55,
                    height: 55 * (widget.isAnimated ? _fillAnimation.value : percentage),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getLiquidColor(percentage).withOpacity(0.6),
                          _getLiquidColor(percentage).withOpacity(0.8),
                          _getLiquidColor(percentage),
                          _getTerangaDeep(percentage),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              // Enhanced liquid surface with wave effect
              if (percentage > 0.1)
                Positioned(
                  bottom: 1.5 + (55 * (widget.isAnimated ? _fillAnimation.value : percentage)),
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.6),
                          Colors.white.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              // Teranga-inspired animated drops
              if (widget.isAnimated && percentage > 0)
                ..._buildTerangaAnimatedDrops(theme, percentage),
              // Cultural icon with enhanced glow
              Positioned(
                top: 1,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _getTerangaAccent(percentage),
                        _getTerangaAccent(percentage).withOpacity(0.8),
                        _getLiquidColor(percentage),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getTerangaGlow(percentage).withOpacity(0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getTerangaIcon(percentage),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPotInfo(ThemeData theme) {
    final percentage = widget.currentAmount / widget.targetAmount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getLiquidColor(percentage).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getLiquidColor(percentage).withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              Formatters.formatCurrency(widget.currentAmount),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getLiquidColor(percentage),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: 0.5,
            color: _getLiquidColor(percentage).withOpacity(0.3),
          ),
          Expanded(
            child: Text(
              '${widget.paidParticipants}/${widget.totalParticipants}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTerangaAnimatedDrops(ThemeData theme, double percentage) {
    if (percentage < 0.15) return [];

    return [
      // Golden prosperity drop (left)
      Positioned(
        top: 25 + _dropAnimation.value * 0.8,
        left: 32,
        child: Container(
          width: 12,
          height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getTerangaGold().withOpacity(0.9),
                _getTerangaGold(),
                _getLiquidColor(percentage),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: _getTerangaGold().withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
      // Community bond drop (right)
      Positioned(
        top: 22 + _dropAnimation.value,
        right: 28,
        child: Container(
          width: 10,
          height: 14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getTerangaAccent(percentage).withOpacity(0.7),
                _getLiquidColor(percentage).withOpacity(0.9),
                _getTerangaDeep(percentage),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: _getTerangaAccent(percentage).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      // Sparkle effects for prosperity
      if (percentage > 0.8) ..._buildProsperitySparkles(percentage),
    ];
  }

  List<Widget> _buildProsperitySparkles(double percentage) {
    return [
      Positioned(
        top: 15,
        left: 45,
        child: Transform.rotate(
          angle: _animationController.value * 2 * math.pi,
          child: Icon(
            Icons.auto_awesome,
            color: _getTerangaGold().withOpacity(0.8),
            size: 12,
          ),
        ),
      ),
      Positioned(
        top: 35,
        right: 20,
        child: Transform.rotate(
          angle: -_animationController.value * 2 * math.pi,
          child: Icon(
            Icons.auto_awesome,
            color: _getTerangaGold().withOpacity(0.6),
            size: 8,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEnhancedAnimatedDrops(ThemeData theme, double percentage) {
    return _buildTerangaAnimatedDrops(theme, percentage);
  }

  List<Widget> _buildAnimatedDrops(ThemeData theme, double percentage) {
    return _buildEnhancedAnimatedDrops(theme, percentage);
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 1.0) return const Color(0xFF34C759); // App tertiary (success green)
    if (percentage >= 0.75) return const Color(0xFF4A90E2); // App secondary (light blue)
    if (percentage >= 0.5) return const Color(0xFF1B365D); // App primary (dark blue)
    return const Color(0xFFFF3B30); // App error (red)
  }

  Color _getLiquidColor(double percentage) {
    if (percentage >= 1.0) return const Color(0xFF34C759); // App tertiary (success green)
    if (percentage >= 0.75) return const Color(0xFF4A90E2); // App secondary (light blue)
    if (percentage >= 0.5) return const Color(0xFF1B365D); // App primary (dark blue)
    return const Color(0xFFFF3B30); // App error (red)
  }

  IconData _getTerangaIcon(double percentage) {
    if (percentage >= 1.0) return Icons.celebration; // Completed with joy
    if (percentage >= 0.75) return Icons.favorite; // Community love
    if (percentage >= 0.5) return Icons.handshake; // Unity
    if (percentage >= 0.25) return Icons.savings; // Growing savings
    return Icons.scatter_plot; // Seeds of prosperity
  }

  IconData _getPotIcon(double percentage) {
    return _getTerangaIcon(percentage);
  }

  // Teranga-inspired color palette
  Color _getTerangaGold() => const Color(0xFFE4A853); // Senegalese gold
  
  Color _getTerangaGreen() => const Color(0xFF34C759); // Prosperity green
  
  Color _getTerangaRed() => const Color(0xFFD4391F); // Traditional red
  
  Color _getTerangaGlow(double percentage) {
    if (percentage >= 0.9) return _getTerangaGold();
    if (percentage >= 0.7) return _getTerangaGreen();
    return const Color(0xFF4A90E2);
  }
  
  Color _getTerangaAccent(double percentage) {
    if (percentage >= 0.8) return _getTerangaGold();
    if (percentage >= 0.6) return _getTerangaGreen();
    return const Color(0xFF4A90E2);
  }
  
  Color _getTerangaBase(double percentage) {
    return _getLiquidColor(percentage);
  }
  
  Color _getTerangaDeep(double percentage) {
    if (percentage >= 0.8) return _getTerangaGold().withOpacity(0.9);
    if (percentage >= 0.6) return _getTerangaGreen().withOpacity(0.9);
    return const Color(0xFF1B365D);
  }
}

// Custom painter for Teranga ornamental ring
class _TontineOrnamentPainter extends CustomPainter {
  final Color color;
  final double progress;

  _TontineOrnamentPainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Draw ornamental arcs representing community unity
    const int segments = 8;
    final double segmentAngle = 2 * math.pi / segments;
    
    for (int i = 0; i < segments; i++) {
      final startAngle = i * segmentAngle - math.pi / 2;
      final sweepAngle = segmentAngle * 0.6; // Gap between segments
      
      // Fade based on progress for visual storytelling
      final segmentProgress = (progress * segments - i).clamp(0.0, 1.0);
      paint.color = color.withOpacity(segmentProgress * 0.6 + 0.2);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      
      // Add small decorative dots
      if (segmentProgress > 0.3) {
        final dotAngle = startAngle + sweepAngle / 2;
        final dotX = center.dx + (radius + 3) * math.cos(dotAngle);
        final dotY = center.dy + (radius + 3) * math.sin(dotAngle);
        
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(dotX, dotY),
          2.0 * segmentProgress,
          paint,
        );
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import '../services/vibration_service.dart';

class GodlyVibrateButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final bool useGodlyVibration;

  const GodlyVibrateButton({
    Key? key,
    required this.child,
    this.onTap,
    this.scale = 0.93,
    this.duration = const Duration(milliseconds: 90),
    this.useGodlyVibration = true,
  }) : super(key: key);

  @override
  State<GodlyVibrateButton> createState() => _GodlyVibrateButtonState();
}

class _GodlyVibrateButtonState extends State<GodlyVibrateButton> {
  bool _pressed = false;

  void _handleTapDown(_) {
    setState(() => _pressed = true);
    if (widget.useGodlyVibration) {
      VibrationService.godlyVibrate();
    } else {
      VibrationService.softVibrate();
    }
  }

  void _handleTapUp(_) {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.translucent,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ActionButtonData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ActionButtonData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

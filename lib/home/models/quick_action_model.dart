import 'package:flutter/material.dart';

class QuickActionModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool isPremium;
  final String action;

  const QuickActionModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.action,
    this.isPremium = false,
  });
}
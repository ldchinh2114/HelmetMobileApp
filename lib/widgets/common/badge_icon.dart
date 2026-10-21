import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// An icon with a small count badge, drawn in the classic house style.
class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final double size;
  final Color? color;

  const BadgeIcon({
    super.key,
    required this.icon,
    this.count = 0,
    this.size = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: size, color: color ?? AppColors.ink),
        if (count > 0)
          Positioned(
            right: -7,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: AppTextStyles.badgeCount,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final double size;

  const BadgeIcon({
    super.key,
    required this.icon,
    this.count = 0,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: size, color: AppColors.black),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
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
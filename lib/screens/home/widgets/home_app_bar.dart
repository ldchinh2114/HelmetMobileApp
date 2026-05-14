import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../widgets/common/badge_icon.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: AppColors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.black, size: 26),
          onPressed: () {},
        ),
      ),
      title: const Text(
        'HELMO',
        style: AppTextStyles.logo,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: IconButton(
            icon: const BadgeIcon(icon: Icons.notifications_outlined, count: 3, size: 26),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
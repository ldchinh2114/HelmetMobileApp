import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  const SectionHeader.withSeeAll({
    super.key,
    required this.title,
    this.onAction,
  }) : actionLabel = 'Xem tất cả';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(actionLabel!, style: AppTextStyles.seeAll),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.gray),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
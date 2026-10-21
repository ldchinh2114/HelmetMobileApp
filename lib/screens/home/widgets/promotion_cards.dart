import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../widgets/common/classic_ui.dart';
import 'section_header.dart';

class PromotionCards extends StatelessWidget {
  const PromotionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Ưu đãi dành riêng cho bạn',
            eyebrow: 'Thành viên',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Row(
            children: [
              Expanded(
                child: _PromotionCard(
                  icon: Icons.local_offer_outlined,
                  title: 'Ưu đãi hôm nay',
                  subtitle: 'Giảm đến 30%',
                  accent: AppColors.primary,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _PromotionCard(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Thành viên HELMO',
                  subtitle: 'Tích điểm đổi quà',
                  accent: AppColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromotionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _PromotionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: accent, size: 19),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.productName.copyWith(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.meta.copyWith(fontSize: 11.5)),
          const SizedBox(height: AppSpacing.md),
          const GoldRule(width: 22),
        ],
      ),
    );
  }
}

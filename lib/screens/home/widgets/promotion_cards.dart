import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';

class PromotionCards extends StatelessWidget {
  const PromotionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _PromotionCard(
                icon: Icons.local_offer,
                title: 'Ưu đãi hôm nay',
                subtitle: 'Giảm đến 30%',
                gradientColors: const [Color(0xFFE53935), Color(0xFFC62828)],
              )),
              const SizedBox(width: 12),
              Expanded(child: _PromotionCard(
                icon: Icons.card_giftcard,
                title: 'Thành viên HELMO',
                subtitle: 'Tích điểm đổi quà',
                gradientColors: const [Color(0xFF212121), Color(0xFF424242)],
              )),
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
  final List<Color> gradientColors;

  const _PromotionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.promotionTitle.copyWith(fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.promotionSubtitle.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
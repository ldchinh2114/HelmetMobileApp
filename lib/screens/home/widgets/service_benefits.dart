import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';

class _BenefitItem {
  final IconData icon;
  final String label;

  const _BenefitItem({required this.icon, required this.label});
}

const List<_BenefitItem> _benefits = [
  _BenefitItem(icon: Icons.verified_outlined, label: 'Chính hãng\n100%'),
  _BenefitItem(icon: Icons.local_shipping_outlined, label: 'Freeship\ntoàn quốc'),
  _BenefitItem(icon: Icons.build_outlined, label: 'Bảo hành\n12 tháng'),
  _BenefitItem(icon: Icons.swap_horiz, label: 'Đổi trả\n7 ngày'),
];

class ServiceBenefits extends StatelessWidget {
  const ServiceBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < _benefits.length; i++) ...[
              if (i > 0)
                const VerticalDivider(
                  width: AppSpacing.lg,
                  thickness: 1,
                  color: AppColors.hairline,
                ),
              Expanded(child: _BenefitCard(item: _benefits[i])),
            ],
          ],
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final _BenefitItem item;

  const _BenefitCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, color: AppColors.primary, size: 22),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.label,
          style: AppTextStyles.meta.copyWith(
            fontSize: 11,
            height: 1.35,
            color: AppColors.ink,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

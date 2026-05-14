import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';

class _BenefitItem {
  final IconData icon;
  final String label;

  const _BenefitItem({required this.icon, required this.label});
}

const List<_BenefitItem> _benefits = [
  _BenefitItem(icon: Icons.verified, label: 'Chính hãng\n100%'),
  _BenefitItem(icon: Icons.local_shipping, label: 'Freeship\ntoàn quốc'),
  _BenefitItem(icon: Icons.miscellaneous_services, label: 'Bảo hành\nchính hãng'),
  _BenefitItem(icon: Icons.swap_horiz, label: 'Đổi trả\n7 ngày'),
];

class ServiceBenefits extends StatelessWidget {
  const ServiceBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _benefits.map((item) => _BenefitCard(item: item)).toList(),
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
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(item.icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: AppTextStyles.benefitText,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
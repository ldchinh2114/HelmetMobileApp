import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_theme.dart';
import '../../../providers/home_provider.dart';
import '../../../widgets/common/classic_ui.dart';

/// A classic side drawer: wordmark, catalogue index and a short house note.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HELMO', style: AppTextStyles.wordmark),
                  SizedBox(height: AppSpacing.sm),
                  GoldRule(width: 34),
                ],
              ),
            ),
            const Hairline(),
            const SizedBox(height: AppSpacing.md),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Eyebrow('Danh mục'),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...mockCategories.map(
              (category) => _DrawerItem(
                label: category.name,
                icon: Icons.chevron_right,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/category');
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Hairline(),
            const SizedBox(height: AppSpacing.md),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Eyebrow('Tài khoản'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DrawerItem(
              label: 'Giỏ hàng',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/cart');
              },
            ),
            _DrawerItem(
              label: 'Yêu thích',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/wishlist');
              },
            ),
            _DrawerItem(
              label: 'Tài khoản',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/profile');
              },
            ),
            const Spacer(),
            const Hairline(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mũ bảo hiểm chính hãng',
                    style: AppTextStyles.label.copyWith(fontSize: 12.5),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Đạt tiêu chuẩn ECE 22.05 · Bảo hành 12 tháng',
                    style: AppTextStyles.meta,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '© 2026 HELMO',
                    style: AppTextStyles.meta.copyWith(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      color: AppColors.inkFaint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _DrawerItem({required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.label)),
            if (icon != null)
              Icon(icon, size: 16, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../widgets/common/classic_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Tài khoản', style: AppTextStyles.sectionTitle),
        centerTitle: true,
        shape: const Border(bottom: AppBorders.hairline),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: const [
          _ProfileHeader(),
          SizedBox(height: AppSpacing.xl),
          _MenuGroup(
            title: 'Mua sắm',
            items: [
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                label: 'Đơn hàng của tôi',
              ),
              _MenuItem(
                icon: Icons.local_offer_outlined,
                label: 'Voucher & ưu đãi',
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                label: 'Sổ địa chỉ',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          _MenuGroup(
            title: 'Hỗ trợ',
            items: [
              _MenuItem(
                icon: Icons.help_outline,
                label: 'Trung tâm trợ giúp',
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: 'Cài đặt',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          _SignOutButton(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: AppColors.paper,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(AppBorders.gold),
            ),
            child: const Center(
              child: Text(
                'H',
                style: TextStyle(
                  fontFamily: AppFonts.display,
                  fontFamilyFallback: AppFonts.displayFallback,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Khách hàng'),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Chào mừng đến với HELMO',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 17),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => context.push('/login'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    textStyle: AppTextStyles.buttonSmall.copyWith(fontSize: 10.5),
                  ),
                  child: const Text('ĐĂNG NHẬP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Eyebrow(title),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(top: AppBorders.hairline, bottom: AppBorders.hairline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Hairline(indent: AppSpacing.xl),
                items[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.inkSoft),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: AppTextStyles.body.copyWith(fontSize: 13.5))),
            const Icon(Icons.chevron_right, size: 17, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: OutlinedButton(
        onPressed: () => showClassicSnackBar(
          context,
          'Bạn chưa đăng nhập nên không thể đăng xuất.',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.hairlineStrong),
        ),
        child: const Text('ĐĂNG XUẤT'),
      ),
    );
  }
}

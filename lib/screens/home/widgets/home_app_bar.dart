import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/common/badge_icon.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.ink, size: 23),
          tooltip: 'Menu',
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text('HELMO', style: AppTextStyles.wordmark),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: IconButton(
            tooltip: 'Giỏ hàng',
            icon: BadgeIcon(
              icon: Icons.shopping_basket_outlined,
              count: cartCount,
              size: 23,
            ),
            onPressed: () => context.go('/cart'),
          ),
        ),
      ],
      shape: const Border(bottom: AppBorders.hairline),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

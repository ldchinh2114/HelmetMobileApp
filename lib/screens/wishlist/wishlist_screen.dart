import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/home_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common/classic_ui.dart';
import '../home/widgets/product_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final products = mockFeaturedProducts
        .where((product) => wishlist.contains(product.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          products.isEmpty ? 'Yêu thích' : 'Yêu thích · ${products.length}',
          style: AppTextStyles.sectionTitle,
        ),
        centerTitle: true,
        shape: const Border(bottom: AppBorders.hairline),
      ),
      body: products.isEmpty
          ? ClassicEmptyState(
              icon: Icons.favorite_border,
              title: 'Chưa có sản phẩm yêu thích',
              message:
                  'Chạm vào biểu tượng trái tim trên sản phẩm để lưu lại cho lần sau.',
              actionLabel: 'Khám phá sản phẩm',
              onAction: () => context.go('/home'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.63,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
    );
  }
}

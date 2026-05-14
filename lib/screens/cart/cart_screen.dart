import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/home_provider.dart';
import 'widgets/cart_item_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        title: Text(
          'Giỏ hàng${cartState.itemCount > 0 ? ' (${cartState.itemCount})' : ''}',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        actions: cartState.itemCount > 0
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.gray, size: 22),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xóa giỏ hàng'),
                        content: const Text('Bạn có chắc muốn xóa tất cả sản phẩm?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(cartProvider.notifier).clearCart();
                              Navigator.pop(ctx);
                            },
                            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                            child: const Text('Xóa tất cả'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
              ]
            : null,
      ),
      body: cartState.itemCount == 0 ? _buildEmpty(context) : _buildCart(context, ref, cartState),
      bottomNavigationBar: cartState.itemCount > 0
          ? _buildBottomBar(context, ref, cartState)
          : null,
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Giỏ hàng trống',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Hãy thêm sản phẩm vào giỏ hàng',
              style: AppTextStyles.soldCount,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: const Text('Mua sắm ngay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart(BuildContext context, WidgetRef ref, CartState cartState) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: cartState.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return CartItemCard(
                item: item,
                onIncrement: () => ref.read(cartProvider.notifier).incrementQuantity(item.id),
                onDecrement: () => ref.read(cartProvider.notifier).decrementQuantity(item.id),
                onRemove: () => ref.read(cartProvider.notifier).removeItem(item.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, CartState cartState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Total
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tạm tính:', style: AppTextStyles.soldCount),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency(cartState.subtotal),
                    style: AppTextStyles.price.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            // Checkout button
            ElevatedButton(
              onPressed: () => context.push('/checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
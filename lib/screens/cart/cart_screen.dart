import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../utils/formatters.dart';
import '../../widgets/common/classic_ui.dart';
import 'widgets/cart_item_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          cartState.itemCount > 0
              ? 'Giỏ hàng · ${cartState.itemCount}'
              : 'Giỏ hàng',
          style: AppTextStyles.sectionTitle,
        ),
        centerTitle: true,
        actions: cartState.itemCount > 0
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: 'Xóa giỏ hàng',
                  onPressed: () => _confirmClear(context, ref),
                ),
                const SizedBox(width: AppSpacing.sm),
              ]
            : null,
        shape: const Border(bottom: AppBorders.hairline),
      ),
      body: cartState.itemCount == 0
          ? _buildEmpty(context)
          : _buildCart(context, ref, cartState),
      bottomNavigationBar: cartState.itemCount > 0
          ? _buildBottomBar(context, cartState)
          : null,
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content: const Text('Bạn có chắc muốn xóa tất cả sản phẩm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(cartProvider.notifier).clearCart();
    }
  }

  Widget _buildEmpty(BuildContext context) {
    return ClassicEmptyState(
      icon: Icons.shopping_basket_outlined,
      title: 'Giỏ hàng trống',
      message: 'Hãy chọn một chiếc mũ và thêm vào giỏ hàng.',
      actionLabel: 'Mua sắm ngay',
      onAction: () => context.go('/home'),
    );
  }

  Widget _buildCart(BuildContext context, WidgetRef ref, CartState cartState) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: cartState.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return CartItemCard(
          item: item,
          onIncrement: () =>
              ref.read(cartProvider.notifier).incrementQuantity(item.id),
          onDecrement: () =>
              ref.read(cartProvider.notifier).decrementQuantity(item.id),
          onRemove: () => ref.read(cartProvider.notifier).removeItem(item.id),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState cartState) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(top: AppBorders.hairline),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tạm tính', style: AppTextStyles.meta.copyWith(fontSize: 11.5)),
                const SizedBox(height: 2),
                CrossFade(
                  child: Text(
                    formatCurrency(cartState.subtotal),
                    key: ValueKey(cartState.subtotal),
                    style: AppTextStyles.price.copyWith(fontSize: 19),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => context.push('/checkout'),
            child: const Text('THANH TOÁN'),
          ),
        ],
      ),
    );
  }
}

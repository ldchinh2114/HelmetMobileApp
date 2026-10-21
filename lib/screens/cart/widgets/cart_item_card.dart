import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../models/cart_item.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/common/product_artwork.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artwork
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: ProductArtwork(
              product: item.product,
              showRoundel: false,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: AppTextStyles.productName.copyWith(fontSize: 13.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Padding(
                        padding: EdgeInsets.only(left: AppSpacing.sm),
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: AppColors.inkFaint,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Kích cỡ ${item.size} · ${item.color}',
                  style: AppTextStyles.meta.copyWith(fontSize: 11.5),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _QuantityControl(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                    const Spacer(),
                    Text(
                      formatCurrency(item.totalPrice),
                      style: AppTextStyles.priceSmall.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.hairlineStrong),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Step(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                '$quantity',
                style: AppTextStyles.meta.copyWith(
                  fontSize: 12.5,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _Step(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _Step({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(icon, size: 13, color: AppColors.inkSoft),
      ),
    );
  }
}

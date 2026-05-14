import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../models/cart_item.dart';
import '../../../providers/home_provider.dart';

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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Product image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Icon(Icons.shield, size: 36, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item.product.name,
                    style: AppTextStyles.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Size + color
                  Text(
                    'Size: ${item.size}, Màu: ${item.color}',
                    style: AppTextStyles.soldCount.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  // Price
                  Text(
                    formatCurrency(item.product.price),
                    style: AppTextStyles.price.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

            // Quantity & Remove
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Remove button
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.close, size: 18, color: AppColors.lightGray),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Quantity selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onDecrement,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(),
                          child: const Icon(Icons.remove, size: 14, color: AppColors.darkGray),
                        ),
                      ),
                      Container(
                        width: 32,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onIncrement,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(),
                          child: const Icon(Icons.add, size: 14, color: AppColors.darkGray),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Line total
                Text(
                  formatCurrency(item.totalPrice),
                  style: AppTextStyles.price.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
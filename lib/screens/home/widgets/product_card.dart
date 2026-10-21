import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/app_motion.dart';
import '../../../config/app_theme.dart';
import '../../../models/product.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/common/classic_ui.dart';
import '../../../widgets/common/product_artwork.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final isFavorite = wishlist.contains(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: ProductArtwork(product: product),
                    ),
                  ),
                  // Wishlist
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _HeartButton(
                      isFavorite: isFavorite,
                      onTap: () {
                        ref.read(wishlistProvider.notifier).toggle(product.id);
                        onFavoriteTap?.call();
                      },
                    ),
                  ),
                  // Discount
                  if (product.discountPercent != null)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '-${product.discountPercent!.round()}%',
                          style: AppTextStyles.buttonSmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const Hairline(),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyles.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatCurrency(product.price),
                          style: AppTextStyles.price,
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              formatCurrency(product.originalPrice!),
                              style: AppTextStyles.originalPrice,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final filled = index < product.rating.floor();
                          return Icon(
                            filled ? Icons.star : Icons.star_border,
                            size: 11,
                            color: filled ? AppColors.star : AppColors.inkFaint,
                          );
                        }),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            formatSoldCount(product.soldCount),
                            style: AppTextStyles.meta.copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _HeartButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paper.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedScale(
            duration: AppMotion.quick,
            curve: AppMotion.emphasized,
            scale: isFavorite ? 1.12 : 1.0,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 15,
              color: isFavorite ? AppColors.primary : AppColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}

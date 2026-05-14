import 'package:flutter/material.dart';
import '../../../config/app_theme.dart';
import '../../../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(String productId)? onProductTap;

  const ProductGrid({super.key, required this.products, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onTap: () => onProductTap?.call(products[index].id),
            onFavoriteTap: () {},
          );
        },
      ),
    );
  }
}